"use strict";
var __createBinding = (this && this.__createBinding) || (Object.create ? (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    var desc = Object.getOwnPropertyDescriptor(m, k);
    if (!desc || ("get" in desc ? !m.__esModule : desc.writable || desc.configurable)) {
      desc = { enumerable: true, get: function() { return m[k]; } };
    }
    Object.defineProperty(o, k2, desc);
}) : (function(o, m, k, k2) {
    if (k2 === undefined) k2 = k;
    o[k2] = m[k];
}));
var __setModuleDefault = (this && this.__setModuleDefault) || (Object.create ? (function(o, v) {
    Object.defineProperty(o, "default", { enumerable: true, value: v });
}) : function(o, v) {
    o["default"] = v;
});
var __importStar = (this && this.__importStar) || (function () {
    var ownKeys = function(o) {
        ownKeys = Object.getOwnPropertyNames || function (o) {
            var ar = [];
            for (var k in o) if (Object.prototype.hasOwnProperty.call(o, k)) ar[ar.length] = k;
            return ar;
        };
        return ownKeys(o);
    };
    return function (mod) {
        if (mod && mod.__esModule) return mod;
        var result = {};
        if (mod != null) for (var k = ownKeys(mod), i = 0; i < k.length; i++) if (k[i] !== "default") __createBinding(result, mod, k[i]);
        __setModuleDefault(result, mod);
        return result;
    };
})();
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_path_1 = __importDefault(require("node:path"));
const Fs = __importStar(require("node:fs"));
const node_test_1 = require("node:test");
const node_assert_1 = __importDefault(require("node:assert"));
const live_runner_1 = require("../../live-runner");
const live_entity_1 = require("../../live-entity");
const __1 = require("../../..");
const utility_1 = require("../../utility");
(0, utility_1.loadEnvLocal)(__dirname + '/../../../.env.local');
(0, node_test_1.describe)('MoonEntity', async () => {
    // Per-test live pacing. Delay is read from sdk-test-control.json's
    // `test.live.delayMs`; only sleeps when VOXGIG_SOLARDEMO_TEST_LIVE=TRUE.
    (0, node_test_1.afterEach)((0, utility_1.liveDelay)('VOXGIG_SOLARDEMO_TEST_LIVE'));
    (0, node_test_1.test)('instance', async () => {
        const testsdk = __1.VoxgigSolardemoSDK.test();
        const ent = testsdk.Moon();
        (0, node_assert_1.default)(null != ent);
    });
    (0, node_test_1.test)('basic', async (t) => {
        const live = 'TRUE' === process.env.VOXGIG_SOLARDEMO_TEST_LIVE;
        for (const op of ['create', 'list', 'update', 'load', 'remove']) {
            if (!live && (0, utility_1.maybeSkipControl)(t, 'entityOp', 'moon.' + op, live))
                return;
        }
        const setup = basicSetup();
        if (setup.live) {
            return (0, live_entity_1.runLiveEntity)(setup, { "active": true, "alias": { "field": {} }, "fields": { "diameter": { "a": true, "fo": "float", "h": "Diameter", "n": "diameter", "r": true, "t": "`$NUMBER`", "key$": "diameter", "index$": 0 }, "id": { "a": true, "h": "Id", "n": "id", "r": true, "t": "`$STRING`", "key$": "id", "index$": 1 }, "kind": { "a": true, "h": "Kind", "n": "kind", "r": true, "t": "`$STRING`", "key$": "kind", "index$": 2 }, "name": { "a": true, "h": "Name", "n": "name", "r": true, "t": "`$STRING`", "key$": "name", "index$": 3 }, "planet_id": { "a": true, "h": "Planet Id", "n": "planet_id", "r": true, "t": "`$STRING`", "key$": "planet_id", "index$": 4 } }, "id": { "field": "id", "name": "id" }, "name": "moon", "op": { "create": { "input": "data", "name": "create", "points": [{ "a": true, "co": { "id": "POST /api/planet/{planet_id}/moon", "source": "openapi3", "version": 2 }, "g": { "params": [{ "a": true, "k": "param", "n": "planet_id", "or": "planet_id", "r": true, "t": "`$STRING`", "index$": 0 }] }, "k": "http", "m": "POST", "o": "/api/planet/{planet_id}/moon", "q": { "exist": ["planet_id"] }, "r": {}, "s": [{ "lit": "api" }, { "lit": "planet" }, { "var": "planet_id" }, { "lit": "moon" }], "t": { "req": "`reqdata`", "res": "`body`" }, "index$": 0 }], "key$": "create" }, "list": { "input": "data", "name": "list", "points": [{ "a": true, "co": { "id": "GET /api/planet/{planet_id}/moon", "source": "openapi3", "version": 2 }, "g": { "params": [{ "a": true, "k": "param", "n": "planet_id", "or": "planet_id", "r": true, "t": "`$STRING`", "index$": 0 }] }, "k": "http", "m": "GET", "o": "/api/planet/{planet_id}/moon", "q": { "exist": ["planet_id"] }, "r": {}, "s": [{ "lit": "api" }, { "lit": "planet" }, { "var": "planet_id" }, { "lit": "moon" }], "t": { "req": "`reqdata`", "res": "`body`" }, "index$": 0 }], "key$": "list" }, "load": { "input": "data", "name": "load", "points": [{ "a": true, "co": { "id": "GET /api/planet/{planet_id}/moon/{moon_id}", "source": "openapi3", "version": 2 }, "g": { "params": [{ "a": true, "k": "param", "n": "id", "or": "moon_id", "r": true, "t": "`$STRING`", "index$": 0 }, { "a": true, "k": "param", "n": "planet_id", "or": "planet_id", "r": true, "t": "`$STRING`", "index$": 1 }] }, "k": "http", "m": "GET", "o": "/api/planet/{planet_id}/moon/{moon_id}", "q": { "exist": ["id", "planet_id"] }, "r": { "param": { "moon_id": "id" } }, "s": [{ "lit": "api" }, { "lit": "planet" }, { "var": "planet_id" }, { "lit": "moon" }, { "var": "id" }], "t": { "req": "`reqdata`", "res": "`body`" }, "index$": 0 }], "key$": "load" }, "remove": { "input": "data", "name": "remove", "points": [{ "a": true, "co": { "id": "DELETE /api/planet/{planet_id}/moon/{moon_id}", "source": "openapi3", "version": 2 }, "g": { "params": [{ "a": true, "k": "param", "n": "id", "or": "moon_id", "r": true, "t": "`$STRING`", "index$": 0 }, { "a": true, "k": "param", "n": "planet_id", "or": "planet_id", "r": true, "t": "`$STRING`", "index$": 1 }] }, "k": "http", "m": "DELETE", "o": "/api/planet/{planet_id}/moon/{moon_id}", "q": { "exist": ["id", "planet_id"] }, "r": { "param": { "moon_id": "id" } }, "s": [{ "lit": "api" }, { "lit": "planet" }, { "var": "planet_id" }, { "lit": "moon" }, { "var": "id" }], "t": { "req": "`reqdata`", "res": "`body`" }, "index$": 0 }], "key$": "remove" }, "update": { "input": "data", "name": "update", "points": [{ "a": true, "co": { "id": "PUT /api/planet/{planet_id}/moon/{moon_id}", "source": "openapi3", "version": 2 }, "g": { "params": [{ "a": true, "k": "param", "n": "id", "or": "moon_id", "r": true, "t": "`$STRING`", "index$": 0 }, { "a": true, "k": "param", "n": "planet_id", "or": "planet_id", "r": true, "t": "`$STRING`", "index$": 1 }] }, "k": "http", "m": "PUT", "o": "/api/planet/{planet_id}/moon/{moon_id}", "q": { "exist": ["id", "planet_id"] }, "r": { "param": { "moon_id": "id" } }, "s": [{ "lit": "api" }, { "lit": "planet" }, { "var": "planet_id" }, { "lit": "moon" }, { "var": "id" }], "t": { "req": "`reqdata`", "res": "`body`" }, "index$": 0 }], "key$": "update" } }, "relations": { "ancestors": [["$.main.kit.entity.planet"]] }, "key$": "moon", "name__orig": "moon", "Name": "Moon", "name_": "moon", "name-": "moon", "NAME": "MOON", "index$": 0 }, { "active": true, "entity": "moon", "key$": "BasicMoonFlow", "kind": "basic", "name": "BasicMoonFlow", "param": {}, "step": [{ "a": true, "d": {}, "i": { "ref": "moon_ref01" }, "m": { "planet_id": "planet01" }, "o": "create", "s": [], "v": [], "index$": 0 }, { "a": true, "d": {}, "i": {}, "m": { "planet_id": "planet01" }, "o": "list", "s": [], "v": [{ "apply": "ItemExists", "def": { "ref": "moon_ref01" } }], "index$": 1 }, { "a": true, "d": { "planet_id": "planet01" }, "i": { "ref": "moon_ref01", "srcdatavar": "moon_ref01_data", "suffix": "_up0", "textfield": "kind" }, "m": {}, "o": "update", "s": [{ "apply": "TextFieldMark", "def": { "mark": "Mark01-moon_ref01" } }], "v": [], "index$": 2 }, { "a": true, "d": {}, "i": { "ref": "moon_ref01", "srcdatavar": "moon_ref01_data", "suffix": "_dt0" }, "m": { "id": "moon01", "planet_id": "planet01" }, "o": "load", "s": [], "v": [{ "apply": "TextFieldMark", "def": { "mark": "Mark01-moon_ref01" } }], "index$": 3 }, { "a": true, "d": {}, "i": { "ref": "moon_ref01", "suffix": "_rm0" }, "m": { "id": "moon01", "planet_id": "planet01" }, "o": "remove", "s": [], "v": [], "index$": 4 }, { "a": true, "d": {}, "i": { "suffix": "_rt0" }, "m": { "planet_id": "planet01" }, "o": "list", "s": [], "v": [{ "apply": "ItemNotExists", "def": { "ref": "moon_ref01" } }], "index$": 5 }] }, 'Moon', { "POST /api/planet/{planet_id}/moon": { "protocol": "http", "requestBody": { "required": true, "content": { "application/json": { "schema": { "type": "object", "required": ["id", "name", "planet_id", "kind", "diameter"], "properties": { "id": { "type": "string", "key$": "id" }, "name": { "type": "string", "key$": "name" }, "planet_id": { "type": "string", "key$": "planet_id" }, "kind": { "type": "string", "key$": "kind" }, "diameter": { "type": "number", "format": "float", "key$": "diameter" } }, "x-ref": "#/components/schemas/Moon", "index$": 1 } } } }, "parameters": [{ "name": "planet_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 0 }] }, "GET /api/planet/{planet_id}/moon": { "protocol": "http", "parameters": [{ "name": "planet_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 0 }] }, "GET /api/planet/{planet_id}/moon/{moon_id}": { "protocol": "http", "parameters": [{ "name": "planet_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 0 }, { "name": "moon_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 1 }] }, "DELETE /api/planet/{planet_id}/moon/{moon_id}": { "protocol": "http", "parameters": [{ "name": "planet_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 0 }, { "name": "moon_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 1 }] }, "PUT /api/planet/{planet_id}/moon/{moon_id}": { "protocol": "http", "requestBody": { "required": true, "content": { "application/json": { "schema": { "type": "object", "required": ["id", "name", "planet_id", "kind", "diameter"], "properties": { "id": { "type": "string", "key$": "id" }, "name": { "type": "string", "key$": "name" }, "planet_id": { "type": "string", "key$": "planet_id" }, "kind": { "type": "string", "key$": "kind" }, "diameter": { "type": "number", "format": "float", "key$": "diameter" } }, "x-ref": "#/components/schemas/Moon", "index$": 1 } } } }, "parameters": [{ "name": "planet_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 0 }, { "name": "moon_id", "in": "path", "required": true, "schema": { "type": "string" }, "index$": 1 }] } });
        }
        const client = setup.client;
        const struct = setup.struct;
        const isempty = struct.isempty;
        const select = struct.select;
        // CREATE
        const moon_ref01_ent = client.Moon();
        let moon_ref01_data = setup.data.new.moon['moon_ref01'];
        moon_ref01_data['planet_id'] = setup.idmap['planet01'];
        moon_ref01_data = (await moon_ref01_ent.create(moon_ref01_data)).data();
        (0, node_assert_1.default)(null != moon_ref01_data.id);
        // LIST
        const moon_ref01_match = {};
        moon_ref01_match['planet_id'] = setup.idmap['planet01'];
        const moon_ref01_list = (await moon_ref01_ent.list(moon_ref01_match)).map((e) => e.data());
        (0, node_assert_1.default)(!isempty(select(moon_ref01_list, { id: moon_ref01_data.id })));
        // UPDATE
        const moon_ref01_data_up0 = {};
        moon_ref01_data_up0.id = moon_ref01_data.id;
        moon_ref01_data_up0['planet_id'] = setup.idmap['planet_id'];
        const moon_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-moon_ref01_' + setup.now };
        moon_ref01_data_up0[moon_ref01_markdef_up0.name] = moon_ref01_markdef_up0.value;
        const moon_ref01_resdata_up0 = (await moon_ref01_ent.update(moon_ref01_data_up0)).data();
        (0, node_assert_1.default)(moon_ref01_resdata_up0.id === moon_ref01_data_up0.id);
        (0, node_assert_1.default)(moon_ref01_resdata_up0[moon_ref01_markdef_up0.name] === moon_ref01_markdef_up0.value);
        // LOAD
        const moon_ref01_match_dt0 = {};
        moon_ref01_match_dt0.id = moon_ref01_data.id;
        const moon_ref01_data_dt0 = (await moon_ref01_ent.load(moon_ref01_match_dt0)).data();
        (0, node_assert_1.default)(moon_ref01_data_dt0.id === moon_ref01_data.id);
        // REMOVE
        const moon_ref01_match_rm0 = { id: moon_ref01_data.id };
        await moon_ref01_ent.remove(moon_ref01_match_rm0);
        // LIST
        const moon_ref01_match_rt0 = {};
        moon_ref01_match_rt0['planet_id'] = setup.idmap['planet01'];
        const moon_ref01_list_rt0 = (await moon_ref01_ent.list(moon_ref01_match_rt0)).map((e) => e.data());
        (0, node_assert_1.default)(isempty(select(moon_ref01_list_rt0, { id: moon_ref01_data.id })));
    });
});
function basicSetup(extra) {
    // TODO: fix test def options
    const options = {}; // null
    // TODO: needs test utility to resolve path
    const entityDataFile = node_path_1.default.resolve(__dirname, '../../../../.sdk/test/entity/moon/MoonTestData.json');
    // TODO: file ready util needed?
    const entityDataSource = Fs.readFileSync(entityDataFile).toString('utf8');
    // TODO: need a xlang JSON parse utility in voxgig/struct with better error msgs
    const entityData = JSON.parse(entityDataSource);
    options.entity = entityData.existing;
    let client = __1.VoxgigSolardemoSDK.test(options, extra);
    const struct = client.utility().struct;
    const merge = struct.merge;
    const transform = struct.transform;
    let idmap = transform(['moon01', 'moon02', 'moon03', 'planet01', 'planet02', 'planet03'], {
        '`$PACK`': ['', {
                '`$KEY`': '`$COPY`',
                '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
            }]
    });
    const env = (0, utility_1.envOverride)({
        'VOXGIG_SOLARDEMO_TEST_MOON_ENTID': idmap,
        'VOXGIG_SOLARDEMO_TEST_LIVE': 'FALSE',
        'VOXGIG_SOLARDEMO_TEST_EXPLAIN': 'FALSE',
    });
    idmap = env['VOXGIG_SOLARDEMO_TEST_MOON_ENTID'];
    const live = 'TRUE' === env.VOXGIG_SOLARDEMO_TEST_LIVE;
    const transport = (0, live_runner_1.createLiveTransport)();
    if (live) {
        const rawIds = process.env['VOXGIG_SOLARDEMO_TEST_MOON_ENTID'];
        idmap = rawIds && rawIds.trim() ? JSON.parse(rawIds) : {};
        if (!idmap || Array.isArray(idmap) || typeof idmap !== 'object') {
            throw new Error('Live ENTID must be a JSON object');
        }
        client = new __1.VoxgigSolardemoSDK(merge([
            // FIRST, so the generated fields below win: sdk-test-control.json's
            // test.client.options adds to the live client, it does not redirect it.
            (0, utility_1.liveClientOptions)(),
            {},
            // 'extra || {}', not a bare 'extra': struct.merge returns UNDEFINED when the
            // last entry is undefined, and basicSetup is normally called with no
            // argument at all - so a bare 'extra' silently discarded the apikey
            // and server values above and handed the SDK undefined. Harmless
            // while there was nothing in that object; not harmless now.
            extra || {},
            { system: { fetch: transport.fetch } }
        ]));
    }
    const setup = {
        idmap,
        env,
        options,
        client,
        struct,
        data: entityData,
        explain: 'TRUE' === env.VOXGIG_SOLARDEMO_TEST_EXPLAIN,
        live,
        transport,
        now: Date.now(),
    };
    return setup;
}
//# sourceMappingURL=MoonEntity.test.js.map