"use strict";
// Behavioural tests for the project-owned secrets extension
// (ts/src/ext/secrets), driven through `options.extend` — the same seam a
// consumer would use.
//
// The contract under test: the `apikey` OPTION keeps its exact old meaning
// and always wins when set, because SecretsFeature places it FIRST in the
// provider chain — explicit-beats-lookup falls out of sekreto's first-hit
// rule. Without the feature nothing changes at all. With it and the option
// unset, the chain supplies the credential instead. A provider ERROR fails
// the operation rather than silently sending an unauthenticated request,
// and on the direct path it still comes back as a value, never a throw.
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
const __1 = require("..");
// Imported the way a consumer does — from the built package, not from
// src: the test tree's rootDir is `test/`, and this mirrors the documented
// `@voxgig-sdk/solardemo/dist/ext/secrets` entry point.
const { SecretsFeature } = require('../dist/ext/secrets');
const PREFIX = 'SOLARDEMO_TEST_SECRETS_';
// Build a test client with the secrets feature attached via extend.
function makeSdk(secretopts, sdkopts) {
    const opts = { ...(sdkopts || {}) };
    if (null != secretopts) {
        opts.feature = { ...(opts.feature || {}), secrets: secretopts };
        opts.extend = [new SecretsFeature()];
    }
    return __1.SolardemoSDK.test({}, opts);
}
// prepare() returns the fetchdef the transport would receive. It runs NO
// feature hooks, so anything asserted here is proof the transport wrap
// (not the PreSpec hook) did the work.
async function preparedVia(sdk) {
    const captured = {};
    const utility = sdk._utility;
    const inner = utility.fetcher;
    utility.fetcher = async (ctx, url, fetchdef) => {
        captured.fetchdef = fetchdef;
        return inner(ctx, url, fetchdef);
    };
    const res = await sdk.direct({ path: '/api/planet' });
    return { res, fetchdef: captured.fetchdef };
}
(0, node_test_1.describe)('secrets', () => {
    (0, node_test_1.beforeEach)(() => {
        delete process.env[PREFIX + 'APIKEY'];
        delete process.env[PREFIX + 'API_TOKEN'];
    });
    (0, node_test_1.test)('feature absent: apikey option behaves exactly as before', async () => {
        const sdk = makeSdk(null, { apikey: 'OPTKEY01' });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'OPTKEY01');
        node_assert_1.default.equal(sdk._secrets, undefined);
    });
    (0, node_test_1.test)('feature absent: no apikey means no authorization header', async () => {
        const sdk = makeSdk(null, {});
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], undefined);
    });
    (0, node_test_1.test)('inactive feature instance changes nothing', async () => {
        const sdk = makeSdk({ active: false, providers: [{ kind: 'env', prefix: PREFIX }] }, { apikey: 'OPTKEY01' });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'OPTKEY01');
    });
    (0, node_test_1.test)('active: apikey option still wins over the chain', async () => {
        process.env[PREFIX + 'APIKEY'] = 'ENVKEY01';
        const sdk = makeSdk({ active: true, providers: [{ kind: 'env', prefix: PREFIX }] }, { apikey: 'OPTKEY01' });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'OPTKEY01');
        // The explicit option is a real store: directed reads name it.
        const secrets = sdk._secrets.secrets();
        node_assert_1.default.equal(await secrets.getfrom('options', 'apikey'), 'OPTKEY01');
    });
    (0, node_test_1.test)('active: unset apikey resolves from the env provider, with prefix', async () => {
        process.env[PREFIX + 'APIKEY'] = 'ENVKEY01';
        const sdk = makeSdk({ active: true, providers: [{ kind: 'env', prefix: PREFIX }] }, { auth: { prefix: 'Bearer' } });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'Bearer ENVKEY01');
        node_assert_1.default.equal(sdk.options().apikey, 'ENVKEY01');
    });
    (0, node_test_1.test)('active: an explicitly empty apikey defers to the chain', async () => {
        process.env[PREFIX + 'APIKEY'] = 'ENVKEY01';
        const sdk = makeSdk({ active: true, providers: [{ kind: 'env', prefix: PREFIX }] }, { apikey: '' });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'ENVKEY01');
    });
    // How suppression actually works HERE. prepareAuth has a null-auth
    // branch, but this SDK's generated optspec always supplies
    // `auth: { prefix: '' }`, so `auth: null` is rejected by validate and
    // that branch is unreachable — it only fires for SDKs whose optspec
    // omits `auth`. With the feature active, the deliberate way to send no
    // credential is to give it nothing to find.
    (0, node_test_1.test)('active: auth null is rejected by this SDK optspec', () => {
        node_assert_1.default.throws(() => makeSdk({ active: true, providers: [] }, { auth: null }), /auth to be map/);
    });
    (0, node_test_1.test)('active: no providers and no apikey sends no credential', async () => {
        process.env[PREFIX + 'APIKEY'] = 'ENVKEY01';
        const sdk = makeSdk({ active: true, providers: [] });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], undefined);
    });
    (0, node_test_1.test)('active: custom provider objects are accepted verbatim', async () => {
        const asked = [];
        const sdk = makeSdk({
            active: true,
            providers: [{
                    lookup(name) { asked.push(name); return 'CUSTOM01'; },
                    describe() { return 'custom:test'; },
                }],
        });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'CUSTOM01');
        node_assert_1.default.deepEqual(asked, ['apikey']);
    });
    (0, node_test_1.test)('active: a miss everywhere leaves the header off', async () => {
        const sdk = makeSdk({ active: true, providers: [{ kind: 'env', prefix: PREFIX }] });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], undefined);
        node_assert_1.default.equal(sdk.options().apikey, '');
    });
    // The direct path must keep its contract: a value, never a throw.
    (0, node_test_1.test)('active: a provider ERROR fails direct() as a value, not a throw', async () => {
        const sdk = makeSdk({
            active: true,
            providers: [{
                    lookup(_name) { throw new Error('vault unreachable'); },
                    describe() { return 'broken:test'; },
                }],
        });
        const res = await sdk.direct({ path: '/api/planet' });
        node_assert_1.default.equal(res.ok, false);
        node_assert_1.default.match(String(res.err), /vault unreachable/);
    });
    (0, node_test_1.test)('active: secret name is configurable', async () => {
        process.env[PREFIX + 'API_TOKEN'] = 'TOKKEY01';
        const sdk = makeSdk({
            active: true,
            name: 'api.token',
            providers: [{ kind: 'env', prefix: PREFIX }],
        });
        const { fetchdef } = await preparedVia(sdk);
        node_assert_1.default.equal(fetchdef.headers['authorization'], 'TOKKEY01');
    });
    (0, node_test_1.test)('active: sekreto is live for arbitrary secrets and redaction', async () => {
        const sdk = makeSdk({
            active: true,
            providers: [{ kind: 'memory', values: { DB_PASSWORD: 'dbpass01' } }],
        });
        const secrets = sdk._secrets.secrets();
        node_assert_1.default.equal(await secrets.get('db.password'), 'dbpass01');
        node_assert_1.default.equal(secrets.redact('the password is dbpass01, keep it safe'), 'the password is [redacted], keep it safe');
    });
    // Entity ops resolve at PreSpec, before the spec (and so the header) is
    // built — earlier than the transport wrap, which is why both exist.
    (0, node_test_1.test)('active: entity ops resolve via the PreSpec hook', async () => {
        process.env[PREFIX + 'APIKEY'] = 'ENVKEY02';
        const entityDataFile = node_path_1.default.resolve(__dirname, '../../.sdk/test/entity/moon/MoonTestData.json');
        const entityData = JSON.parse(Fs.readFileSync(entityDataFile).toString('utf8'));
        const sdk = makeSdk({ active: true, providers: [{ kind: 'env', prefix: PREFIX }] }, { entity: entityData.existing });
        node_assert_1.default.equal(sdk.options().apikey, '');
        const moons = await sdk.Moon().list();
        node_assert_1.default.ok(Array.isArray(moons));
        node_assert_1.default.equal(sdk.options().apikey, 'ENVKEY02');
    });
});
//# sourceMappingURL=secrets.test.js.map