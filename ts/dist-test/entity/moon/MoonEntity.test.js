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
const envlocal = __dirname + '/../../../.env.local';
require('dotenv').config({ quiet: true, path: [envlocal] });
const node_path_1 = __importDefault(require("node:path"));
const Fs = __importStar(require("node:fs"));
const node_test_1 = require("node:test");
const node_assert_1 = __importDefault(require("node:assert"));
const __1 = require("../../..");
const utility_1 = require("../../utility");
(0, node_test_1.describe)('MoonEntity', async () => {
    (0, node_test_1.test)('instance', async () => {
        const testsdk = __1.SolardemoSDK.test();
        const ent = testsdk.Moon();
        (0, node_assert_1.default)(null != ent);
    });
    (0, node_test_1.test)('basic', async () => {
        const setup = basicSetup();
        const client = setup.client;
        const struct = setup.struct;
        const isempty = struct.isempty;
        const select = struct.select;
        // CREATE
        const moon_ref01_ent = client.Moon();
        let moon_ref01_data = setup.data.new.moon['moon_ref01'];
        moon_ref01_data['planet_id'] = setup.idmap['planet01'];
        moon_ref01_data = await moon_ref01_ent.create(moon_ref01_data);
        (0, node_assert_1.default)(null != moon_ref01_data.id);
        // LIST
        const moon_ref01_match = {};
        moon_ref01_match['planet_id'] = setup.idmap['planet01'];
        const moon_ref01_list = await moon_ref01_ent.list(moon_ref01_match);
        (0, node_assert_1.default)(!isempty(select(moon_ref01_list, { id: moon_ref01_data.id })));
        // UPDATE
        const moon_ref01_data_up0 = {};
        moon_ref01_data_up0.id = moon_ref01_data.id;
        moon_ref01_data_up0['planet_id'] = setup.idmap['planet_id'];
        const moon_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-moon_ref01_' + setup.now };
        moon_ref01_data_up0[moon_ref01_markdef_up0.name] = moon_ref01_markdef_up0.value;
        const moon_ref01_resdata_up0 = await moon_ref01_ent.update(moon_ref01_data_up0);
        (0, node_assert_1.default)(moon_ref01_resdata_up0.id === moon_ref01_data_up0.id);
        (0, node_assert_1.default)(moon_ref01_resdata_up0[moon_ref01_markdef_up0.name] === moon_ref01_markdef_up0.value);
        // LOAD
        const moon_ref01_match_dt0 = {};
        moon_ref01_match_dt0.id = moon_ref01_data.id;
        const moon_ref01_data_dt0 = await moon_ref01_ent.load(moon_ref01_match_dt0);
        (0, node_assert_1.default)(moon_ref01_data_dt0.id === moon_ref01_data.id);
        // REMOVE
        const moon_ref01_match_rm0 = {};
        moon_ref01_match_rm0.id = moon_ref01_data.id;
        await moon_ref01_ent.remove(moon_ref01_match_rm0);
        // LIST
        const moon_ref01_match_rt0 = {};
        moon_ref01_match_rt0['planet_id'] = setup.idmap['planet01'];
        const moon_ref01_list_rt0 = await moon_ref01_ent.list(moon_ref01_match_rt0);
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
    let client = __1.SolardemoSDK.test(options, extra);
    const struct = client.utility().struct;
    const merge = struct.merge;
    const transform = struct.transform;
    let idmap = transform(['${entity.name}01', '${entity.name}02', '${entity.name}03', 'planet01', 'planet02', 'planet03'], {
        '`$PACK`': ['', {
                '`$KEY`': '`$COPY`',
                '`$VAL`': ['`$FORMAT`', 'upper', '`$COPY`']
            }]
    });
    const env = (0, utility_1.envOverride)({
        'SOLARDEMO_TEST_MOON_ENTID': idmap,
        'SOLARDEMO_TEST_LIVE': 'FALSE',
        'SOLARDEMO_TEST_EXPLAIN': 'FALSE',
        'SOLARDEMO_APIKEY': 'NONE',
    });
    idmap = env['SOLARDEMO_TEST_MOON_ENTID'];
    if ('TRUE' === env.SOLARDEMO_TEST_LIVE) {
        client = new __1.SolardemoSDK(merge([
            {
                apikey: env.SOLARDEMO_APIKEY,
            },
            extra
        ]));
    }
    const setup = {
        idmap,
        env,
        options,
        client,
        struct,
        data: entityData,
        explain: 'TRUE' === env.SOLARDEMO_TEST_EXPLAIN,
        now: Date.now(),
    };
    return setup;
}
//# sourceMappingURL=MoonEntity.test.js.map