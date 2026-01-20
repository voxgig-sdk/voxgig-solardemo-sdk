"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const envlocal = __dirname + '/../../../.env.local';
require('dotenv').config({ quiet: true, path: [envlocal] });
const node_test_1 = require("node:test");
const node_assert_1 = require("node:assert");
const __1 = require("../..");
const utility_1 = require("../utility");
(0, node_test_1.describe)('MoonEntity', async () => {
    (0, node_test_1.test)('instance', async () => {
        const testsdk = __1.SolardemoSDK.test();
        const ent = testsdk.Moon();
        (0, node_assert_1.equal)(null !== ent, true);
    });
    (0, node_test_1.test)('basic', async () => {
        const setup = basicSetup();
        const { dm, options, client, struct, explain } = setup;
        const { validate, transform } = struct;
        let ctrl = {};
        try {
            // Step: load_moon0 - load moon
            const load_moon0 = (0, utility_1.makeStepData)(dm, 'load_moon0');
            load_moon0.entity = client.Moon();
            load_moon0.match = (0, utility_1.makeMatch)(dm, transform, {
                "id": "`dm$=p.SOLARDEMO_TEST_MOON_ENTID.moon01`"
            });
            load_moon0.resdata =
                await load_moon0.entity.load(load_moon0.match, ctrl = (0, utility_1.makeCtrl)(explain));
            if (explain) {
                console.log('load_moon0: ', ctrl.explain);
            }
            (0, utility_1.makeValid)(dm, validate, load_moon0.resdata, {
                "`$OPEN`": true,
                "id": "`dm$=s.load_moon0.match.id`"
            });
            // Step: update_moon1 - update moon
            const update_moon1 = (0, utility_1.makeStepData)(dm, 'update_moon1');
            update_moon1.entity = load_moon0.entity;
            update_moon1.reqdata = (0, utility_1.makeReqdata)(dm, transform, {});
            update_moon1.resdata =
                await update_moon1.entity.update(update_moon1.reqdata, ctrl = (0, utility_1.makeCtrl)(explain));
            if (explain) {
                console.log('update_moon1: ', ctrl.explain);
            }
            (0, utility_1.makeValid)(dm, validate, update_moon1.resdata, {
                "`$OPEN`": true,
                "id": "`dm$=s.load_moon0.match.id`"
            });
            // Step: load_moon2 - load moon
            const load_moon2 = (0, utility_1.makeStepData)(dm, 'load_moon2');
            load_moon2.entity = client.Moon();
            load_moon2.match = (0, utility_1.makeMatch)(dm, transform, {
                "id": "`dm$=p.SOLARDEMO_TEST_MOON_ENTID.moon01`"
            });
            load_moon2.resdata =
                await load_moon2.entity.load(load_moon2.match, ctrl = (0, utility_1.makeCtrl)(explain));
            if (explain) {
                console.log('load_moon2: ', ctrl.explain);
            }
            (0, utility_1.makeValid)(dm, validate, load_moon2.resdata, {
                "`$OPEN`": true,
                "id": "`dm$=s.load_moon0.match.id`"
            });
        }
        catch (err) {
            console.dir(dm, { depth: null });
            if (explain) {
                console.dir(ctrl.explain, { depth: null });
            }
            console.log(err);
            throw err;
        }
    });
});
function basicSetup(extra) {
    extra = extra || {};
    const options = {
        "entity": {
            "moon": {
                "MOON01": {
                    "diameter": "s0",
                    "id": "MOON01",
                    "kind": "s2",
                    "name": "s3",
                    "planet_id": "s4"
                },
                "MOON02": {
                    "diameter": "s32",
                    "id": "MOON02",
                    "kind": "s34",
                    "name": "s35",
                    "planet_id": "s36"
                },
                "MOON03": {
                    "diameter": "s64",
                    "id": "MOON03",
                    "kind": "s66",
                    "name": "s67",
                    "planet_id": "s68"
                }
            }
        }
    };
    const setup = {
        dm: {
            p: (0, utility_1.envOverride)({
                "SOLARDEMO_TEST_MOON_ENTID": {
                    "moon01": "MOON01",
                    "moon02": "MOON02",
                    "moon03": "MOON03"
                },
                "SOLARDEMO_TEST_LIVE": "FALSE",
                "SOLARDEMO_TEST_EXPLAIN": "FALSE"
            }),
            s: {},
        },
        options,
    };
    const { merge } = __1.utility.struct;
    let client = __1.SolardemoSDK.test(options, extra);
    if ('TRUE' === setup.dm.p.SOLARDEMO_TEST_LIVE) {
        client = new __1.SolardemoSDK(merge([
            {
                apikey: process.env.SOLARDEMO_APIKEY,
            },
            extra
        ]));
    }
    setup.client = client;
    setup.struct = client.utility().struct;
    setup.explain = 'TRUE' === setup.dm.p.SOLARDEMO_TEST_EXPLAIN;
    return setup;
}
//# sourceMappingURL=MoonEntity.test.js.map