// Generated API configuration (mirrors go core/config.go).

use std::cell::RefCell;
use std::rc::Rc;

use crate::core::types::FeatureRef;
use crate::utility::voxgigstruct::Value;

pub fn make_config() -> Value {
    Value::map_of([
        ("main".to_string(), Value::map_of([
            ("name".to_string(), Value::str("VoxgigSolardemo")),
            ("slug".to_string(), Value::str("voxgig-solardemo")),
            ("version".to_string(), Value::str("0.1.0")),
            ("target".to_string(), Value::str("rust")),
        ])),
        ("feature".to_string(), Value::map_of([
            ("debug".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("max".to_string(), Value::Num(100f64)),
                    ("redact".to_string(), Value::list(vec![
                        Value::str("authorization"),
                        Value::str("cookie"),
                        Value::str("set-cookie"),
                        Value::str("api-key"),
                        Value::str("apikey"),
                        Value::str("x-api-key"),
                        Value::str("idempotency-key"),
                    ])),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("now".to_string(), Value::str("`$FUNCTION`")),
                    ("onEntry".to_string(), Value::str("`$FUNCTION`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("none")),
            ])),
            ("idempotency".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("header".to_string(), Value::str("Idempotency-Key")),
                    ("methods".to_string(), Value::list(vec![
                        Value::str("POST"),
                        Value::str("PUT"),
                        Value::str("PATCH"),
                        Value::str("DELETE"),
                    ])),
                    ("ops".to_string(), Value::list(vec![
                        Value::str("create"),
                        Value::str("update"),
                        Value::str("remove"),
                    ])),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("keygen".to_string(), Value::str("`$FUNCTION`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("none")),
            ])),
            ("metrics".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("now".to_string(), Value::str("`$FUNCTION`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("none")),
            ])),
            ("paging".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("afterVar".to_string(), Value::str("after")),
                    ("cursorParam".to_string(), Value::str("cursor")),
                    ("firstVar".to_string(), Value::str("first")),
                    ("limitParam".to_string(), Value::str("limit")),
                    ("pageParam".to_string(), Value::str("page")),
                    ("startPage".to_string(), Value::Num(1f64)),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("limit".to_string(), Value::str("`$NUMBER`")),
                    ("ops".to_string(), Value::str("`$LIST`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("none")),
            ])),
            ("ratelimit".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("burst".to_string(), Value::Num(5f64)),
                    ("rate".to_string(), Value::Num(5f64)),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("now".to_string(), Value::str("`$FUNCTION`")),
                    ("sleep".to_string(), Value::str("`$FUNCTION`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("wrap")),
            ])),
            ("retry".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("factor".to_string(), Value::Num(2f64)),
                    ("maxDelay".to_string(), Value::Num(2000f64)),
                    ("minDelay".to_string(), Value::Num(50f64)),
                    ("retries".to_string(), Value::Num(2f64)),
                    ("statuses".to_string(), Value::list(vec![
                        Value::Num(408f64),
                        Value::Num(425f64),
                        Value::Num(429f64),
                        Value::Num(500f64),
                        Value::Num(502f64),
                        Value::Num(503f64),
                        Value::Num(504f64),
                    ])),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("jitter".to_string(), Value::str("`$BOOLEAN`")),
                    ("sleep".to_string(), Value::str("`$FUNCTION`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("wrap")),
            ])),
            ("secrets".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("cache".to_string(), Value::Bool(true)),
                    ("exchange".to_string(), Value::map_of([
                        ("active".to_string(), Value::Bool(false)),
                        ("method".to_string(), Value::str("POST")),
                        ("path".to_string(), Value::str("auth/token")),
                        ("refresh".to_string(), Value::str("")),
                        ("request".to_string(), Value::str("refresh_token")),
                        ("response".to_string(), Value::str("access_token")),
                        ("retries".to_string(), Value::Num(1f64)),
                        ("statuses".to_string(), Value::list(vec![
                            Value::Num(401f64),
                        ])),
                    ])),
                    ("name".to_string(), Value::str("apikey")),
                    ("providers".to_string(), Value::empty_list()),
                ])),
                ("optspec".to_string(), Value::empty_map()),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("wrap")),
            ])),
            ("test".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("entity".to_string(), Value::str("`$MAP`")),
                    ("net".to_string(), Value::str("`$MAP`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("base")),
            ])),
            ("timeout".to_string(), Value::map_of([
                ("options".to_string(), Value::map_of([
                    ("active".to_string(), Value::Bool(false)),
                    ("ms".to_string(), Value::Num(30000f64)),
                ])),
                ("optspec".to_string(), Value::map_of([
                    ("clearTimer".to_string(), Value::str("`$FUNCTION`")),
                    ("setTimer".to_string(), Value::str("`$FUNCTION`")),
                ])),
                ("strict".to_string(), Value::Bool(false)),
                ("transport".to_string(), Value::str("wrap")),
            ])),
        ])),
        ("options".to_string(), Value::map_of([
            ("base".to_string(), Value::str("http://localhost:8901")),
            ("headers".to_string(), Value::map_of([
                ("content-type".to_string(), Value::str("application/json")),
            ])),
            ("entity".to_string(), Value::map_of([
                ("moon".to_string(), Value::empty_map()),
                ("planet".to_string(), Value::empty_map()),
            ])),
        ])),
        ("entity".to_string(), Value::map_of([
            ("moon".to_string(), Value::map_of([
                ("fields".to_string(), Value::list(vec![
                    Value::map_of([
                        ("name".to_string(), Value::str("diameter")),
                        ("title".to_string(), Value::str("Diameter")),
                        ("type".to_string(), Value::str("`$NUMBER`")),
                        ("req".to_string(), Value::Bool(true)),
                        ("format".to_string(), Value::str("float")),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("id")),
                        ("title".to_string(), Value::str("Id")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("kind")),
                        ("title".to_string(), Value::str("Kind")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("name")),
                        ("title".to_string(), Value::str("Name")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("planet_id")),
                        ("title".to_string(), Value::str("Planet Id")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                ])),
                ("id".to_string(), Value::map_of([
                    ("field".to_string(), Value::str("id")),
                    ("name".to_string(), Value::str("id")),
                ])),
                ("name".to_string(), Value::str("moon")),
                ("op".to_string(), Value::map_of([
                    ("create".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("create")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("POST")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/moon")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("planet_id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("moon")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{planet_id}"),
                                    Value::str("moon"),
                                ])),
                                ("rename".to_string(), Value::empty_map()),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("planet_id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("planet_id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                    ("list".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("list")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("GET")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/moon")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("planet_id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("moon")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{planet_id}"),
                                    Value::str("moon"),
                                ])),
                                ("rename".to_string(), Value::empty_map()),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("planet_id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("planet_id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                    ("load".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("load")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("GET")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/moon/{moon_id}")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("planet_id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("moon")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{planet_id}"),
                                    Value::str("moon"),
                                    Value::str("{id}"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("moon_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("moon_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                        Value::map_of([
                                            ("name".to_string(), Value::str("planet_id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                        Value::str("planet_id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                    ("remove".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("remove")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("DELETE")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/moon/{moon_id}")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("planet_id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("moon")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{planet_id}"),
                                    Value::str("moon"),
                                    Value::str("{id}"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("moon_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("moon_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                        Value::map_of([
                                            ("name".to_string(), Value::str("planet_id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                        Value::str("planet_id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                    ("update".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("update")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("PUT")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/moon/{moon_id}")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("planet_id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("moon")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{planet_id}"),
                                    Value::str("moon"),
                                    Value::str("{id}"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("moon_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("moon_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                        Value::map_of([
                                            ("name".to_string(), Value::str("planet_id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                        Value::str("planet_id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                ])),
                ("relations".to_string(), Value::map_of([
                    ("ancestors".to_string(), Value::list(vec![
                        Value::list(vec![
                            Value::str("$.main.kit.entity.planet"),
                        ]),
                    ])),
                ])),
            ])),
            ("planet".to_string(), Value::map_of([
                ("fields".to_string(), Value::list(vec![
                    Value::map_of([
                        ("name".to_string(), Value::str("diameter")),
                        ("title".to_string(), Value::str("Diameter")),
                        ("type".to_string(), Value::str("`$NUMBER`")),
                        ("req".to_string(), Value::Bool(true)),
                        ("format".to_string(), Value::str("float")),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("forbidReason")),
                        ("title".to_string(), Value::str("Forbid Reason")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("short".to_string(), Value::str("Why the planet is forbidden, carried from the forbid action's `why`.")),
                        ("readOnly".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("forbidState")),
                        ("title".to_string(), Value::str("Forbid State")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("short".to_string(), Value::str("Set by the forbid action, and absent until it first runs.")),
                        ("readOnly".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("id")),
                        ("title".to_string(), Value::str("Id")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("kind")),
                        ("title".to_string(), Value::str("Kind")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("name")),
                        ("title".to_string(), Value::str("Name")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("req".to_string(), Value::Bool(true)),
                    ]),
                    Value::map_of([
                        ("name".to_string(), Value::str("terraformState")),
                        ("title".to_string(), Value::str("Terraform State")),
                        ("type".to_string(), Value::str("`$STRING`")),
                        ("short".to_string(), Value::str("Set by the terraform action, and absent until it first runs.")),
                        ("readOnly".to_string(), Value::Bool(true)),
                    ]),
                ])),
                ("id".to_string(), Value::map_of([
                    ("field".to_string(), Value::str("id")),
                    ("name".to_string(), Value::str("id")),
                ])),
                ("name".to_string(), Value::str("planet")),
                ("op".to_string(), Value::map_of([
                    ("create".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("create")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("POST")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/forbid")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("forbid")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{id}"),
                                    Value::str("forbid"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("planet_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("$action".to_string(), Value::str("forbid")),
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                    ])),
                                ])),
                            ]),
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("POST")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}/terraform")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("terraform")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{id}"),
                                    Value::str("terraform"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("planet_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("$action".to_string(), Value::str("terraform")),
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                    ])),
                                ])),
                            ]),
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("POST")),
                                ("orig".to_string(), Value::str("/api/planet")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                ])),
                                ("rename".to_string(), Value::empty_map()),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::empty_map()),
                                ("select".to_string(), Value::empty_map()),
                            ]),
                        ])),
                    ])),
                    ("list".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("list")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("GET")),
                                ("orig".to_string(), Value::str("/api/planet")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                ])),
                                ("rename".to_string(), Value::empty_map()),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::empty_map()),
                                ("select".to_string(), Value::empty_map()),
                            ]),
                        ])),
                    ])),
                    ("load".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("load")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("GET")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{id}"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("planet_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                    ("remove".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("remove")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("DELETE")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{id}"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("planet_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                    ("update".to_string(), Value::map_of([
                        ("input".to_string(), Value::str("data")),
                        ("name".to_string(), Value::str("update")),
                        ("points".to_string(), Value::list(vec![
                            Value::map_of([
                                ("kind".to_string(), Value::str("http")),
                                ("method".to_string(), Value::str("PUT")),
                                ("orig".to_string(), Value::str("/api/planet/{planet_id}")),
                                ("segments".to_string(), Value::list(vec![
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("api")),
                                    ]),
                                    Value::map_of([
                                        ("lit".to_string(), Value::str("planet")),
                                    ]),
                                    Value::map_of([
                                        ("var".to_string(), Value::str("id")),
                                    ]),
                                ])),
                                ("parts".to_string(), Value::list(vec![
                                    Value::str("api"),
                                    Value::str("planet"),
                                    Value::str("{id}"),
                                ])),
                                ("rename".to_string(), Value::map_of([
                                    ("param".to_string(), Value::map_of([
                                        ("planet_id".to_string(), Value::str("id")),
                                    ])),
                                ])),
                                ("transform".to_string(), Value::map_of([
                                    ("req".to_string(), Value::str("`reqdata`")),
                                    ("res".to_string(), Value::str("`body`")),
                                ])),
                                ("args".to_string(), Value::map_of([
                                    ("params".to_string(), Value::list(vec![
                                        Value::map_of([
                                            ("name".to_string(), Value::str("id")),
                                            ("orig".to_string(), Value::str("planet_id")),
                                            ("type".to_string(), Value::str("`$STRING`")),
                                            ("kind".to_string(), Value::str("param")),
                                            ("reqd".to_string(), Value::Bool(true)),
                                        ]),
                                    ])),
                                ])),
                                ("select".to_string(), Value::map_of([
                                    ("exist".to_string(), Value::list(vec![
                                        Value::str("id"),
                                    ])),
                                ])),
                            ]),
                        ])),
                    ])),
                ])),
                ("relations".to_string(), Value::map_of([
                    ("ancestors".to_string(), Value::empty_list()),
                ])),
            ])),
        ])),
    ])
}

// SHARED CONFIG (sdkgen rung L2).
//
// The SDK reads the config on every request and never writes to it, so one
// instance is shared by every client rather than rebuilt per client. Above the
// size threshold make_config re-parses the whole embedded JSON, so this is the
// difference between parsing the model once and once per client.
//
// THREAD-LOCAL, not a global: Value is Rc/RefCell-backed and so is neither
// Send nor Sync. One config per thread is the widest scope that is sound here,
// and the clone is an Rc bump, not a deep copy.
thread_local! {
    static SHARED_CONFIG: Value = make_config();
}

/// The per-thread config, built once on first use.
///
/// The returned Value SHARES its nodes: treat it as read-only. Callers that
/// need to mutate should use make_config, which always returns a fresh copy.
pub fn shared_config() -> Value {
    SHARED_CONFIG.with(|c| c.clone())
}

pub fn make_feature(name: &str) -> FeatureRef {
    match name {
        "debug" => Rc::new(RefCell::new(crate::feature::debug::DebugFeature::new())),
        "idempotency" => Rc::new(RefCell::new(crate::feature::idempotency::IdempotencyFeature::new())),
        "metrics" => Rc::new(RefCell::new(crate::feature::metrics::MetricsFeature::new())),
        "paging" => Rc::new(RefCell::new(crate::feature::paging::PagingFeature::new())),
        "ratelimit" => Rc::new(RefCell::new(crate::feature::ratelimit::RatelimitFeature::new())),
        "retry" => Rc::new(RefCell::new(crate::feature::retry::RetryFeature::new())),
        "secrets" => Rc::new(RefCell::new(crate::feature::secrets::SecretsFeature::new())),
        "test" => Rc::new(RefCell::new(crate::feature::test::TestFeature::new())),
        "timeout" => Rc::new(RefCell::new(crate::feature::timeout::TimeoutFeature::new())),
        _ => Rc::new(RefCell::new(crate::feature::base::BaseFeature::new())),
    }
}
