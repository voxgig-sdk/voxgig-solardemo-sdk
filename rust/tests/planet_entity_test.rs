// Generated basic-flow test for the planet entity (model-driven;
// mirrors the go TestEntity generator).

#![allow(unused_variables, unused_mut, unused_imports)]

mod common;

use std::rc::Rc;

use common::*;

use voxgig_solardemo_sdk::core::helpers::{getp, getpath, ja, jo, now_ms, setp, to_map};
use voxgig_solardemo_sdk::utility::voxgigstruct as vs;
use voxgig_solardemo_sdk::{test_sdk, Entity, VoxgigSolardemoEntityBase, VoxgigSolardemoSDK, Value};

// main.kit.test.live.strict is true (the default is true): a live
// request that fails, or a live test missing an input it needs,
// fails the test.
// An account with no record for a test to read skips it either way.
const LIVE_STRICT: bool = true;

#[test]
fn planet_entity_instance() {
    let testsdk = test_sdk(Value::Noval, Value::Noval);
    let ent = testsdk.planet(Value::Noval);
    assert_eq!(ent.get_name(), "planet");
}

#[test]
fn planet_entity_stream() {
    // stream() runs the list op through the full pipeline and yields each
    // result item. Seed two entities via test mode; with the `streaming`
    // feature active it yields the feature's incremental items, else it
    // falls back to the materialised items — either way every item yields.
    let seed = jo(vec![(
        "entity",
        jo(vec![(
            "planet",
            jo(vec![
                ("strm01", jo(vec![("id", Value::str("strm01"))])),
                ("strm02", jo(vec![("id", Value::str("strm02"))])),
            ]),
        )]),
    )]);

    let sdkopts = jo(vec![(
        "feature",
        jo(vec![("streaming", jo(vec![("active", Value::Bool(true))]))]),
    )]);

    let testsdk = test_sdk(seed.clone(), sdkopts);
    let ent = testsdk.planet(Value::Noval);
    let items: Vec<Value> = ent
        .stream("list", Value::empty_map(), Value::empty_map())
        .expect("stream failed")
        .collect();
    assert_eq!(items.len(), 2, "stream should yield both seeded items");

    // Fallback: streaming inactive still yields both materialised items.
    let plainsdk = test_sdk(seed, Value::Noval);
    let plainent = plainsdk.planet(Value::Noval);
    let plain_items: Vec<Value> = plainent
        .stream("list", Value::empty_map(), Value::empty_map())
        .expect("stream failed")
        .collect();
    assert_eq!(plain_items.len(), 2, "fallback stream should yield both items");
}

#[test]
fn planet_entity_stream_error() {
    let offline = jo(vec![("net", jo(vec![("offline", Value::Bool(true))]))]);
    let err = test_sdk(offline.clone(), Value::Noval)
        .planet(Value::Noval)
        .stream("list", Value::empty_map(), Value::empty_map())
        .err()
        .expect("a failed operation should fail the stream");
    assert!(err.msg.contains("offline"), "{}", err.msg);

    let quiet = jo(vec![("ctrl", jo(vec![("throw", Value::Bool(false))]))]);
    assert!(test_sdk(offline, Value::Noval)
        .planet(Value::Noval)
        .stream("list", Value::empty_map(), quiet)
        .is_ok());

    if !getp(&getp(&voxgig_solardemo_sdk::make_config(), "feature"), "rbac").is_noval() {
        let denied = test_sdk(Value::Noval, jo(vec![(
            "feature",
            jo(vec![("rbac", jo(vec![("active", Value::Bool(true)), ("deny", Value::Bool(true))]))]),
        )]));
        let denyerr = denied
            .planet(Value::Noval)
            .stream("list", Value::empty_map(), Value::empty_map())
            .err()
            .expect("a denied operation should fail the stream");
        assert_eq!(denyerr.code, "rbac_denied");
    }
}

#[test]
fn planet_entity_stream_ctrl() {
    let explain = Value::empty_map();
    let ctrl = jo(vec![("explain", explain.clone())]);
    let items: Vec<Value> = test_sdk(Value::Noval, Value::Noval)
        .planet(Value::Noval)
        .stream("list", Value::empty_map(), jo(vec![("ctrl", ctrl.clone())]))
        .expect("stream failed")
        .collect();
    assert!(getp(&ctrl, "stream").is_noval(), "the stream changed the caller's ctrl");
    let filled = match &explain {
        Value::Map(m) => !m.borrow().is_empty(),
        _ => false,
    };
    assert!(filled, "the caller's explain record was not filled");
}

#[test]
fn planet_entity_validate() {
    if getp(&getp(&voxgig_solardemo_sdk::make_config(), "feature"), "validate").is_noval() {
        return;
    }
    let client = test_sdk(Value::Noval, jo(vec![(
        "feature",
        jo(vec![("validate", jo(vec![("active", Value::Bool(true))]))]),
    )]));
    let err = client
        .planet(Value::Noval)
        .list(jo(vec![("diameter", Value::str("x"))]), Value::Noval)
        .err()
        .expect("an invalid request should fail");
    assert_eq!(err.code, "validate_failed");
}

#[test]
fn planet_entity_basic() {
    let setup = planet_basic_setup(Value::Noval);
    // Per-op sdk-test-control.json skip — the basic test exercises a flow
    // with multiple ops; skipping any op skips the whole flow.
    let mode = if setup.live { "live" } else { "unit" };
    for op in ["create", "list", "update", "load", "remove"] {
        let (skip, reason) = is_control_skipped("entityOp", &format!("planet.{}", op), mode);
        if skip {
            let reason = if reason.is_empty() {
                "skipped via sdk-test-control.json".to_string()
            } else {
                reason
            };
            eprintln!("skip: {}", reason);
            return;
        }
    }
    if setup.live && std::env::var("VOXGIG_GETONLY_GUARD").map(|v| v == "TRUE").unwrap_or(false) {
        println!("{}", "LIVE STEP {\"id\":\"planet.create.0\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs POST /api/planet/{planet_id}/forbid\"}");
        println!("{}", "LIVE STEP {\"id\":\"planet.update.2\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs PUT /api/planet/{planet_id}\"}");
        println!("{}", "LIVE STEP {\"id\":\"planet.remove.4\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: needs DELETE /api/planet/{planet_id}\"}");
        println!("{}", "LIVE STEP {\"id\":\"planet.list.5\",\"state\":\"excluded\",\"attempted\":false,\"reason\":\"GET-only live run: checks a removal this run does not make\"}");
    let client = setup.client.clone();
    if setup.live {
        let live_id = if setup.synthetic_only { Value::Noval } else { getp(&setup.idmap, "planet01") };
        live_pace();
        if !live_existing(&setup.data, LIVE_STRICT, "planet", "id", live_id, || {
            client
                .planet(Value::Noval)
                .list(jo(vec![]), Value::Noval)
                .map(|list| ja(list.iter().map(|e| e.data(None)).collect::<Vec<Value>>()))
        }) {
            return;
        }
    }

    // Bootstrap entity data from existing test data (no create step in flow).
    let planet_ref01_data_raw = vs::items(&to_map(&getpath(&["existing", "planet"], &setup.data)));
    let planet_ref01_data = to_map(&vs::get_elem(
        &vs::get_elem(&planet_ref01_data_raw, &Value::Num(0.0), Value::Noval),
        &Value::Num(1.0),
        Value::Noval,
    ));
    if setup.live {
        live_pace();
    }
    // LIST
    let planet_ref01_ent = client.planet(Value::Noval);
    let planet_ref01_match = Value::empty_map();

    let planet_ref01_list = planet_ref01_ent
        .list(planet_ref01_match.clone(), Value::Noval)
        .expect("list failed");
    // list resolves to one ENTITY per record; the flow asserts on the
    // records, so map each through data().
    let planet_ref01_list = ja(planet_ref01_list.iter().map(|e| e.data(None)).collect::<Vec<Value>>());

    if setup.live {
        live_pace();
    }
    // LOAD
    let planet_ref01_match_dt0 = jo(vec![("id", getp(&planet_ref01_data, "id"))]);
    let planet_ref01_data_dt0_loaded = planet_ref01_ent
        .load(planet_ref01_match_dt0.clone(), Value::Noval)
        .expect("load failed");
    let planet_ref01_data_dt0_load_result = to_map(&planet_ref01_data_dt0_loaded.data(None));
    assert!(
        matches!(planet_ref01_data_dt0_load_result, Value::Map(_)),
        "expected load result to be a map"
    );
    assert!(live_same_id(&getp(&planet_ref01_data_dt0_load_result, "id"), &getp(&planet_ref01_data, "id")), "expected load result id to match");

        return;
    }

    let client = setup.client.clone();
    if setup.live {
        live_pace();
    }
    // CREATE
    let planet_ref01_ent = client.planet(Value::Noval);
    let planet_ref01_data = to_map(&getp(
        &getpath(&["new", "planet"], &setup.data),
        "planet_ref01",
    ));

    let planet_ref01_data_result = planet_ref01_ent
        .create(planet_ref01_data.clone(), Value::Noval)
        .expect("create failed");
    let planet_ref01_data = to_map(&planet_ref01_data_result.data(None));
    assert!(
        matches!(planet_ref01_data, Value::Map(_)),
        "expected create result to be a map"
    );
    assert!(
        !getp(&planet_ref01_data, "id").is_noval(),
        "expected created entity to have an id"
    );

    if setup.live {
        live_pace();
    }
    // LIST
    let planet_ref01_match = Value::empty_map();

    let planet_ref01_list = planet_ref01_ent
        .list(planet_ref01_match.clone(), Value::Noval)
        .expect("list failed");
    // list resolves to one ENTITY per record; the flow asserts on the
    // records, so map each through data().
    let planet_ref01_list = ja(planet_ref01_list.iter().map(|e| e.data(None)).collect::<Vec<Value>>());

    let found_item = vs::select(
        &entity_list_to_data(&planet_ref01_list),
        &jo(vec![("id", getp(&planet_ref01_data, "id"))]),
    );
    assert!(
        !vs::is_empty(&found_item),
        "expected to find created entity in list"
    );

    if setup.live {
        live_pace();
    }
    // UPDATE
    let planet_ref01_data_up0_up = Value::empty_map();
    setp(&planet_ref01_data_up0_up, "id", getp(&planet_ref01_data, "id"));

    let planet_ref01_markdef_up0_name = "kind";
    let planet_ref01_markdef_up0_value = format!("Mark01-planet_ref01_{}", setup.now);
    setp(
        &planet_ref01_data_up0_up,
        planet_ref01_markdef_up0_name,
        Value::str(planet_ref01_markdef_up0_value.clone()),
    );

    let planet_ref01_resdata_up0_result = planet_ref01_ent
        .update(planet_ref01_data_up0_up.clone(), Value::Noval)
        .expect("update failed");
    let planet_ref01_resdata_up0 = to_map(&planet_ref01_resdata_up0_result.data(None));
    assert!(
        matches!(planet_ref01_resdata_up0, Value::Map(_)),
        "expected update result to be a map"
    );
    assert!(live_same_id(&getp(&planet_ref01_resdata_up0, "id"), &getp(&planet_ref01_data_up0_up, "id")), "expected update result id to match");
    assert_eq!(
        getp(&planet_ref01_resdata_up0, planet_ref01_markdef_up0_name),
        Value::str(planet_ref01_markdef_up0_value.clone()),
        "expected {} to be updated",
        planet_ref01_markdef_up0_name
    );

    if setup.live {
        live_pace();
    }
    // LOAD
    let planet_ref01_match_dt0 = jo(vec![("id", getp(&planet_ref01_data, "id"))]);
    let planet_ref01_data_dt0_loaded = planet_ref01_ent
        .load(planet_ref01_match_dt0.clone(), Value::Noval)
        .expect("load failed");
    let planet_ref01_data_dt0_load_result = to_map(&planet_ref01_data_dt0_loaded.data(None));
    assert!(
        matches!(planet_ref01_data_dt0_load_result, Value::Map(_)),
        "expected load result to be a map"
    );
    assert!(live_same_id(&getp(&planet_ref01_data_dt0_load_result, "id"), &getp(&planet_ref01_data, "id")), "expected load result id to match");

    if setup.live {
        live_pace();
    }
    // REMOVE
    let planet_ref01_match_rm0 = jo(vec![("id", getp(&planet_ref01_data, "id"))]);
    planet_ref01_ent
        .remove(planet_ref01_match_rm0.clone(), Value::Noval)
        .expect("remove failed");

    if setup.live {
        live_pace();
    }
    // LIST
    let planet_ref01_match_rt0 = Value::empty_map();

    let planet_ref01_list_rt0 = planet_ref01_ent
        .list(planet_ref01_match_rt0.clone(), Value::Noval)
        .expect("list failed");
    // list resolves to one ENTITY per record; the flow asserts on the
    // records, so map each through data().
    let planet_ref01_list_rt0 = ja(planet_ref01_list_rt0.iter().map(|e| e.data(None)).collect::<Vec<Value>>());

    let not_found_item = vs::select(
        &entity_list_to_data(&planet_ref01_list_rt0),
        &jo(vec![("id", getp(&planet_ref01_data, "id"))]),
    );
    assert!(
        vs::is_empty(&not_found_item),
        "expected removed entity to not be in list"
    );

}

fn planet_basic_setup(extra: Value) -> EntityTestSetup {
    load_env_local();

    let mut entity_data_file = manifest_dir();
    entity_data_file.push("..");
    entity_data_file.push(".sdk");
    entity_data_file.push("test");
    entity_data_file.push("entity");
    entity_data_file.push("planet");
    entity_data_file.push("PlanetTestData.json");

    let entity_data = read_json(&entity_data_file);

    let options = jo(vec![("entity", getp(&entity_data, "existing"))]);

    let client = test_sdk(options, extra.clone());

    // Generate idmap via transform, matching the TS pattern.
    let idmap = vs::transform(
        &ja(vec![Value::str("planet01"), Value::str("planet02"), Value::str("planet03")]),
        &jo(vec![(
            "`$PACK`",
            ja(vec![
                Value::str(""),
                jo(vec![
                    ("`$KEY`", Value::str("`$COPY`")),
                    (
                        "`$VAL`",
                        ja(vec![
                            Value::str("`$FORMAT`"),
                            Value::str("upper"),
                            Value::str("`$COPY`"),
                        ]),
                    ),
                ]),
            ]),
        )]),
        None,
    )
    .unwrap_or_else(|_| Value::empty_map());

    // Whether *_ENTID supplied the idmap, read before env_override consumes
    // it: without it, the ids a live flow binds are the fixture's synthetic ones.
    let entid_env_raw = std::env::var("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID").unwrap_or_default();
    let idmap_overridden =
        !entid_env_raw.trim().is_empty() && entid_env_raw.trim().starts_with('{');

    let env = env_override(jo(vec![
        ("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID", idmap.clone()),
        ("VOXGIG_SOLARDEMO_TEST_LIVE", Value::str("FALSE")),
        ("VOXGIG_SOLARDEMO_TEST_EXPLAIN", Value::str("FALSE")),
    ]));

    let idmap_resolved = match to_map(&getp(&env, "VOXGIG_SOLARDEMO_TEST_PLANET_ENTID")) {
        Value::Map(m) => Value::Map(m),
        _ => to_map(&idmap),
    };

    let live = getp(&env, "VOXGIG_SOLARDEMO_TEST_LIVE") == Value::str("TRUE");

    let client = if live {
        let merged = vs::merge(
            // live_client_options() FIRST, so the generated entries below win:
            // sdk-test-control.json's test.client.options adds to the live
            // client, it does not redirect it.
            &ja(vec![
                live_client_options(),
                jo(vec![]),
                // A NON-NODE later entry REPLACES the accumulated map in
                // vs::merge, and the normal call passes Value::Noval - so a
                // a bare extra discarded live_client_options() and the
                // apikey/server map above it, and the live client was
                // constructed with nothing.
                match extra {
                    Value::Map(m) => Value::Map(m),
                    _ => Value::empty_map(),
                },
            ]),
            None,
        );
        VoxgigSolardemoSDK::new(to_map(&merged)).unwrap()
    } else {
        client
    };

    EntityTestSetup {
        client,
        data: entity_data,
        idmap: idmap_resolved,
        env: env.clone(),
        explain: getp(&env, "VOXGIG_SOLARDEMO_TEST_EXPLAIN") == Value::str("TRUE"),
        live,
        synthetic_only: live && !idmap_overridden,
        now: now_ms(),
    }
}
