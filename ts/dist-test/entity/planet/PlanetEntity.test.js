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
(0, node_test_1.describe)('PlanetEntity', async () => {
    (0, node_test_1.test)('instance', async () => {
        const testsdk = __1.SolardemoSDK.test();
        const ent = testsdk.Planet();
        (0, node_assert_1.default)(null != ent);
    });
    (0, node_test_1.test)('basic', async () => {
        const setup = basicSetup();
        const client = setup.client;
        // CREATE
        const planet_ref01_ent = client.Planet();
        const planet_ref01_data = await planet_ref01_ent.create(setup.data.new.planet['planet_ref01']);
        (0, node_assert_1.default)(null != planet_ref01_data.id);
        // LIST
        const planet_ref01_match = {};
        const planet_ref01_list = await planet_ref01_ent.list(planet_ref01_match);
        (0, node_assert_1.default)(null != planet_ref01_list.find((entdata) => entdata.data().id == planet_ref01_data.id));
        // UPDATE
        const planet_ref01_data_up0 = {};
        planet_ref01_data_up0.id = planet_ref01_data.id;
        const planet_ref01_markdef_up0 = { name: 'kind', value: 'Mark01-planet_ref01_' + setup.now };
        planet_ref01_data_up0[planet_ref01_markdef_up0.name] = planet_ref01_markdef_up0.value;
        const planet_ref01_resdata_up0 = await planet_ref01_ent.update(planet_ref01_data_up0);
        node_assert_1.default.equal(planet_ref01_resdata_up0.id, planet_ref01_data_up0.id);
        node_assert_1.default.equal(planet_ref01_resdata_up0[planet_ref01_markdef_up0.name], planet_ref01_markdef_up0.value);
        // LOAD
        const planet_ref01_match_dt0 = {};
        planet_ref01_match_dt0.id = planet_ref01_data.id;
        const planet_ref01_data_dt0 = await planet_ref01_ent.load(planet_ref01_match_dt0);
        (0, node_assert_1.default)(planet_ref01_data_dt0.id === planet_ref01_data.id);
        // REMOVE
        const planet_ref01_match_rm0 = {};
        planet_ref01_match_rm0.id = planet_ref01_data.id;
        await planet_ref01_ent.remove(planet_ref01_match_rm0);
        // LIST
        const planet_ref01_match_rt0 = {};
        const planet_ref01_list_rt0 = await planet_ref01_ent.list(planet_ref01_match_rt0);
        (0, node_assert_1.default)(null == planet_ref01_list_rt0.find((entdata) => entdata.data().id == planet_ref01_data.id));
    });
});
function basicSetup(extra) {
    extra = extra || {};
    const options = {}; // null
    const entityDataFile = node_path_1.default.resolve(__dirname, '../../../../.sdk/test/entity/planet/PlanetTestData.json');
    const entityDataSource = Fs.readFileSync(entityDataFile).toString('utf8');
    // TODO: need a xlang JSON parse utility in voxgig/struct with better error msgs
    const entityData = JSON.parse(entityDataSource);
    options.entity = entityData.existing;
    const setup = {
        dm: {
            // p: envOverride($ {jsonify(basicflow.param, { offset: 2 + indent })}),
            p: {},
            s: {},
        },
        options,
    };
    const { merge } = __1.utility.struct;
    let client = __1.SolardemoSDK.test(options, extra);
    // if ('TRUE' === setup.dm.p.SOLARDEMO_TEST_LIVE) {
    //   client = new SolardemoSDK(merge([
    //     {
    //       apikey: process.env.SOLARDEMO_APIKEY,
    //     },
    //     extra])
    //   )
    // }
    setup.data = entityData;
    setup.client = client;
    setup.struct = client.utility().struct;
    setup.explain = 'TRUE' === setup.dm.p.SOLARDEMO_TEST_EXPLAIN;
    setup.now = Date.now();
    return setup;
}
//# sourceMappingURL=PlanetEntity.test.js.map