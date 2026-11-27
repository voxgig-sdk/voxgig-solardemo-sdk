# Moon entity test

import json
import os
import time

import pytest

from voxgigsolardemo_sdk.utility.voxgig_struct import voxgig_struct as vs
from voxgigsolardemo_sdk import VoxgigSolardemoSDK
from voxgigsolardemo_sdk.core import helpers
from voxgigsolardemo_sdk.config import shared_config
from voxgigsolardemo_sdk.feature.base_feature import VoxgigSolardemoBaseFeature

_TEST_DIR = os.path.dirname(os.path.abspath(__file__))
from test import runner



# main.kit.test.live.strict is true (the default is true): a live
# request that fails, or a live test missing an input it needs,
# fails the test.
# An account with no record for a test to read skips it either way.
LIVE_STRICT = True


class TestMoonEntity:

    def test_should_create_instance(self):
        testsdk = VoxgigSolardemoSDK.test(None, None)
        ent = testsdk.Moon(None)
        assert ent is not None

    def test_should_refuse_an_invalid_request(self):
        if "validate" not in (shared_config().get("feature") or {}):
            pytest.skip("feature not present in this SDK: validate")
        client = VoxgigSolardemoSDK.test(
            None, {"feature": {"validate": {"active": True}}})
        with pytest.raises(Exception) as err:
            client.Moon(None).list({"planet_id": 1}, None)
        assert "validate_failed" == getattr(err.value, "code", None)

    def test_should_run_basic_flow(self):
        setup = _moon_basic_setup(None)
        # Per-op sdk-test-control.json skip — basic test exercises a flow with
        # multiple ops; skipping any one skips the whole flow (steps depend
        # on each other).
        _live = setup.get("live", False)
        for _op in ["create", "list", "update", "load", "remove"]:
            _skip, _reason = runner.is_control_skipped("entityOp", "moon." + _op, "live" if _live else "unit")
            if _skip:
                pytest.skip(_reason or "skipped via sdk-test-control.json")
                return
        if setup["live"] and os.environ.get("VOXGIG_GETONLY_GUARD") == "TRUE":
            print("LIVE STEP {\"id\":\"moon.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/moon\"}")
            print("LIVE STEP {\"id\":\"moon.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}/moon/{moon_id}\"}")
            print("LIVE STEP {\"id\":\"moon.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}/moon/{moon_id}\"}")
            print("LIVE STEP {\"id\":\"moon.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}")
            return self._run_get_only_flow(setup)

        if setup["live"]:
            for _live_key in ["planet01"]:
                if setup.get("synthetic_only") or setup["idmap"].get(_live_key) is None:
                    runner.live_miss(LIVE_STRICT, f"Live entity test blocked: needs {_live_key} via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        client = setup["client"]

        if setup["live"]:
            runner.live_pace()
        # CREATE
        moon_ref01_ent = client.Moon(None)
        moon_ref01_data = helpers.to_map(vs.getprop(
            vs.getpath(setup["data"], "new.moon"), "moon_ref01"))
        moon_ref01_data["planet_id"] = setup["idmap"]["planet01"]

        moon_ref01_data = helpers.to_map(runner.entity_data(moon_ref01_ent.create(moon_ref01_data, None)))
        assert moon_ref01_data is not None
        assert moon_ref01_data["id"] is not None

        if setup["live"]:
            runner.live_pace()
        # LIST
        moon_ref01_match = {
            "planet_id": setup["idmap"]["planet01"],
        }

        moon_ref01_list_result = moon_ref01_ent.list(moon_ref01_match, None)
        assert isinstance(moon_ref01_list_result, list)

        found_item = vs.select(
            runner.entity_list_to_data(moon_ref01_list_result),
            {"id": moon_ref01_data["id"]})
        assert not vs.isempty(found_item)

        if setup["live"]:
            runner.live_pace()
        # UPDATE
        moon_ref01_data_up0_up = {
            "id": moon_ref01_data["id"],
            "planet_id": setup["idmap"]["planet_id"],
        }

        moon_ref01_markdef_up0_name = "kind"
        moon_ref01_markdef_up0_value = "Mark01-moon_ref01_" + str(setup["now"])
        moon_ref01_data_up0_up[moon_ref01_markdef_up0_name] = moon_ref01_markdef_up0_value

        moon_ref01_resdata_up0 = helpers.to_map(runner.entity_data(moon_ref01_ent.update(moon_ref01_data_up0_up, None)))
        assert moon_ref01_resdata_up0 is not None
        assert runner.live_same_id(moon_ref01_resdata_up0.get("id"), moon_ref01_data_up0_up["id"])
        assert moon_ref01_resdata_up0[moon_ref01_markdef_up0_name] == moon_ref01_markdef_up0_value

        if setup["live"]:
            runner.live_pace()
        # LOAD
        moon_ref01_match_dt0 = {
            "id": moon_ref01_data["id"],
        }
        moon_ref01_match_dt0["planet_id"] = moon_ref01_data.get("planet_id") if isinstance(moon_ref01_data.get("planet_id"), (str, int, float)) else setup["idmap"].get("planet_id") or setup["idmap"].get("planet01")
        moon_ref01_data_dt0_loaded = moon_ref01_ent.load(moon_ref01_match_dt0, None)
        moon_ref01_data_dt0_load_result = helpers.to_map(runner.entity_data(moon_ref01_data_dt0_loaded))
        assert moon_ref01_data_dt0_load_result is not None
        assert runner.live_same_id(moon_ref01_data_dt0_load_result.get("id"), moon_ref01_data["id"])

        if setup["live"]:
            runner.live_pace()
        # REMOVE
        moon_ref01_match_rm0 = {
            "id": moon_ref01_data["id"],
        }
        moon_ref01_match_rm0["planet_id"] = setup["idmap"].get("planet_id") or setup["idmap"].get("planet01")
        moon_ref01_ent.remove(moon_ref01_match_rm0, None)

        if setup["live"]:
            runner.live_pace()
        # LIST
        moon_ref01_match_rt0 = {
            "planet_id": setup["idmap"]["planet01"],
        }

        moon_ref01_list_rt0_result = moon_ref01_ent.list(moon_ref01_match_rt0, None)
        assert isinstance(moon_ref01_list_rt0_result, list)

        not_found_item = vs.select(
            runner.entity_list_to_data(moon_ref01_list_rt0_result),
            {"id": moon_ref01_data["id"]})
        assert vs.isempty(not_found_item)


    def _run_get_only_flow(self, setup):
        if setup["live"]:
            for _live_key in ["planet01"]:
                if setup.get("synthetic_only") or setup["idmap"].get(_live_key) is None:
                    runner.live_miss(LIVE_STRICT, f"Live entity test blocked: needs {_live_key} via VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
        client = setup["client"]
        if setup["live"]:
            _live_id = None if setup.get("synthetic_only") else setup["idmap"].get("moon01")
            runner.live_pace()
            runner.live_existing(setup, LIVE_STRICT, "moon",
                                 lambda: client.Moon(None).list({"planet_id": setup["idmap"].get("planet01")}, None),
                                 "id", _live_id)

        # Bootstrap entity data from existing test data.
        moon_ref01_data_raw = vs.items(helpers.to_map(
            vs.getpath(setup["data"], "existing.moon")))
        moon_ref01_data = None
        if len(moon_ref01_data_raw) > 0:
            moon_ref01_data = helpers.to_map(moon_ref01_data_raw[0][1])

        if setup["live"]:
            runner.live_pace()
        # LIST
        moon_ref01_ent = client.Moon(None)
        moon_ref01_match = {
            "planet_id": setup["idmap"]["planet01"],
        }

        moon_ref01_list_result = moon_ref01_ent.list(moon_ref01_match, None)
        assert isinstance(moon_ref01_list_result, list)

        if setup["live"]:
            runner.live_pace()
        # LOAD
        moon_ref01_match_dt0 = {
            "id": moon_ref01_data["id"],
        }
        moon_ref01_match_dt0["planet_id"] = moon_ref01_data.get("planet_id") if isinstance(moon_ref01_data.get("planet_id"), (str, int, float)) else setup["idmap"].get("planet_id") or setup["idmap"].get("planet01")
        moon_ref01_data_dt0_loaded = moon_ref01_ent.load(moon_ref01_match_dt0, None)
        moon_ref01_data_dt0_load_result = helpers.to_map(runner.entity_data(moon_ref01_data_dt0_loaded))
        assert moon_ref01_data_dt0_load_result is not None
        assert runner.live_same_id(moon_ref01_data_dt0_load_result.get("id"), moon_ref01_data["id"])



def _moon_basic_setup(extra):
    runner.load_env_local()

    entity_data_file = os.path.join(_TEST_DIR, "../../.sdk/test/entity/moon/MoonTestData.json")
    with open(entity_data_file, "r", encoding="utf-8") as f:
        entity_data_source = f.read()

    entity_data = json.loads(entity_data_source)

    options = {}
    options["entity"] = entity_data.get("existing")

    client = VoxgigSolardemoSDK.test(options, extra)

    # Generate idmap via transform.
    idmap = vs.transform(
        ["moon01", "moon02", "moon03", "planet01", "planet02", "planet03"],
        {
            "`$PACK`": ["", {
                "`$KEY`": "`$COPY`",
                "`$VAL`": ["`$FORMAT`", "upper", "`$COPY`"],
            }],
        }
    )

    # Whether *_ENTID supplied the idmap, read before env_override consumes
    # it: without it, the ids a live flow binds are the fixture's synthetic ones.
    _entid_env_raw = os.environ.get(
        "VOXGIG_SOLARDEMO_TEST_MOON_ENTID")
    _idmap_overridden = _entid_env_raw is not None and _entid_env_raw.strip().startswith("{")

    env = runner.env_override({
        "VOXGIG_SOLARDEMO_TEST_MOON_ENTID": idmap,
        "VOXGIG_SOLARDEMO_TEST_LIVE": "FALSE",
        "VOXGIG_SOLARDEMO_TEST_EXPLAIN": "FALSE",
    })

    idmap_resolved = helpers.to_map(
        env.get("VOXGIG_SOLARDEMO_TEST_MOON_ENTID"))
    if idmap_resolved is None:
        idmap_resolved = helpers.to_map(idmap)
    if idmap_resolved.get("planet_id") is None:
        idmap_resolved["planet_id"] = idmap_resolved.get("planet01")

    if env.get("VOXGIG_SOLARDEMO_TEST_LIVE") == "TRUE":
        merged_opts = vs.merge([
            # FIRST, so the generated fields below win: sdk-test-control.json's
            # test.client.options adds to the live client, it does not
            # redirect it.
            runner.live_client_options(),
            {
            },
            extra or {},
        ])
        client = VoxgigSolardemoSDK(helpers.to_map(merged_opts))

    _live = env.get("VOXGIG_SOLARDEMO_TEST_LIVE") == "TRUE"
    return {
        "client": client,
        "data": entity_data,
        "idmap": idmap_resolved,
        "env": env,
        "explain": env.get("VOXGIG_SOLARDEMO_TEST_EXPLAIN") == "TRUE",
        "live": _live,
        "synthetic_only": _live and not _idmap_overridden,
        "now": int(time.time() * 1000),
    }
