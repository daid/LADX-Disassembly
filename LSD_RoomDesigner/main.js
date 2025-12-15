"use strict";
var current_room;
var current_room_image;
var entity_set_index = 0;
var variation = -1;
var input_entity_set_depth_min;
var input_entity_set_depth_max;
var tileset_image;
var tileset_info;
var entities_image;
var entities_info;
var selected_tile;
var selected_entity;
async function save() {
    await fetch(`/save`);
    console.log("Saved");
}
async function load_room_edit(room_id) {
    current_room = await(await fetch(`/room_info?${room_id}`)).json();

    document.getElementById("content").innerHTML = "";

    var canvas = canvasElement(160, 128, 2);
    canvas.id = "map";
    document.getElementById("content").appendChild(canvas);

    canvas = canvasElement(256, 256+16, 2);
    canvas.id = "tileset";
    document.getElementById("content").appendChild(canvas);
    canvas = canvasElement(256, 256, 2);
    canvas.id = "entities";
    document.getElementById("content").appendChild(canvas);
    document.getElementById("header").innerHTML = `<button onclick='load_room_selection()'>To rooms</button><button onclick='save()'>Save</button>`;

    entities_info = await(await fetch(`/get_entities_info`)).json();
    var image = await fetch(`/render_entities?${current_room.id}`);
    entities_image = new ImageData(new Uint8ClampedArray(await image.bytes()), 256, 256);
    draw_entities_image();

    var image = await fetch(`/render_room?room=${current_room.id}&entity_set=${entity_set_index}&variation=${variation}`);
    current_room_image = new ImageData(new Uint8ClampedArray(await image.bytes()), 160, 128);
    draw_current_room();
    await update_tileset_image();

    document.getElementById(`tileset`).onmousedown = function(e) {
        var [x, y] = get_tile_clicked(e);
        selected_tile = tileset_info[x + y * 16];
        selected_entity = undefined;
        info.innerText = JSON.stringify(selected_tile);
        draw_tileset_image();
        draw_entities_image();
    };
    document.getElementById(`entities`).onmousedown = function(e) {
        var [x, y] = get_tile_clicked(e);
        selected_tile = undefined;
        selected_entity = entities_info[x + y * 16];
        info.innerText = JSON.stringify(selected_entity);
        draw_tileset_image();
        draw_entities_image();
    };
    document.getElementById(`map`).onmousedown = async function(e) {
        var [x, y] = get_tile_clicked(e);
        if (selected_tile !== undefined) {
            var tile_id = selected_tile.id;
            if (e.buttons != 1 && variation >= 0) tile_id = -1;
            var image = await fetch(`/update_room_tile?room=${current_room.id}&entity_set=${entity_set_index}&variation=${variation}&x=${x}&y=${y}&tile=${tile_id}`);
            current_room_image = new ImageData(new Uint8ClampedArray(await image.bytes()), 160, 128);
            draw_current_room();
        }
        if (selected_entity !== undefined) {
            var image = await fetch(`/update_room_entity?room=${current_room.id}&entity_set=${entity_set_index}&variation=${variation}&x=${x}&y=${y}&entity=${selected_entity.id}`);
            current_room_image = new ImageData(new Uint8ClampedArray(await image.bytes()), 160, 128);
            draw_current_room();
        }
    };
    document.getElementById(`map`).oncontextmenu = function(e) { e.preventDefault(); return false; };
    document.getElementById(`map`).onmousemove = function(e) { if (e.buttons != 0) e.target.onmousedown(e); };
    var info = document.createElement("div");
    info.id = "info";
    document.getElementById("content").appendChild(info);

    var span = document.createElement("div");
    span.appendChild(document.createTextNode("Variation:"));
    var select = document.createElement("select");
    span.appendChild(select);
    addSelectOption(select, -1, "None");
    for(var index in current_room.variations) {
        addSelectOption(select, index, index);
    }
    select.selectedIndex = variation + 1;
    select.oninput = async function(e) {
        variation = parseInt(e.target.value);
        await load_room_edit(current_room.id);
    };
    if (variation > -1) {
        span.appendChild(document.createTextNode("Chance:"));
        var input_variation_chance = document.createElement("input");
        input_variation_chance.value = current_room.variations[variation].chance;
        input_variation_chance.oninput = async function() {
            await fetch(`/update_entity_set_data?room=${current_room.id}&entity_set=${entity_set_index}&key=depth_max&value=${input_entity_set_depth_max.value}`);
        }
        input_variation_chance.style.width = "30px";
        span.appendChild(input_variation_chance);
        var delete_variation = document.createElement("button");
        delete_variation.innerText = "delete";
        delete_variation.onclick = async function() {
            if (variation < 0) return;
            await fetch(`/del_variation?room=${current_room.id}&variation=${variation}`);
            variation = -1;
            await load_room_edit(current_room.id);
        };
        span.appendChild(delete_variation);
    }
    var add_variation = document.createElement("button");
    add_variation.innerText = "add";
    add_variation.onclick = async function() {
        variation = current_room.variations.length;
        await fetch(`/add_variation?room=${current_room.id}`);
        await load_room_edit(current_room.id);
    };
    span.appendChild(add_variation);
    document.getElementById("content").appendChild(span);

    var span = document.createElement("div");
    span.appendChild(document.createTextNode("Entity set:"));
    var select = document.createElement("select");
    span.appendChild(select);
    for(var index in current_room.entity_sets) {
        addSelectOption(select, index, index);
    }
    select.selectedIndex = entity_set_index;
    select.oninput = async function(e) {
        entity_set_index = e.target.selectedIndex;
        await load_room_edit(current_room.id);
    };
    span.appendChild(document.createTextNode("Depth min:"));
    input_entity_set_depth_min = document.createElement("input");
    input_entity_set_depth_min.value = current_room.entity_sets[entity_set_index].depth_min;
    input_entity_set_depth_min.oninput = async function() {
        await fetch(`/update_entity_set_data?room=${current_room.id}&entity_set=${entity_set_index}&key=depth_min&value=${input_entity_set_depth_min.value}`);
    }
    input_entity_set_depth_min.style.width = "30px";
    span.appendChild(input_entity_set_depth_min);
    span.appendChild(document.createTextNode("Depth max:"));
    input_entity_set_depth_max = document.createElement("input");
    input_entity_set_depth_max.value = current_room.entity_sets[entity_set_index].depth_max;
    input_entity_set_depth_max.oninput = async function() {
        await fetch(`/update_entity_set_data?room=${current_room.id}&entity_set=${entity_set_index}&key=depth_max&value=${input_entity_set_depth_max.value}`);
    }
    input_entity_set_depth_max.style.width = "30px";
    span.appendChild(input_entity_set_depth_max);
    var delete_entity_set = document.createElement("button");
    delete_entity_set.innerText = "delete";
    delete_entity_set.onclick = async function() {
        if (entity_set_index == 0) return;
        await fetch(`/del_entity_set?room=${current_room.id}&entity_set=${entity_set_index}`);
        entity_set_index = 0;
        await load_room_edit(current_room.id);
    };
    span.appendChild(delete_entity_set);
    var add_entity_set = document.createElement("button");
    add_entity_set.innerText = "add";
    add_entity_set.onclick = async function() {
        entity_set_index = current_room.entity_sets.length;
        await fetch(`/add_entity_set?room=${current_room.id}`);
        await load_room_edit(current_room.id);
    };
    span.appendChild(add_entity_set);
    document.getElementById("content").appendChild(span);

    var span = document.createElement("div");
    span.appendChild(document.createTextNode("Filter:"));
    span.appendChild(filterOption("Right", 0x01));
    span.appendChild(filterOption("Left", 0x02));
    span.appendChild(filterOption("Down", 0x04));
    span.appendChild(filterOption("Up", 0x08));
    document.getElementById("content").appendChild(span);

    document.getElementById("content").appendChild(roomDataSelector("Type", "type", room_type_table));
    if (current_room.num < 0x100) {
        document.getElementById("content").appendChild(roomDataSelector("Tileset", "tileset", overworld_tileset_table));
        document.getElementById("content").appendChild(roomDataSelector("Attrib", "attribute_table", overworld_attr_table));
        document.getElementById("content").appendChild(roomDataSelector("Palette", "palette_index", palette_index_table));
    } else {
        document.getElementById("content").appendChild(roomDataSelector("Tileset", "tileset", underworld_tileset_table));
        document.getElementById("content").appendChild(roomDataSelector("Event", "event", event_table));
        //if (current_room.palette_index !== null)
        //    document.getElementById("content").appendChild(roomDataSelector("Palette", "palette_index", underworld_palette_index_table));
    }
    document.getElementById("content").appendChild(roomDataSelector("Animation", "animation", animation_table));
}

async function new_room() {
    var info = await (await fetch(`/new_room`)).json();
    entity_set_index = 0;
    variation = -1;
    await load_room_edit(info.id);
}

async function load_room_selection() {
    var info = await (await fetch(`/rooms`)).json();
    var html = "";
    for(var room of info) {
        html += `<button onclick='entity_set_index = 0; variation = -1; load_room_edit(${room.id})'>${room.name}</button><br>`;
    }
    document.getElementById("content").innerHTML = html;
    document.getElementById("header").innerHTML = `<button onclick='new_room()'>New Room</button><button onclick='save()'>Save</button>`;
}
load_room_selection();


function draw_current_room() {
    var canvas = document.getElementById(`map`);
    var ctx = canvas.getContext("2d");
    ctx.putImageData(current_room_image, 0, 0);
}

function draw_tileset_image() {
    var canvas = document.getElementById(`tileset`);
    var ctx = canvas.getContext("2d");
    ctx.putImageData(tileset_image, 0, 0);
    for(var idx=0; idx<tileset_info.length; idx++) {
        if (tileset_info[idx] == selected_tile) {
            var x = idx % 16;
            var y = ~~(idx / 16);
            ctx.strokeStyle = "red";
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.rect(x*16, y*16, 16, 16);
            ctx.stroke();
        }
    }
}

function draw_entities_image() {
    var canvas = document.getElementById(`entities`);
    var ctx = canvas.getContext("2d");
    ctx.putImageData(entities_image, 0, 0);
    for(var idx=0; idx<entities_info.length; idx++) {
        if (entities_info[idx] == selected_entity) {
            var x = idx % 16;
            var y = ~~(idx / 16);
            ctx.strokeStyle = "red";
            ctx.lineWidth = 2;
            ctx.beginPath();
            ctx.rect(x*16, y*16, 16, 16);
            ctx.stroke();
        }
    }
}

async function update_tileset_image()
{
    var image = await fetch(`/render_tileset?${current_room.id}`);
    tileset_info = await(await fetch(`/get_tileset_info?${current_room.id}`)).json();
    tileset_image = new ImageData(new Uint8ClampedArray(await image.bytes()), 256, 256+16);
    draw_tileset_image();
}

function to_hex(num, length) {
    var s = num.toString(16).toUpperCase();
    while(s.length < length)
        s = "0" + s;
    return s;
}

function draw_hex2(ctx, x, y, num) {
    num = to_hex(num, 2);
    ctx.font = "12px monospace";
    ctx.fillStyle = "white";
    for(var yo of [9.5, 10.5, 11.5]) {
        for(var xo of [0.5, 1.5, 2.5]) {
            ctx.fillText(num, x * 16 + xo, y * 16 + yo);
        }
    }
    ctx.fillStyle = "black";
    ctx.fillText(num, x * 16 + 1.5, y * 16 + 10.5);
}

function get_tile_clicked(e) {
    var rect = e.target.getBoundingClientRect();
    var x = (e.clientX - rect.left) * window.devicePixelRatio;
    var y = (e.clientY - rect.top) * window.devicePixelRatio;
    return [~~(x/32), ~~(y/32)]
}

function canvasElement(w, h, scale, style) {
    w = w || 160;
    h = h || 128;
    scale = (scale || 1) / window.devicePixelRatio;
    var canvas = document.createElement("canvas");
    canvas.width = w;
    canvas.height = h;
    canvas.style.width = `${w * scale}px`;
    canvas.style.height = `${h * scale}px`;
    return canvas;
}

function createTable(data) {
    var table = document.createElement("table");
    for(var row of data) {
        var tr = document.createElement("tr");
        for(var col of row) {
            var td = document.createElement("td");
            if (col)
                td.appendChild(col);
            tr.appendChild(td);
        }
        table.appendChild(tr);
    }
    table.style.display = 'inline-block';
    return table
}

function roomDataSelector(label, key, table) {
    var span = document.createElement("div");
    span.appendChild(document.createTextNode(label));
    var select = document.createElement("select");
    span.appendChild(select);
    for(var option of table) {
        addSelectOption(select, option.value, option.label);
    }
    for(var idx in select.options) {
        if (select.options[idx].value == current_room[key])
            select.selectedIndex = idx;
    }
    select.oninput = async function(e) {
        var image = await fetch(`/update_room_data?room=${current_room.id}&entity_set=${entity_set_index}&variation=${variation}&key=${key}&value=${select.value}`);
        current_room_image = new ImageData(new Uint8ClampedArray(await image.bytes()), 160, 128);
        draw_current_room();
        await update_tileset_image();
    };
    return span;
}

function filterOption(label, mask) {
    var span = document.createElement("span");
    span.appendChild(document.createTextNode(label));
    var select = document.createElement("select");
    addSelectOption(select, "-1", "Any");
    addSelectOption(select, "0", "No");
    addSelectOption(select, "1", "Yes");
    if (current_room.filter_mask & mask) {
        if (current_room.filter_value & mask) {
            select.selectedIndex = 2;
        } else {
            select.selectedIndex = 1;
        }
    } else {
        select.selectedIndex = 0;
    }
    select.oninput = async function(e) {
        switch(select.selectedIndex) {
        case 0:
            current_room.filter_mask &=~mask;
            current_room.filter_value &=~mask;
            break;
        case 1:
            current_room.filter_mask |= mask;
            current_room.filter_value &=~mask;
            break;
        case 2:
            current_room.filter_mask |= mask;
            current_room.filter_value |= mask;
            break;
        }
        await fetch(`/update_room_data?room=${current_room.id}&entity_set=${entity_set_index}&variation=${variation}&key=filter_mask&value=${current_room.filter_mask}`);
        await fetch(`/update_room_data?room=${current_room.id}&entity_set=${entity_set_index}&variation=${variation}&key=filter_value&value=${current_room.filter_value}`);
    };
    span.appendChild(select);
    return span
}

function addSelectOption(select, value, label) {
    var opt = document.createElement('option');
    opt.value = value;
    opt.innerText = label;
    select.appendChild(opt);
    return opt;
}

var palette_index_table = [
    {"value": 0x00, "label": "00: Mysterious Forest"},
    {"value": 0x01, "label": "01: Toronbo Shores"},
    {"value": 0x02, "label": "02: South of the Village (ext: L1 Tail Cave)"},
    {"value": 0x03, "label": "03: Mabe Village, South of the Village"},
    {"value": 0x04, "label": "04: Signpost Maze, Pothole Field, Ukuku Prairie (ext: L3 Key Cavern, Richard's Villa)"},
    {"value": 0x05, "label": "05: Ukuku Prairie (beehive, skull rock)"},
    {"value": 0x06, "label": "06: Kanalet Castle"},
    {"value": 0x07, "label": "07: Tabahl Wasteland, Cemetary, Koholint Prairie (ext: Camera Shop, Crazy Tracy, Witch's Hut)"},
    {"value": 0x08, "label": "08: Tal Tal Heights (ext: Raft Shop, pit south of the Ghost's gravestone)"},
    {"value": 0x09, "label": "Martha's Bay, Ukuku Prairie (ext: L5 Catfish's Maw, House by the Bay)"},
    {"value": 0x0A, "label": "Ukuku Prairie (ext: Seashell Mansion)"},
    {"value": 0x0B, "label": "Face Shrine"},
    {"value": 0x0C, "label": "Animal Village, East of the Bay"},
    {"value": 0x0D, "label": "Yarna Desert, East of the Bay"},
    {"value": 0x0E, "label": "Goponga Swamp (ext: L2 Bottle Grotto)"},
    {"value": 0x0F, "label": "Tal Tal Mountain Range"},
    {"value": 0x10, "label": "Goponga Swamp West"},
    {"value": 0x11, "label": "Rapids Ride, Tal Tal Heights"},
    {"value": 0x12, "label": "Face Shrine South"},
    {"value": 0x13, "label": "Mt. Tamaranch (ext: Wind Fish's Egg)"},
    {"value": 0x14, "label": "Mt. Tamaranch, Tal Tal Mountain Range (bridge west)"},
    {"value": 0x15, "label": "Tal Tal Mountain Range (ext: Hen House)"},
    {"value": 0x16, "label": "Tal Tal Mountain Range (ext: L7 Eagle's Tower)"},
    {"value": 0x17, "label": "Tal Tal Heights (ext: L4 Angler's Tunner)"},
    {"value": 0x18, "label": "Toronbo Shores (ext: Sale's House o' Bananas)"},
    {"value": 0x19, "label": "Tal Tal Mountain Range (ext: L8 Turtle Rock)"},
    {"value": 0x1A, "label": "Kanalet Castle (Kiki's bridge)"},
    {"value": 0x1B, "label": "Animal Village (ext: Christine's house)"},
    {"value": 0x1C, "label": "Martha's Bay (North of L3 Key Cavern)"},
    {"value": 0x1D, "label": "Face Shrine North (ext: L6 Face Shrine)"},
    {"value": 0x1E, "label": "Mabe Village (ext: Ulrira's House)"},
]
var underworld_palette_index_table = [
    {"value": 0x00, "label": "00: "},
    {"value": 0x01, "label": "01: "},
    {"value": 0x02, "label": "02: "},
    {"value": 0x03, "label": "03: "},
    {"value": 0x04, "label": "04: "},
    {"value": 0x05, "label": "05: "},
    {"value": 0x06, "label": "06: "},
    {"value": 0x07, "label": "07: "},
    {"value": 0x08, "label": "08: "},
    {"value": 0x09, "label": "09: "},
    {"value": 0x0A, "label": "0A: "},
    {"value": 0x0B, "label": "0B: "},
    {"value": 0x0C, "label": "0C: "},
    {"value": 0x0D, "label": "0E: "},
    {"value": 0x0E, "label": "0D: "},
    {"value": 0x0F, "label": "0F: "},
    {"value": 0x10, "label": "10: "},
    {"value": 0x11, "label": "11: "},
    {"value": 0x12, "label": "12: "},
    {"value": 0x13, "label": "13: "},
    {"value": 0x14, "label": "14: "},
    {"value": 0x15, "label": "15: "},
    {"value": 0x16, "label": "16: "},
    {"value": 0x17, "label": "17: "},
    {"value": 0x18, "label": "18: "},
    {"value": 0x19, "label": "19: "},
    {"value": 0x1A, "label": "1A: "},
    {"value": 0x1B, "label": "1B: "},
    {"value": 0x1C, "label": "1C: "},
    {"value": 0x1D, "label": "1E: "},
    {"value": 0x1E, "label": "1D: "},
    {"value": 0x1F, "label": "1F: "},
    {"value": 0x20, "label": "20: "},
    {"value": 0x21, "label": "21: "},
    {"value": 0x22, "label": "22: "},
]
var overworld_tileset_table = [
    {"value": 0x0F, "label": "No change"},
    {"value": 0x1A, "label": "1A: CAMERA_SHOP"},
    {"value": 0x1C, "label": "1C: TURTLE_ROCK"},
    {"value": 0x1E, "label": "1E: SEASHELL_MANSION"},
    {"value": 0x20, "label": "20: MYSTERIOUS_WOODS"},
    {"value": 0x22, "label": "22: BEACH"},
    {"value": 0x24, "label": "24: PRAIRIE_STONE_HEAD"},
    {"value": 0x26, "label": "26: MABE_VILLAGE"},
    {"value": 0x28, "label": "28: KANALET_CASTLE"},
    {"value": 0x2A, "label": "2A: FACE_SHRINE"},
    {"value": 0x2C, "label": "2C: YARNA_DESERT"},
    {"value": 0x2E, "label": "2E: PRAIRIE_SOUTH"},
    {"value": 0x30, "label": "30: EAGLES_TOWER"},
    {"value": 0x32, "label": "32: RAFTING_GAME"},
    {"value": 0x34, "label": "34: ANGLERS_TUNNEL"},
    {"value": 0x36, "label": "36: GOPONGO_SWAMP"},
    {"value": 0x38, "label": "38: GRAVEYARD"},
    {"value": 0x3A, "label": "3A: MARTHAS_BAY"},
    {"value": 0x3C, "label": "3C: EGG"},
    {"value": 0x3E, "label": "3E: TARAMANCH_MIDDLE"},
]
var overworld_attr_table = [
    {'value': '22:4000', 'label': '22:4000 0F 26 TOWN Purple'},
    {'value': '22:4400', 'label': '22:4400 26 TOWN Gray'},
    {'value': '22:4800', 'label': '22:4800 26 TOWN Blue'},
    {'value': '22:4c00', 'label': '22:4C00 24'},
    {'value': '22:5000', 'label': '22:5000 22 3A Beach'},
    {'value': '22:5400', 'label': '22:5400 2E'},
    {'value': '22:5800', 'label': '22:5800 2E'},
    {'value': '22:5c00', 'label': '22:5C00 26'},
    {'value': '22:6000', 'label': '22:6000 0F 2A 3A'},
    {'value': '22:6400', 'label': '22:6400 0F 3A'},
    {'value': '22:6800', 'label': '22:6800 0F 26'},
    {'value': '22:6c00', 'label': '22:6C00 2C DESERT'},
    {'value': '22:7000', 'label': '22:7000 26 TOWN Pink'},
    {'value': '22:7400', 'label': '22:7400 36 SWAMP'},
    {'value': '22:7800', 'label': '22:7800 0F'},
    {'value': '22:7c00', 'label': '22:7C00 0F 1A'},
    {'value': '25:4000', 'label': '25:4000 20 WOODS A'},
    {'value': '25:4400', 'label': '25:4400 0F WOODS B'},
    {'value': '25:4800', 'label': '25:4800 26 TOWN Blue'},
    {'value': '25:4c00', 'label': '25:4C00 0F 26 TOWN Red'},
    {'value': '25:5000', 'label': '25:5000 0F 28 CASTLE Red'},
    {'value': '25:5400', 'label': '25:5400 28 CASTLE Blue'},
    {'value': '25:5800', 'label': '25:5800 28 CASTLE Red'},
    {'value': '25:5c00', 'label': '25:5C00 24 3A'},
    {'value': '25:6400', 'label': '25:6400 1E'},
    {'value': '25:6800', 'label': '25:6800 0F 38'},
    {'value': '25:6c00', 'label': '25:6C00 38'},
    {'value': '25:7000', 'label': '25:7000 38'},
    {'value': '25:7400', 'label': '25:7400 1C 3E TALTAL'},
    {'value': '25:7800', 'label': '25:7800 1C TALTAL phone'},
    {'value': '25:7c00', 'label': '25:7C00 2A ARMOS'},
    {'value': '27:5220', 'label': '27:5220 0F'},
    {'value': '27:5620', 'label': '27:5620 3C 3E EGG'},
    {'value': '27:5a20', 'label': '27:5A20 30 3E TALTAL MID'},
    {'value': '27:5e40', 'label': '27:5E40 30 EAGLE TOWER'},
    {'value': '27:6240', 'label': '27:6240 3E'},
    {'value': '27:6640', 'label': '27:6640 0F 34'},
    {'value': '27:6a40', 'label': '27:6A40 3E'},
    {'value': '27:6e40', 'label': '27:6E40 32 RAPIDS'},
]
var animation_table = [
    {'value': 0x00, 'label': '00: NONE'},
    {'value': 0x02, 'label': '02: TIDE'},
    {'value': 0x03, 'label': '03: VILLAGE'},
    {'value': 0x04, 'label': '04: DUNGEON_1'},
    {'value': 0x05, 'label': '05: UNDERGROUND'},
    {'value': 0x06, 'label': '06: LAVA'},
    {'value': 0x07, 'label': '07: DUNGEON_2'},
    {'value': 0x08, 'label': '08: QUICKSAND'},
    {'value': 0x09, 'label': '09: CURRENTS'},
    {'value': 0x0A, 'label': '0A: WATER WATERFALL RAPIDS1'},
    {'value': 0x0B, 'label': '0B: WATER WATERFALL SKYLINE'},
    {'value': 0x0C, 'label': '0C: WATER_DUNGEON'},
    {'value': 0x0D, 'label': '0D: LIGHT_BEAM'},
    {'value': 0x0E, 'label': '0E: CRYSTAL_BLOCK'},
    {'value': 0x0F, 'label': '0F: BUBBLES'},
    {'value': 0x10, 'label': '10: WEATHER_VANE'},
]
var underworld_tileset_table = [
    {"value": 0xFF, "label": "FF: No change"},
    {"value": 0x00, "label": "00: BOSS DOOR, STAIRS UP"},
    {"value": 0x01, "label": "01: DUNGEON ENTRANCE"},
    {"value": 0x02, "label": "02: FLIPDOOR, KEYBLOCK, STAIRS UP"},
    {"value": 0x03, "label": "03: KNIGHT IN WALL"},
    {"value": 0x04, "label": "04: SHOP"},
    {"value": 0x05, "label": "05: CAVE"},
    {"value": 0x06, "label": "06: BOSS DOOR, KEYBLOCK"},
    {"value": 0x07, "label": "07: KEYBLOCK, WALLSTAIRS UP, HOOK-BRIDGE"},
    {"value": 0x08, "label": "08: HOUSE"},
    {"value": 0x09, "label": "09: KEYBLOCK, CRYSTAL BLOCK, PUZZLE TILE"},
    {"value": 0x0A, "label": "0A: KEYBLOCK, CRYSTAL BLOCK, STAIRS UP"},
    {"value": 0x0B, "label": "0B: FLIPDOOR, WALLSTAIRS DOWN, STAIRS UP"},
    {"value": 0x0C, "label": "0C: CAVE, CRYSTAL BLOCK"},
    {"value": 0x0D, "label": "0D: HOOKSHOT BRIDGE"},
    {"value": 0x0E, "label": "0E: BOSSDOOR, WALLSTAIRS UP"},
    {"value": 0x0F, "label": "0F: MAD BATTER"},
    {"value": 0x17, "label": "17: BOSSDOOR, WALLSTAIRS UP"},
    {"value": 0x18, "label": "18: MAMU"},
    {"value": 0x19, "label": "19: FAIRY"},
    {"value": 0x1A, "label": "1A: WINDFISH FLOOR"},
]
var event_table = [
    {"value": 0x00, "label": "00: None"},
    {"value": 0x0D, "label": "0D: THROW POT AT CHEST"},
    {"value": 0x21, "label": "21: KILL ENEMIES: OPEN DOOR"},
    {"value": 0x22, "label": "22: PUSH BLOCK: OPEN DOOR"},
    {"value": 0x23, "label": "23: BUTTON: OPEN DOOR"},
    {"value": 0x25, "label": "25: LIGHT TORCHES: OPEN DOOR"},
    {"value": 0x29, "label": "29: PUZZLE TILES: OPEN DOOR"},
    {"value": 0x2A, "label": "2A: SIDESCROLL BOSS DEAD: OPEN DOOR"},
    {"value": 0x2B, "label": "2B: THROW AT DOOR: OPEN DOOR"},
    {"value": 0x2C, "label": "2C: HORSE HEADS: OPEN DOOR"},
    {"value": 0x45, "label": "45: LIGHT TORCHES: KILL ENEMIES"},
    {"value": 0x48, "label": "48: KILL 'SPECIAL': KILL ENEMIES"},
    {"value": 0x61, "label": "61: KILL ENEMIES: REVEAL CHEST"},
    {"value": 0x63, "label": "63: BUTTON: REVEAL CHEST"},
    {"value": 0x65, "label": "65: LIGHT TORCHES: REVEAL CHEST"},
    {"value": 0x66, "label": "66: KILL IN ORDER: REVEAL CHEST"},
    {"value": 0x67, "label": "67: PUSH 2 BLOCKS: REVEAL CHEST"},
    {"value": 0x6C, "label": "6C: HORSE HEADS: REVEAL CHEST"},
    {"value": 0x6E, "label": "6E: FILL LAVA: REVEAL CHEST"},
    {"value": 0x81, "label": "81: KILL ENEMIES: DROP KEY"},
    {"value": 0x82, "label": "82: PUSH BLOCK: DROP KEY"},
    {"value": 0x87, "label": "87: PUSH 2 BLOCKS: DROP KEY"},
    {"value": 0x8E, "label": "8E: FILL LAVA: DROP KEY"},
    {"value": 0x8F, "label": "8F: SHOOT EYE STATUE: DROP KEY"},
    {"value": 0xA1, "label": "A1: KILL ENEMIES: REVEAL STAIRS"},
    {"value": 0xA7, "label": "A7: PUSH 2 BLOCKS: REVEAL STAIRS"},
    {"value": 0xA9, "label": "A9: PUZZLE TILES: REVEAL STAIRS"},
    {"value": 0xC1, "label": "C1: MINIBOSS"},
]
var room_type_table = [
    {"value": 0x00, "label": "Normal"},
    {"value": 0x01, "label": "Entrance"},
    {"value": 0x02, "label": "Exit"},
    {"value": 0x03, "label": "Treasure"},
]