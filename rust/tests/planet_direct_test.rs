// Generated direct-call tests for the planet entity (mirrors the
// go TestDirect generator; the live-mode path uses idmap-provided IDs).

#![allow(unused_variables, unused_imports, dead_code)]

mod common;

use std::cell::RefCell;
use std::rc::Rc;

use common::*;

use voxgig_solardemo_sdk::core::helpers::{getp, ja, jo, json_thunk, setp, to_int, to_map};
use voxgig_solardemo_sdk::utility::voxgigstruct as vs;
use voxgig_solardemo_sdk::{json_parse, Value, VoxgigSolardemoSDK};

// main.kit.test.live.strict is true (the default is true): a live
// request that fails, or a live test missing an input it needs,
// fails the test.
// An account with no record for a test to read skips it either way.
const LIVE_STRICT: bool = true;

struct PlanetDirectSetup {
    client: Rc<VoxgigSolardemoSDK>,
    calls: Rc<RefCell<Vec<Value>>>,
    live: bool,
    idmap: Value,
}

fn planet_direct_setup(mockres: Value) -> PlanetDirectSetup {
    load_env_local();

    let calls: Rc<RefCell<Vec<Value>>> = Rc::new(RefCell::new(Vec::new()));

    let env = env_override(jo(vec![
        ("VOXGIG_SOLARDEMO_TEST_PLANET_ENTID", Value::empty_map()),
        ("VOXGIG_SOLARDEMO_TEST_LIVE", Value::str("FALSE")),
    ]));

    let live = getp(&env, "VOXGIG_SOLARDEMO_TEST_LIVE") == Value::str("TRUE");

    if live {
        // live_client_options() FIRST, so the generated entries below win:
        // sdk-test-control.json's test.client.options adds to the live
        // client, it does not redirect it.
        let client = VoxgigSolardemoSDK::new(to_map(&vs::merge(
            &ja(vec![
                live_client_options(),
                jo(vec![]),
            ]),
            None,
        )));
        let idmap = match to_map(&getp(&env, "VOXGIG_SOLARDEMO_TEST_PLANET_ENTID")) {
            Value::Map(m) => Value::Map(m),
            _ => Value::empty_map(),
        };
        return PlanetDirectSetup {
            client,
            calls,
            live: true,
            idmap,
        };
    }

    let c = calls.clone();
    let mock_fetch = Value::func(move |_inj, args, _r, _s| {
        let url = vs::get_elem(args, &Value::Num(0.0), Value::Noval);
        let init = vs::get_elem(args, &Value::Num(1.0), Value::Noval);
        c.borrow_mut().push(jo(vec![("url", url), ("init", init)]));
        let data = if mockres.is_noval() || mockres.is_null() {
            jo(vec![("id", Value::str("direct01"))])
        } else {
            mockres.clone()
        };
        jo(vec![
            ("status", Value::Num(200.0)),
            ("statusText", Value::str("OK")),
            ("headers", Value::empty_map()),
            ("json", json_thunk(data)),
        ])
    });

    let client = VoxgigSolardemoSDK::new(jo(vec![
        ("base", Value::str("http://localhost:8080")),
        ("system", jo(vec![("fetch", mock_fetch)])),
    ]));

    PlanetDirectSetup {
        client,
        calls,
        live: false,
        idmap: Value::empty_map(),
    }
}

#[test]
fn planet_direct_list() {
    let setup = planet_direct_setup(ja(vec![
        jo(vec![("id", Value::str("direct01"))]),
        jo(vec![("id", Value::str("direct02"))]),
    ]));
    let mode = if setup.live { "live" } else { "unit" };
    let (skip, reason) = is_control_skipped("direct", "direct-list-planet", mode);
    if skip {
        eprintln!(
            "skip: {}",
            if reason.is_empty() {
                "skipped via sdk-test-control.json".to_string()
            } else {
                reason
            }
        );
        return;
    }
    let client = setup.client.clone();

    let params = Value::empty_map();

    let result = match client.direct(jo(vec![
        ("path", Value::str("api/planet")),
        ("method", Value::str("GET")),
        ("params", params.clone()),
    ])) {
        Ok(result) => result,
        Err(err) if setup.live => {
            live_miss(LIVE_STRICT, &format!("Live list failed: {}", err));
            return;
        }
        Err(err) => panic!("direct failed: {}", err),
    };

    if setup.live {
        if !live_ok(&result) {
            live_miss(LIVE_STRICT, &format!("Live list failed: {}", live_describe(&result)));
            return;
        }
        if live_list(&getp(&result, "data")).is_none() {
            live_miss(LIVE_STRICT, &format!("Live list returned no list: {}", live_describe(&result)));
            return;
        }
    } else {
        assert_eq!(getp(&result, "ok"), Value::Bool(true), "expected ok true");
        assert_eq!(to_int(&getp(&result, "status")), 200, "expected status 200");

        let data = getp(&result, "data");
        assert!(
            matches!(data, Value::List(_)),
            "expected data to be an array"
        );
        assert_eq!(vs::size(&data), 2, "expected 2 items");

        assert_eq!(setup.calls.borrow().len(), 1, "expected 1 call");
    }
}

#[test]
fn planet_direct_load() {
    let setup = planet_direct_setup(jo(vec![("id", Value::str("direct01"))]));
    let mode = if setup.live { "live" } else { "unit" };
    let (skip, reason) = is_control_skipped("direct", "direct-load-planet", mode);
    if skip {
        eprintln!(
            "skip: {}",
            if reason.is_empty() {
                "skipped via sdk-test-control.json".to_string()
            } else {
                reason
            }
        );
        return;
    }
    let client = setup.client.clone();

    let params = Value::empty_map();
    if setup.live {
        let list_result = match client.direct(jo(vec![
            ("path", Value::str("api/planet")),
            ("method", Value::str("GET")),
            ("params", jo(vec![])),
        ])) {
            Ok(list_result) => list_result,
            Err(err) => {
                live_miss(LIVE_STRICT, &format!("Live list discovery failed: {}", err));
                return;
            }
        };
        if !live_ok(&list_result) {
            live_miss(LIVE_STRICT, &format!("Live list discovery failed: {}", live_describe(&list_result)));
            return;
        }
        let records = match live_list(&getp(&list_result, "data")) {
            Some(records) => records,
            None => {
                live_miss(LIVE_STRICT, &format!("Live list discovery returned no list: {}", live_describe(&list_result)));
                return;
            }
        };
        let first = vs::get_elem(&records, &Value::Num(0.0), Value::Noval);
        if first.is_noval() {
            live_empty("The account has no planet record to load");
            return;
        }
        let mut found = getp(&first, "id");
        if found.is_noval() {
            found = getp(&first, "id");
        }
        if found.is_noval() {
            live_miss(LIVE_STRICT, "Live load blocked: discovery returned no usable identity");
            return;
        }
        setp(&params, "id", found);
    } else {
        setp(&params, "id", Value::str("direct01"));
    }

    let result = match client.direct(jo(vec![
        ("path", Value::str("api/planet/{id}")),
        ("method", Value::str("GET")),
        ("params", params.clone()),
    ])) {
        Ok(result) => result,
        Err(err) if setup.live => {
            live_miss(LIVE_STRICT, &format!("Live load failed: {}", err));
            return;
        }
        Err(err) => panic!("direct failed: {}", err),
    };

    if setup.live {
        if !live_ok(&result) {
            live_miss(LIVE_STRICT, &format!("Live load failed: {}", live_describe(&result)));
            return;
        }
        if getp(&result, "data").is_noval() {
            live_miss(LIVE_STRICT, &format!("Live load returned no data: {}", live_describe(&result)));
            return;
        }
    } else {
        assert_eq!(getp(&result, "ok"), Value::Bool(true), "expected ok true");
        assert_eq!(to_int(&getp(&result, "status")), 200, "expected status 200");
        assert!(
            !getp(&result, "data").is_noval(),
            "expected data to be non-nil"
        );

        let data = getp(&result, "data");
        if let Value::Map(_) = data {
            assert_eq!(
                getp(&data, "id"),
                Value::str("direct01"),
                "expected data.id to be direct01"
            );
        }

        assert_eq!(setup.calls.borrow().len(), 1, "expected 1 call");
        let call = setup.calls.borrow()[0].clone();
        assert_eq!(
            getp(&getp(&call, "init"), "method"),
            Value::str("GET"),
            "expected method GET"
        );
        let url = match getp(&call, "url") {
            Value::Str(u) => u,
            _ => String::new(),
        };
        assert!(
            url.contains("direct01"),
            "expected url to contain direct01, got {}",
            url
        );
    }
}
