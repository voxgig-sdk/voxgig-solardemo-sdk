"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
const envlocal = __dirname + '/../../../.env.local';
require('dotenv').config({ quiet: true, path: [envlocal] });
const node_test_1 = require("node:test");
const node_assert_1 = require("node:assert");
const __1 = require("../..");
const utility_1 = require("../utility");
(0, node_test_1.describe)('PlanetEntity', async () => {
    (0, node_test_1.test)('instance', async () => {
        const testsdk = __1.SolardemoSDK.test();
        const ent = testsdk.Planet();
        (0, node_assert_1.equal)(null !== ent, true);
    });
    (0, node_test_1.test)('basic', async () => {
        const setup = basicSetup();
        const { dm, options, client, struct, explain } = setup;
        const { validate, transform } = struct;
        let ctrl = {};
        try {
            // Step: load_planet0 - load planet
            const load_planet0 = (0, utility_1.makeStepData)(dm, 'load_planet0');
            load_planet0.entity = client.Planet();
            load_planet0.match = (0, utility_1.makeMatch)(dm, transform, {
                "id": "`dm$=p.SOLARDEMO_TEST_PLANET_ENTID.planet01`"
            });
            load_planet0.resdata =
                await load_planet0.entity.load(load_planet0.match, ctrl = (0, utility_1.makeCtrl)(explain));
            if (explain) {
                console.log('load_planet0: ', ctrl.explain);
            }
            (0, utility_1.makeValid)(dm, validate, load_planet0.resdata, {
                "`$OPEN`": true,
                "id": "`dm$=s.load_planet0.match.id`"
            });
            // Step: update_planet1 - update planet
            const update_planet1 = (0, utility_1.makeStepData)(dm, 'update_planet1');
            update_planet1.entity = load_planet0.entity;
            update_planet1.reqdata = (0, utility_1.makeReqdata)(dm, transform, {});
            update_planet1.resdata =
                await update_planet1.entity.update(update_planet1.reqdata, ctrl = (0, utility_1.makeCtrl)(explain));
            if (explain) {
                console.log('update_planet1: ', ctrl.explain);
            }
            (0, utility_1.makeValid)(dm, validate, update_planet1.resdata, {
                "`$OPEN`": true,
                "id": "`dm$=s.load_planet0.match.id`"
            });
            // Step: load_planet2 - load planet
            const load_planet2 = (0, utility_1.makeStepData)(dm, 'load_planet2');
            load_planet2.entity = client.Planet();
            load_planet2.match = (0, utility_1.makeMatch)(dm, transform, {
                "id": "`dm$=p.SOLARDEMO_TEST_PLANET_ENTID.planet01`"
            });
            load_planet2.resdata =
                await load_planet2.entity.load(load_planet2.match, ctrl = (0, utility_1.makeCtrl)(explain));
            if (explain) {
                console.log('load_planet2: ', ctrl.explain);
            }
            (0, utility_1.makeValid)(dm, validate, load_planet2.resdata, {
                "`$OPEN`": true,
                "id": "`dm$=s.load_planet0.match.id`"
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
            "planet": {
                "PLANET01": {
                    "diameter": "s0",
                    "forbid": "s1",
                    "id": "PLANET01",
                    "kind": "s3",
                    "name": "s4",
                    "ok": "s5",
                    "start": "s6",
                    "state": "s7",
                    "stop": "s8",
                    "why": "s9"
                },
                "PLANET02": {
                    "diameter": "s64",
                    "forbid": "s65",
                    "id": "PLANET02",
                    "kind": "s67",
                    "name": "s68",
                    "ok": "s69",
                    "start": "s6a",
                    "state": "s6b",
                    "stop": "s6c",
                    "why": "s6d"
                },
                "PLANET03": {
                    "diameter": "sc8",
                    "forbid": "sc9",
                    "id": "PLANET03",
                    "kind": "scb",
                    "name": "scc",
                    "ok": "scd",
                    "start": "sce",
                    "state": "scf",
                    "stop": "sd0",
                    "why": "sd1"
                }
            }
        }
    };
    const setup = {
        dm: {
            p: (0, utility_1.envOverride)({
                "SOLARDEMO_TEST_PLANET_ENTID": {
                    "planet01": "PLANET01",
                    "planet02": "PLANET02",
                    "planet03": "PLANET03"
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
//# sourceMappingURL=PlanetEntity.test.js.map