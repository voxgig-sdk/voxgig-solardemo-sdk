"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const envlocal = __dirname + '/../../../.env.local';
require('dotenv').config({ quiet: true, path: [envlocal] });
const node_test_1 = require("node:test");
const node_assert_1 = __importDefault(require("node:assert"));
const __1 = require("../../..");
const utility_1 = require("../../utility");
(0, node_test_1.describe)('MoonDirect', async () => {
    (0, node_test_1.test)('direct-exists', async () => {
        const sdk = new __1.SolardemoSDK({
            system: { fetch: async () => ({}) }
        });
        (0, node_assert_1.default)('function' === typeof sdk.direct);
        (0, node_assert_1.default)('function' === typeof sdk.prepare);
    });
    (0, node_test_1.test)('direct-load-moon', async () => {
        const setup = directSetup({ id: 'direct01' });
        const { client, calls } = setup;
        const params = {};
        if (setup.live) {
            const listResult = await client.direct({
                path: 'api/planet/{planet_id}/moon',
                method: 'GET',
                params: {
                    planet_id: setup.idmap['planet01'],
                },
            });
            (0, node_assert_1.default)(listResult.ok === true);
            const listData = listResult.data;
            if (!Array.isArray(listData) || listData.length === 0) {
                return; // skip: no entities to load in live mode
            }
            params.id = listData[0].id;
            params.planet_id = setup.idmap['planet01'];
        }
        else {
            params.id = 'direct01';
            params.planet_id = 'direct02';
        }
        const result = await client.direct({
            path: 'api/planet/{planet_id}/moon/{id}',
            method: 'GET',
            params,
        });
        (0, node_assert_1.default)(result.ok === true);
        (0, node_assert_1.default)(result.status === 200);
        (0, node_assert_1.default)(null != result.data);
        if (!setup.live) {
            (0, node_assert_1.default)(result.data.id === 'direct01');
            (0, node_assert_1.default)(calls.length === 1);
            (0, node_assert_1.default)(calls[0].init.method === 'GET');
            (0, node_assert_1.default)(calls[0].url.includes('direct01'));
            (0, node_assert_1.default)(calls[0].url.includes('direct02'));
        }
    });
    (0, node_test_1.test)('direct-list-moon', async () => {
        const setup = directSetup([{ id: 'direct01' }, { id: 'direct02' }]);
        const { client, calls } = setup;
        const params = {};
        if (setup.live) {
            params.planet_id = setup.idmap['planet01'];
        }
        else {
            params.planet_id = 'direct01';
        }
        const result = await client.direct({
            path: 'api/planet/{planet_id}/moon',
            method: 'GET',
            params,
        });
        (0, node_assert_1.default)(result.ok === true);
        (0, node_assert_1.default)(result.status === 200);
        (0, node_assert_1.default)(Array.isArray(result.data));
        if (!setup.live) {
            (0, node_assert_1.default)(result.data.length === 2);
            (0, node_assert_1.default)(calls.length === 1);
            (0, node_assert_1.default)(calls[0].init.method === 'GET');
            (0, node_assert_1.default)(calls[0].url.includes('direct01'));
        }
    });
});
function directSetup(mockres) {
    const calls = [];
    const env = (0, utility_1.envOverride)({
        'SOLARDEMO_TEST_MOON_ENTID': {},
        'SOLARDEMO_TEST_LIVE': 'FALSE',
        'SOLARDEMO_APIKEY': 'NONE',
    });
    const live = 'TRUE' === env.SOLARDEMO_TEST_LIVE;
    if (live) {
        const client = new __1.SolardemoSDK({
            apikey: env.SOLARDEMO_APIKEY,
        });
        let idmap = env['SOLARDEMO_TEST_MOON_ENTID'];
        if ('string' === typeof idmap && idmap.startsWith('{')) {
            idmap = JSON.parse(idmap);
        }
        return { client, calls, live, idmap };
    }
    const mockFetch = async (url, init) => {
        calls.push({ url, init });
        return {
            status: 200,
            statusText: 'OK',
            headers: {},
            json: async () => (null != mockres ? mockres : { id: 'direct01' }),
        };
    };
    const client = new __1.SolardemoSDK({
        base: 'http://localhost:8080',
        system: { fetch: mockFetch },
    });
    return { client, calls, live, idmap: {} };
}
//# sourceMappingURL=MoonDirect.test.js.map