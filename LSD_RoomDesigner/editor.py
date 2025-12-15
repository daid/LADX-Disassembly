import binascii
import http.server
import urllib.parse
import sys
import os
import io
import json
import PIL.Image
import PIL.ImageDraw
from typing import List, Tuple, Union

sys.path.append(os.path.dirname(__file__) + "/../../LADXR/")
import romTables
import entityData
from roomEditor import RoomEditor, RoomTemplate
from roomInfo import RoomInfo
from tileDatabase import TileDatabase
import entityDatabase
import locations.constants


ALT_ROOMS = ["Alt06", "Alt0E", "Alt1B", "Alt2B", "Alt79", "Alt8C"]
MAP_NAMES = {
    -1: "Overworld",
    0: "D1", 1: "D2", 2: "D3", 3: "D4", 4: "D5", 5: "D6", 6: "D7", 7: "D8",
    8: "EGG",
    10: "CAVES_A",
    14: "SHOP",
    15: "MINIGAME",
    16: "HOUSE",
    17: "CAVES_B",
    18: "DOGHOUSE",
    19: "DREAM",
    20: "CASTLE",
    21: "MOBLIN_CAVE",
    22: "ARMOS_SHRINE",
    29: "LIBRARY",
    30: "GHOST_HOUSE",
    31: "CAVES_C",
}


class Editor:
    def __init__(self):
        self.room_data = []
        self.storage_filename = None
        self.__rom = romTables.ROMWithTables(open("../../LADX-Disassembly/azle.gbc", "rb"))
        self.__tile_cache = {}
        self.tile_db = TileDatabase()

    def export_full_json(self, filename: str):
        json.dump(self.room_data, open(filename, "wt"), indent=2)

    def export_game_data(self, filename: str):
        f = open(filename, "wt")
        f.write(f'#SECTION "RandomRoomData", ROMX, BANK[$0A] {{\n')
        f.write("_RandomRoomDataTable:\n")
        for type_idx in range(4):
            f.write(f'  db {len([room for room in self.room_data if room["type"] == type_idx])}\n')
            f.write(f'  dw RandomRoomDataTable{type_idx}\n')
        for type_idx in range(4):
            f.write(f'RandomRoomDataTable{type_idx}:\n')
            for idx, room in enumerate(self.room_data):
                if room['type'] == type_idx:
                    f.write(f'  dw random_room_{idx} ; {room["name"]}\n')
        for idx, room in enumerate(self.room_data):
            f.write(f'random_room_{idx}: ; {room["name"]}\n')
            re = RoomEditor(self.__rom, 0x100)
            re.buildObjectList(room['tiles'])
            raw_data = bytearray([room['animation'], re.floor_object])
            for obj in re.objects:
                raw_data += obj.export()
            if room['type'] == 0x02:  # Exit
                raw_data += bytearray([0xE1, 0x00, 0xFF, 0x58, 0x52]) # Add warp data
            assert len(raw_data) > 0
            f.write(f"  db ${room['filter_mask']:02X}, ${room['filter_value']:02X} ; allowed filter\n")
            f.write("  ; Primary data\n")
            f.write(f"  db {len(raw_data)}, " + ", ".join(f"${n:02X}" for n in raw_data) + "\n")
            f.write(f"  ; Variations\n")
            f.write(f"  db {len(room['variations'])}\n")
            for variation_idx, variation in enumerate(room['variations']):
                f.write(f"  db ${variation['chance']:02X}\n")
                f.write(f"  dw random_room_{idx}_variation_{variation_idx}\n")
            f.write(f"  ; Entity sets\n")
            f.write(f"  db {len(room['entity_sets'])}\n")
            for entity_set_idx, entity_set in enumerate(room['entity_sets']):
                f.write(f"  db ${entity_set['depth_min']:02X}, ${entity_set['depth_max']:02X}\n")
                f.write(f"  dw random_room_{idx}_entity_set_{entity_set_idx}\n")

            for variation_idx, variation in enumerate(room['variations']):
                tiles = [vt if vt >= 0 else (tt or 0x0C) for vt, tt in zip(variation['tiles'], RoomTemplate(0x0F).tiles)]
                re = RoomEditor(self.__rom, 0x100)
                re.buildObjectList(tiles)
                raw_data = bytearray()
                for obj in re.objects:
                    raw_data += obj.export()
                assert len(raw_data) > 0
                f.write(f"random_room_{idx}_variation_{variation_idx}:\n")
                f.write(f"  db {len(raw_data)}, " + ", ".join(f"${n:02X}" for n in raw_data) + "\n")

            for entity_set_idx, entity_set in enumerate(room['entity_sets']):
                f.write(f"random_room_{idx}_entity_set_{entity_set_idx}:\n")
                entities = entity_set['entities'].copy()
                if room['type'] == 0x02: # Exit
                    entities.append({"x": 0, "y": 0, "id": 0xE7})  # Add entity that handles the hole to the next room spawning
                f.write(f"  db {len(entities) * 2}\n")
                for entity in entities:
                    xy = entity['x'] | (entity['y'] << 4)
                    f.write(f"  db ${xy:02X}, ${entity['id']:02X}\n")

        f.write(f'}}\n')

    def import_full_json(self, filename: str):
        self.storage_filename = filename
        if os.path.exists(filename):
            self.room_data = json.load(open(filename, "rt"))
    
    def get_rooms(self):
        return [{"id": idx, "name": room['name']} for idx, room in enumerate(self.room_data)]

    def new_room(self):
        self.room_data.append({
            'id': len(self.room_data),
            'num': 0x100,
            'name': f"Room{len(self.room_data)}",
            'tiles': [n if n is not None else 0x0D for n in RoomTemplate(0x0F).tiles],
            'variations': [],
            'map_id': 0,
            'filter_mask': 0xD0,
            'filter_value': 0x00,
            'sidescroll': False,
            'tileset': 0xFF,
            'animation': 4,
            'entity_sets': [
                {"depth_min": 0, "depth_max": 255, "entities": []},
            ],
        })
        return {"id": len(self.room_data) - 1}

    def get_room_info(self, room_id):
        return self.room_data[room_id]

    def get_tileset_info(self, room_id):
        room = self.room_data[room_id]
        ri, animation_id = self._get_room_info(room)
        attributes = self._get_attributes(ri)
        result = []
        for tile_info in self.tile_db.get_list(room["num"], room["sidescroll"]):
            if tile_info.main_tileset and ri.main_tileset_id not in tile_info.main_tileset:
                continue
            if tile_info.animation and animation_id not in tile_info.animation:
                continue
            result.append({"id": tile_info.id, "attr":  binascii.hexlify(attributes[tile_info.id*4:tile_info.id*4+4]).decode("ascii")})
            if tile_info.bombable:
                result[-1]['bombable'] = True
        return result

    def get_entities_info(self):
        result = []
        for e in entityDatabase.entities_list:
            result.append({"id": e["id"], "name": entityData.NAME[e["id"]]})
        return result

    def render_tileset(self, room_id):
        room = self.room_data[room_id]
        ri, animation_id = self._get_room_info(room)

        metatiles = self.__rom.banks[ri.metatile_bank][ri.metatile_addr-0x4000:ri.metatile_addr-0x4000 + 0x400]
        attributes = self._get_attributes(ri)
        result = PIL.Image.new('RGBA', (16 * 16, 17 * 16))
        tileset = ri.getTileset(animation_id, switch_blocks=0xDB in room['tiles'] or 0xDC in room['tiles'])
        x = 0
        y = 0
        for tile_info in self.tile_db.get_list(room["num"], room["sidescroll"]):
            tile_nr = tile_info.id
            if tile_info.main_tileset and ri.main_tileset_id not in tile_info.main_tileset:
                continue
            if tile_info.animation and animation_id not in tile_info.animation:
                continue
            metatile = metatiles[tile_nr * 4:tile_nr * 4 + 4]
            attrtile = attributes[tile_nr * 4:tile_nr * 4 + 4]
            self.draw_tile(result, x * 16, y * 16, tileset[metatile[0]], attrtile[0], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16, tileset[metatile[1]], attrtile[1], ri.palette_addr)
            self.draw_tile(result, x * 16, y * 16 + 8, tileset[metatile[2]], attrtile[2], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16 + 8, tileset[metatile[3]], attrtile[3], ri.palette_addr)
            if tile_info.bombable:
                draw_text(result, x * 16, y * 16, "B")
            x += 1
            if x == 16:
                x = 0
                y += 1

        palette = self.get_palette(ri.palette_addr)
        draw = PIL.ImageDraw.Draw(result)
        for idx, pal in enumerate(palette):
            draw.rectangle((idx*8, 256, idx*8+7, 256+7), pal)
        palette = self.get_palette(ri.palette_addr + 2 * 4 * 8)
        for idx, pal in enumerate(palette[0:8]):
            draw.rectangle((idx*8, 256+8, idx*8+7, 256+15), pal)
        return result

    def render_entities(self, *, room_id=0x2B6):
        result = PIL.Image.new('RGBA', (16 * 16, 16 * 16), 0)
        x = 0
        y = 0
        for info in entityDatabase.entities_list:
            self.render_entity(info["id"], result, x * 16, y * 16, room_id=room_id)
            x += 1
            if x == 16:
                x = 0
                y += 1
        return result

    def render_entity(self, eid, target, x, y, *, room_id=0x2B6):
        info = entityDatabase.entities_dict[eid]
        sd = entityData.SPRITE_DATA[info["id"]] if info["id"] in entityData.SPRITE_DATA else None
        if callable(sd):
            class R:
                pass

            room = R()
            room.room = room_id
            sd = sd(room)
        if sd is None:
            sd = (1, 0x91)

        tileset = []
        for gfx_idx in range(1, len(sd), 2):
            gfx_nr = sd[gfx_idx]
            if isinstance(gfx_nr, set):
                gfx_nr = list(sorted(gfx_nr))[0]
            bank = [0x35, 0x31, 0x2E, 0x32][gfx_nr >> 6]
            addr = (gfx_nr & 0x3F) * 0x100
            for n in range(0, 16, 2):
                tileset.append((bank, addr + 0x10 * n))
        if "tiles" in info:
            for n in range(len(info["tiles"])):
                if isinstance(info["tiles"][n], tuple) or info["tiles"][n] >= 0:
                    a = tileset[info["tiles"][n]] if isinstance(info["tiles"][n], int) else info["tiles"][n]
                    b = (a[0], a[1] + 0x10)
                    if info["attr"][n] & 0x40:
                        a, b = b, a
                    if len(info["tiles"]) & 1:
                        self.draw_tile(target, x + 4, y, a, info["attr"][n], 0x5518, sprite=True)
                        self.draw_tile(target, x + 4, y + 8, b, info["attr"][n], 0x5518, sprite=True)
                    else:
                        self.draw_tile(target, x + (n % 2 * 8), y, a, info["attr"][n], 0x5518, sprite=True)
                        self.draw_tile(target, x + (n % 2 * 8), y + 8, b, info["attr"][n], 0x5518, sprite=True)
        else:
            draw_text(target, x, y, f"{eid:02X}")
            # for n, tile in enumerate(tileset):
            #     x = idx * 16 + (n // 32) * 8
            #     y = (n % 32) * 8
            #     self.drawSubtile(result, x, y, tile, 0, 0x5518)

    def render_room(self, room_id, entity_set_index, variation):
        room = self.room_data[room_id]
        ri, animation_id = self._get_room_info(room)

        metatiles = self.__rom.banks[ri.metatile_bank][ri.metatile_addr-0x4000:ri.metatile_addr-0x4000 + 0x400]
        attributes = self._get_attributes(ri)
        result = PIL.Image.new('RGBA', (8 * 20, 8 * 16))
        tileset = ri.getTileset(animation_id, switch_blocks=0xDB in room['tiles'] or 0xDC in room['tiles'])

        for vindex, tiles in enumerate([room['tiles']] + [v['tiles'] for v in room['variations']]):
            alpha = None if variation == vindex - 1 else 128
            for y in range(8):
                for x in range(10):
                    tile_nr = tiles[x + y * 10]
                    if tile_nr < 0:
                        continue
                    metatile = metatiles[tile_nr * 4:tile_nr * 4 + 4]
                    attrtile = attributes[tile_nr * 4:tile_nr * 4 + 4]
                    self.draw_tile(result, x * 16, y * 16, tileset[metatile[0]], attrtile[0], ri.palette_addr, alpha=alpha)
                    self.draw_tile(result, x * 16 + 8, y * 16, tileset[metatile[1]], attrtile[1], ri.palette_addr, alpha=alpha)
                    self.draw_tile(result, x * 16, y * 16 + 8, tileset[metatile[2]], attrtile[2], ri.palette_addr, alpha=alpha)
                    self.draw_tile(result, x * 16 + 8, y * 16 + 8, tileset[metatile[3]], attrtile[3], ri.palette_addr, alpha=alpha)
                    tile_info = self.tile_db.get(tile_nr, room["num"], room["sidescroll"])
                    if tile_info and tile_info.bombable:
                        draw_text(result, x * 16, y * 16, "B")
        for e in room["entity_sets"][entity_set_index]["entities"]:
            self.render_entity(e["id"], result, e["x"] * 16, e["y"] * 16, room_id=room_id)
        return result
    
    def _get_tileset_ids(self, room_id):
        room = self.room_data[room_id]
        main_tileset_options = None
        animation_options = None
        for tile_id in room['tiles']:
            tile_info = self.tile_db.get(tile_id, room["num"], room["sidescroll"])
            if not tile_info:
                continue
            if tile_info.main_tileset:
                if main_tileset_options:
                    main_tileset_options = tile_info.main_tileset.intersection(main_tileset_options)
                else:
                    main_tileset_options = tile_info.main_tileset
            if tile_info.animation:
                if animation_options:
                    animation_options = tile_info.animation.intersection(animation_options)
                else:
                    animation_options = tile_info.animation

        main_tileset_id = None
        animation_id = None
        if main_tileset_options is not None:
            if not main_tileset_options:
                print(f"Cannot find main tileset for {room_id}")
            else:
                main_tileset_id = next(iter(main_tileset_options))
        if animation_options is not None:
            if not animation_options:
                print(f"Cannot find animation for {room_id}")
            else:
                if 7 in animation_options and len(animation_options) > 1:
                    animation_options.remove(7)  # Do not use animation id 7 unless we really have to.
                animation_id = next(iter(animation_options))
        if room["tileset"] is not None:
            main_tileset_id = room["tileset"]
        if "animation" in room and room["animation"] is not None:
            animation_id = room["animation"]
        return main_tileset_id, animation_id

    def _get_room_info(self, room):
        ri = RoomInfo(self.__rom, room["num"], room["map_id"], room["sidescroll"])
        ri.main_tileset_id, animation_id = self._get_tileset_ids(room['id'])
        ri.palette_index = None
        if room["num"] < 0x100:
            bank, _, addr = room["attribute_table"].partition(":")
            ri.attribute_bank = int(bank, 16)
            ri.attribute_addr = int(addr, 16)
        return ri, animation_id

    def _get_attributes(self, ri):
        attributes = self.__rom.banks[ri.attribute_bank][ri.attribute_addr-0x4000:ri.attribute_addr-0x4000 + 0x400]
        return attributes

    def draw_tile(self, img, ox, oy, subtile_id, attr, palette_addr, *, sprite=False, alpha=None):
        if (subtile_id, attr, palette_addr) not in self.__tile_cache:
            result = PIL.Image.new("RGBA", (8, 8), (0, 0, 0, 0))
            palette = self.get_palette(palette_addr)[(attr&7)*4:(attr&7)*4+4]
            if subtile_id is not None:
                addr = subtile_id[1]
                tile_data = self.__rom.banks[subtile_id[0]][addr:addr+0x10]
                for y in range(8):
                    a = tile_data[y * 2]
                    b = tile_data[y * 2 + 1]
                    if attr & 0x40:
                        a = tile_data[14 - y * 2]
                        b = tile_data[15 - y * 2]
                    for x in range(8):
                        v = 0
                        bit = 0x80 >> x
                        if attr & 0x20:
                            bit = 0x01 << x
                        if a & bit:
                            v |= 0x01
                        if b & bit:
                            v |= 0x02
                        if not sprite or v != 0:
                            result.putpixel((x,y), palette[v])
            self.__tile_cache[(subtile_id, attr, palette_addr)] = result
        tile = self.__tile_cache[(subtile_id, attr, palette_addr)]
        if alpha:
            tile = tile.copy()
            tile.putalpha(alpha)
        img.paste(tile, (ox, oy), tile)

    def get_palette(self, palette_addr: int) -> List[Tuple[int, int, int]]:
        palette_addr -= 0x4000
        palette = []
        for n in range(8*4):
            p0 = self.__rom.banks[0x21][palette_addr]
            p1 = self.__rom.banks[0x21][palette_addr + 1]
            pal = p0 | p1 << 8
            palette_addr += 2
            r = (pal & 0x1F) << 3
            g = ((pal >> 5) & 0x1F) << 3
            b = ((pal >> 10) & 0x1F) << 3
            palette.append((r, g, b))
        return palette

    def render_unknown_tiles(self):
        if not self.tile_db.unknown_list:
            return b'No unknowns'
        result = PIL.Image.new('RGBA', (16 * 10, 16 * len(self.tile_db.unknown_list)))
        draw = PIL.ImageDraw.Draw(result)
        for idx, (tile, room_nr) in enumerate(self.tile_db.unknown_list):
            ri = RoomInfo(self.__rom, room_nr, self.room_data[room_nr]['map_id'], False)
            draw.text((2, idx * 16 + 1), f"{tile.id:02x}")

            metatiles = self.__rom.banks[ri.metatile_bank][ri.metatile_addr-0x4000:ri.metatile_addr-0x4000 + 0x400]
            attributes = self.__rom.banks[ri.attribute_bank][ri.attribute_addr-0x4000:ri.attribute_addr-0x4000 + 0x400]
            tileset = ri.getTileset(0)
            metatile = metatiles[tile.id * 4:tile.id * 4 + 4]
            attrtile = attributes[tile.id * 4:tile.id * 4 + 4]
            x = 1
            y = idx
            self.draw_tile(result, x * 16, y * 16, tileset[metatile[0]], attrtile[0], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16, tileset[metatile[1]], attrtile[1], ri.palette_addr)
            self.draw_tile(result, x * 16, y * 16 + 8, tileset[metatile[2]], attrtile[2], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16 + 8, tileset[metatile[3]], attrtile[3], ri.palette_addr)

            tileset = ri.getTileset(0x0B)
            metatile = metatiles[tile.id * 4:tile.id * 4 + 4]
            attrtile = attributes[tile.id * 4:tile.id * 4 + 4]
            x = 2
            self.draw_tile(result, x * 16, y * 16, tileset[metatile[0]], attrtile[0], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16, tileset[metatile[1]], attrtile[1], ri.palette_addr)
            self.draw_tile(result, x * 16, y * 16 + 8, tileset[metatile[2]], attrtile[2], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16 + 8, tileset[metatile[3]], attrtile[3], ri.palette_addr)

            ri.main_tileset_id = 0xFF
            tileset = ri.getTileset(0x0B)
            metatile = metatiles[tile.id * 4:tile.id * 4 + 4]
            attrtile = attributes[tile.id * 4:tile.id * 4 + 4]
            x = 3
            self.draw_tile(result, x * 16, y * 16, tileset[metatile[0]], attrtile[0], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16, tileset[metatile[1]], attrtile[1], ri.palette_addr)
            self.draw_tile(result, x * 16, y * 16 + 8, tileset[metatile[2]], attrtile[2], ri.palette_addr)
            self.draw_tile(result, x * 16 + 8, y * 16 + 8, tileset[metatile[3]], attrtile[3], ri.palette_addr)

            draw.text((70, idx * 16 + 1), f"{room_nr:03x}")

        return result

editor = Editor()


def to_room_id(room_id: str) -> Union[int, str]:
    try:
        return int(room_id)
    except ValueError:
        return room_id


class RequestHandler(http.server.SimpleHTTPRequestHandler):
    def __init__(self, *args, **kwargs):
        super().__init__(*args, directory=".", **kwargs)

    def do_GET(self):
        parts = urllib.parse.urlsplit(self.path)
        if parts.path == "/render_room":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["entity_set"][0])
            variation = int(query["variation"][0])
            self.send_reply(editor.render_room(room_id, entities_set, variation).convert("RGBA").tobytes())
        elif parts.path == "/render_tileset":
            self.send_reply(editor.render_tileset(to_room_id(parts.query)).convert("RGBA").tobytes())
        elif parts.path == "/render_entities":
            self.send_reply(editor.render_entities(room_id=to_room_id(parts.query)).convert("RGBA").tobytes())
        elif parts.path == "/unknown_tiles":
            self.send_reply(editor.render_unknown_tiles())
        elif parts.path == "/rooms":
            self.send_reply(editor.get_rooms())
        elif parts.path == "/room_info":
            self.send_reply(editor.get_room_info(to_room_id(parts.query)))
        elif parts.path == "/get_tileset_info":
            self.send_reply(editor.get_tileset_info(to_room_id(parts.query)))
        elif parts.path == "/get_entities_info":
            self.send_reply(editor.get_entities_info())
        elif parts.path == "/new_room":
            self.send_reply(editor.new_room())
        elif parts.path == "/update_room_tile":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["entity_set"][0])
            variation = int(query["variation"][0])
            x, y = int(query["x"][0]), int(query["y"][0])
            if variation < 0:
                editor.room_data[room_id]['tiles'][x+y*10] = int(query["tile"][0])
            else:
                editor.room_data[room_id]['variations'][variation]['tiles'][x+y*10] = int(query["tile"][0])
            self.send_reply(editor.render_room(room_id, entities_set, variation).convert("RGBA").tobytes())
        elif parts.path == "/save":
            editor.export_full_json(editor.storage_filename)
            editor.export_game_data("../LSD/roomdata.asm")
            print("Saved")
            self.send_reply(b"SAVED")
        elif parts.path == "/update_room_entity":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["entity_set"][0])
            variation = int(query["variation"][0])
            x, y = int(query["x"][0]), int(query["y"][0])
            entity = int(query["entity"][0])
            room = editor.room_data[room_id]
            found = False
            for idx, e in enumerate(room["entity_sets"][entities_set]["entities"]):
                if e["x"] == x and e["y"] == y:
                    room["entity_sets"][entities_set]["entities"].pop(idx)
                    found = True
            if not found:
                room["entity_sets"][entities_set]["entities"].append({"x": x, "y": y, "id": entity})
            self.send_reply(editor.render_room(room_id, entities_set, variation).convert("RGBA").tobytes())
        elif parts.path == "/update_room_data":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["entity_set"][0])
            variation = int(query["variation"][0])
            key = query['key'][0]
            value = query['value'][0] if 'value' in query else ''
            try:
                value = int(value)
            except ValueError:
                pass
            editor.room_data[room_id][key] = value
            self.send_reply(editor.render_room(room_id, entities_set, variation).convert("RGBA").tobytes())
        elif parts.path == "/del_entity_set":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["entity_set"][0])
            editor.room_data[room_id]["entity_sets"].pop(entities_set)
            self.send_reply(b"DONE")
        elif parts.path == "/add_entity_set":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            editor.room_data[room_id]["entity_sets"].append({"depth_min": 0, "depth_max": 255, "entities": []})
            self.send_reply(b"DONE")
        elif parts.path == "/del_variation":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["variation"][0])
            editor.room_data[room_id]["variations"].pop(entities_set)
            self.send_reply(b"DONE")
        elif parts.path == "/add_variation":
            query = urllib.parse.parse_qs(parts.query)
            room_id = to_room_id(query['room'][0])
            editor.room_data[room_id]["variations"].append({"chance": 128, "tiles": [-1] * 80})
            self.send_reply(b"DONE")
        elif parts.path == "/update_entity_set_data":
            query = urllib.parse.parse_qs(parts.query)
            if "value" not in query:
                return self.send_reply(b"ERR")
            room_id = to_room_id(query['room'][0])
            entities_set = int(query["entity_set"][0])
            key = query['key'][0]
            value = int(query['value'][0])
            editor.room_data[room_id]["entity_sets"][entities_set][key] = value
            self.send_reply(b"DONE")
        else:
            super().do_GET()

    def send_reply(self, data: Union[PIL.Image.Image, bytes, list, dict]):
        if isinstance(data, PIL.Image.Image):
            buffer = io.BytesIO()
            data.save(buffer, "png")
            data = buffer.getvalue()
        if isinstance(data, dict) or isinstance(data, list):
            data = json.dumps(data).encode("ascii")
        self.send_response(http.HTTPStatus.OK)
        self.send_header("Content-Length", str(len(data)))
        self.end_headers()
        self.wfile.write(data)

    def log_message(self, fmt, *args):
        pass


def draw_text(image, x, y, s):
    draw = PIL.ImageDraw.Draw(image)
    for xo in range(3):
        for yo in range(3):
            draw.text((x + 1 + xo, y + yo), s, (0, 0, 0))
    draw.text((x + 2, y + 1), s, (255, 255, 255))


def main():
    editor.import_full_json("rooms.json")
    server = http.server.ThreadingHTTPServer(("127.0.0.1", 8000), RequestHandler)
    server.serve_forever()


if __name__ == '__main__':
    main()
