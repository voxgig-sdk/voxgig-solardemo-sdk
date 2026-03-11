"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
const node_test_1 = require("node:test");
const node_assert_1 = __importDefault(require("node:assert"));
const __1 = require("../../..");
(0, node_test_1.describe)('PlanetDirect', async () => {
    (0, node_test_1.test)('direct-exists', async () => {
        const sdk = new __1.SolardemoSDK({
            system: { fetch: async () => ({}) }
        });
        (0, node_assert_1.default)('function' === typeof sdk.direct);
        (0, node_assert_1.default)('function' === typeof sdk.prepare);
    });
    (0, node_test_1.test)('direct-load-planet', async () => {
        const setup = directSetup({ id: 'direct01' });
        const { client, calls } = setup;
        const result = await client.direct({
            path: 'api/planet/{id}',
            method: 'GET',
            params: { id: 'direct01' },
        });
        (0, node_assert_1.default)(result.ok === true);
        (0, node_assert_1.default)(result.status === 200);
        (0, node_assert_1.default)(null != result.data);
        (0, node_assert_1.default)(result.data.id === 'direct01');
        (0, node_assert_1.default)(calls.length === 1);
        (0, node_assert_1.default)(calls[0].init.method === 'GET');
        (0, node_assert_1.default)(calls[0].url.includes('direct01'));
    });
    (0, node_test_1.test)('direct-list-planet', async () => {
        const setup = directSetup([{ id: 'direct01' }, { id: 'direct02' }]);
        const { client, calls } = setup;
        const result = await client.direct({
            path: 'api/planet',
            method: 'GET',
            params: {},
        });
        (0, node_assert_1.default)(result.ok === true);
        (0, node_assert_1.default)(result.status === 200);
        (0, node_assert_1.default)(Array.isArray(result.data));
        (0, node_assert_1.default)(result.data.length === 2);
        (0, node_assert_1.default)(calls.length === 1);
        (0, node_assert_1.default)(calls[0].init.method === 'GET');
    });
});
function directSetup(mockres) {
    const calls = [];
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
    return { client, calls };
}
//# sourceMappingURL=PlanetDirect.test.js.map