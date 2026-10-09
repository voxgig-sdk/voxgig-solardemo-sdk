// Generated basic-flow test for the moon entity (model-driven;
// mirrors the go TestEntity generator).

#![allow(unused_variables, unused_mut, unused_imports)]

mod common;

use std::rc::Rc;

use common::*;

use voxgig_solardemo_sdk::core::helpers::{getp, getpath, ja, jo, now_ms, setp, to_map};
use voxgig_solardemo_sdk::utility::voxgigstruct as vs;
use voxgig_solardemo_sdk::{test_sdk, Entity, VoxgigSolardemoEntity, VoxgigSolardemoSDK, Value};

// main.kit.test.live.strict is true (the default is true): a live
// request that fails, or a live test missing an input it needs,
// fails the test.
// An account with no record for a test to read skips it either way.
const LIVE_STRICT: bool = true;

#[test]
fn moon_entity_instance() {
    let testsdk = test_sdk(Value::Noval, Value::Noval);
    let ent = testsdk.moon(Value::Noval);
    assert_eq!(ent.get_name(), "moon");
}

#[test]
fn moon_entity_validate() {
    if getp(&getp(&voxgig_solardemo_sdk::make_config(), "feature"), "validate").is_noval() {
        return;
    }
    let client = test_sdk(Value::Noval, jo(vec![(
        "feature",
        jo(vec![("validate", jo(vec![("active", Value::Bool(true))]))]),
    )]));
    let err = client
        .moon(Value::Noval)
        .list(jo(vec![("planet_id", Value::Num(1.0))]), Value::Noval)
        .err()
        .expect("an invalid request should fail");
    assert_eq!(err.code, "validate_failed");
}

#[test]
fn moon_entity_basic() {
    let setup = moon_basic_setup(Value::Noval);
    // Per-op sdk-test-control.json skip — the basic test exercises a flow
    // with multiple ops; skipping any op skips the whole flow.
    let mode = if setup.live { "live" } else { "unit" };
    for op in ["create", "list", "update", "load", "remove"] {
        let (skip, reason) = is_control_skipped("entityOp", &format!("moon.{}", op), mode);
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
    if setup.live {
        for live_key in ["planet01"] {
            if setup.synthetic_only || getp(&setup.idmap, live_key).is_noval() {
                live_miss(LIVE_STRICT, &format!("Live entity test blocked: needs {} via VOXGIG_SOLARDEMO_TEST_MOON_ENTID", live_key));
                return;
            }
        }
    }
    let client = setup.client.clone();
    // CREATE
    let moon_ref01_ent = client.moon(Value::Noval);
    let moon_ref01_data = to_map(&getp(
        &getpath(&["new", "moon"], &setup.data),
        "moon_ref01",
    ));
    setp(&moon_ref01_data, "planet_id", getp(&setup.idmap, "planet01"));

    let moon_ref01_data_result = moon_ref01_ent
        .create(moon_ref01_data.clone(), Value::Noval)
        .expect("create failed");
    let moon_ref01_data = to_map(&moon_ref01_data_result.data(None));
    assert!(
        matches!(moon_ref01_data, Value::Map(_)),
        "expected create result to be a map"
    );
    assert!(
        !getp(&moon_ref01_data, "id").is_noval(),
        "expected created entity to have an id"
    );

    // LIST
    let moon_ref01_match = Value::empty_map();
    setp(&moon_ref01_match, "planet_id", getp(&setup.idmap, "planet01"));

    let moon_ref01_list = moon_ref01_ent
        .list(moon_ref01_match.clone(), Value::Noval)
        .expect("list failed");
    // list resolves to one ENTITY per record; the flow asserts on the
    // records, so map each through data().
    let moon_ref01_list = ja(moon_ref01_list.iter().map(|e| e.data(None)).collect::<Vec<Value>>());

    let found_item = vs::select(
        &entity_list_to_data(&moon_ref01_list),
        &jo(vec![("id", getp(&moon_ref01_data, "id"))]),
    );
    assert!(
        !vs::is_empty(&found_item),
        "expected to find created entity in list"
    );

    // UPDATE
    let moon_ref01_data_up0_up = Value::empty_map();
    setp(&moon_ref01_data_up0_up, "id", getp(&moon_ref01_data, "id"));
    setp(&moon_ref01_data_up0_up, "planet_id", getp(&setup.idmap, "planet_id"));

    let moon_ref01_markdef_up0_name = "kind";
    let moon_ref01_markdef_up0_value = format!("Mark01-moon_ref01_{}", setup.now);
    setp(
        &moon_ref01_data_up0_up,
        moon_ref01_markdef_up0_name,
        Value::str(moon_ref01_markdef_up0_value.clone()),
    );

    let moon_ref01_resdata_up0_result = moon_ref01_ent
        .update(moon_ref01_data_up0_up.clone(), Value::Noval)
        .expect("update failed");
    let moon_ref01_resdata_up0 = to_map(&moon_ref01_resdata_up0_result.data(None));
    assert!(
        matches!(moon_ref01_resdata_up0, Value::Map(_)),
        "expected update result to be a map"
    );
    assert_eq!(
        getp(&moon_ref01_resdata_up0, "id"),
        getp(&moon_ref01_data_up0_up, "id"),
        "expected update result id to match"
    );
    assert_eq!(
        getp(&moon_ref01_resdata_up0, moon_ref01_markdef_up0_name),
        Value::str(moon_ref01_markdef_up0_value.clone()),
        "expected {} to be updated",
        moon_ref01_markdef_up0_name
    );

    // LOAD
    let moon_ref01_match_dt0 = jo(vec![("id", getp(&moon_ref01_data, "id"))]);
    setp(&moon_ref01_match_dt0, "planet_id", match getp(&setup.idmap, "planet_id") {
        v if v.is_nullish() => getp(&setup.idmap, "planet01"),
        v => v,
    });
    let moon_ref01_data_dt0_loaded = moon_ref01_ent
        .load(moon_ref01_match_dt0.clone(), Value::Noval)
        .expect("load failed");
    let moon_ref01_data_dt0_load_result = to_map(&moon_ref01_data_dt0_loaded.data(None));
    assert!(
        matches!(moon_ref01_data_dt0_load_result, Value::Map(_)),
        "expected load result to be a map"
    );
    assert_eq!(
        getp(&moon_ref01_data_dt0_load_result, "id"),
        getp(&moon_ref01_data, "id"),
        "expected load result id to match"
    );

    // REMOVE
    let moon_ref01_match_rm0 = jo(vec![("id", getp(&moon_ref01_data, "id"))]);
    setp(&moon_ref01_match_rm0, "planet_id", match getp(&setup.idmap, "planet_id") {
        v if v.is_nullish() => getp(&setup.idmap, "planet01"),
        v => v,
    });
    moon_ref01_ent
        .remove(moon_ref01_match_rm0.clone(), Value::Noval)
        .expect("remove failed");

    // LIST
    let moon_ref01_match_rt0 = Value::empty_map();
    setp(&moon_ref01_match_rt0, "planet_id", getp(&setup.idmap, "planet01"));

    let moon_ref01_list_rt0 = moon_ref01_ent
        .list(moon_ref01_match_rt0.clone(), Value::Noval)
        .expect("list failed");
    // list resolves to one ENTITY per record; the flow asserts on the
    // records, so map each through data().
    let moon_ref01_list_rt0 = ja(moon_ref01_list_rt0.iter().map(|e| e.data(None)).collect::<Vec<Value>>());

    let not_found_item = vs::select(
        &entity_list_to_data(&moon_ref01_list_rt0),
        &jo(vec![("id", getp(&moon_ref01_data, "id"))]),
    );
    assert!(
        vs::is_empty(&not_found_item),
        "expected removed entity to not be in list"
    );

}

fn moon_basic_setup(extra: Value) -> EntityTestSetup {
    load_env_local();

    let mut entity_data_file = manifest_dir();
    entity_data_file.push("..");
    entity_data_file.push(".sdk");
    entity_data_file.push("test");
    entity_data_file.push("entity");
    entity_data_file.push("moon");
    entity_data_file.push("MoonTestData.json");

    let entity_data = read_json(&entity_data_file);

    let options = jo(vec![("entity", getp(&entity_data, "existing"))]);

    let client = test_sdk(options, extra.clone());

    // Generate idmap via transform, matching the TS pattern.
    let idmap = vs::transform(
        &ja(vec![Value::str("moon01"), Value::str("moon02"), Value::str("moon03"), Value::str("planet01"), Value::str("planet02"), Value::str("planet03")]),
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
    let entid_env_raw = std::env::var("VOXGIG_SOLARDEMO_TEST_MOON_ENTID").unwrap_or_default();
    let idmap_overridden =
        !entid_env_raw.trim().is_empty() && entid_env_raw.trim().starts_with('{');

    let env = env_override(jo(vec![
        ("VOXGIG_SOLARDEMO_TEST_MOON_ENTID", idmap.clone()),
        ("VOXGIG_SOLARDEMO_TEST_LIVE", Value::str("FALSE")),
        ("VOXGIG_SOLARDEMO_TEST_EXPLAIN", Value::str("FALSE")),
    ]));

    let idmap_resolved = match to_map(&getp(&env, "VOXGIG_SOLARDEMO_TEST_MOON_ENTID")) {
        Value::Map(m) => Value::Map(m),
        _ => to_map(&idmap),
    };

    // Add planet_id alias for the update test.
    if getp(&idmap_resolved, "planet_id").is_noval() {
        let aliased = getp(&idmap_resolved, "planet01");
        setp(&idmap_resolved, "planet_id", aliased);
    }

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
        VoxgigSolardemoSDK::new(to_map(&merged))
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
