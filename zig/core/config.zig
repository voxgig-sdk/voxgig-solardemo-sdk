// Generated API configuration (mirrors go/rust core/config).

const std = @import("std");
const h = @import("helpers.zig");
const types = @import("types.zig");
const Value = h.Value;
const Feature = types.Feature;

pub fn make_config() Value {
    return h.jo(&.{
        .{ "main", h.jo(&.{
            .{ "name", h.vstr("VoxgigSolardemo") },
            .{ "slug", h.vstr("voxgig-solardemo") },
            .{ "version", h.vstr("0.1.0") },
            .{ "target", h.vstr("zig") },
        }) },
        .{ "feature", h.jo(&.{
            .{ "debug", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "max", h.vnum(100) },
                    .{ "redact", h.ja(&.{
                        h.vstr("authorization"),
                        h.vstr("cookie"),
                        h.vstr("set-cookie"),
                        h.vstr("api-key"),
                        h.vstr("apikey"),
                        h.vstr("x-api-key"),
                        h.vstr("idempotency-key"),
                    }) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "now", h.vstr("`$FUNCTION`") },
                    .{ "onEntry", h.vstr("`$FUNCTION`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("none") },
            }) },
            .{ "idempotency", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "header", h.vstr("Idempotency-Key") },
                    .{ "methods", h.ja(&.{
                        h.vstr("POST"),
                        h.vstr("PUT"),
                        h.vstr("PATCH"),
                        h.vstr("DELETE"),
                    }) },
                    .{ "ops", h.ja(&.{
                        h.vstr("create"),
                        h.vstr("update"),
                        h.vstr("remove"),
                    }) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "keygen", h.vstr("`$FUNCTION`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("none") },
            }) },
            .{ "metrics", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "now", h.vstr("`$FUNCTION`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("none") },
            }) },
            .{ "paging", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "afterVar", h.vstr("after") },
                    .{ "cursorParam", h.vstr("cursor") },
                    .{ "firstVar", h.vstr("first") },
                    .{ "limitParam", h.vstr("limit") },
                    .{ "pageParam", h.vstr("page") },
                    .{ "startPage", h.vnum(1) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "limit", h.vstr("`$NUMBER`") },
                    .{ "ops", h.vstr("`$LIST`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("none") },
            }) },
            .{ "ratelimit", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "burst", h.vnum(5) },
                    .{ "rate", h.vnum(5) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "now", h.vstr("`$FUNCTION`") },
                    .{ "sleep", h.vstr("`$FUNCTION`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("wrap") },
            }) },
            .{ "retry", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "factor", h.vnum(2) },
                    .{ "maxDelay", h.vnum(2000) },
                    .{ "minDelay", h.vnum(50) },
                    .{ "retries", h.vnum(2) },
                    .{ "statuses", h.ja(&.{
                        h.vnum(408),
                        h.vnum(425),
                        h.vnum(429),
                        h.vnum(500),
                        h.vnum(502),
                        h.vnum(503),
                        h.vnum(504),
                    }) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "jitter", h.vstr("`$BOOLEAN`") },
                    .{ "sleep", h.vstr("`$FUNCTION`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("wrap") },
            }) },
            .{ "secrets", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "cache", h.vbool(true) },
                    .{ "exchange", h.jo(&.{
                        .{ "active", h.vbool(false) },
                        .{ "method", h.vstr("POST") },
                        .{ "path", h.vstr("auth/token") },
                        .{ "refresh", h.vstr("") },
                        .{ "request", h.vstr("refresh_token") },
                        .{ "response", h.vstr("access_token") },
                        .{ "retries", h.vnum(1) },
                        .{ "statuses", h.ja(&.{
                            h.vnum(401),
                        }) },
                    }) },
                    .{ "name", h.vstr("apikey") },
                    .{ "providers", h.olist() },
                }) },
                .{ "optspec", h.omap() },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("wrap") },
            }) },
            .{ "test", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "entity", h.vstr("`$MAP`") },
                    .{ "net", h.vstr("`$MAP`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("base") },
            }) },
            .{ "timeout", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                    .{ "ms", h.vnum(30000) },
                }) },
                .{ "optspec", h.jo(&.{
                    .{ "clearTimer", h.vstr("`$FUNCTION`") },
                    .{ "setTimer", h.vstr("`$FUNCTION`") },
                }) },
                .{ "strict", h.vbool(false) },
                .{ "transport", h.vstr("wrap") },
            }) },
        }) },
        .{ "options", h.jo(&.{
            .{ "base", h.vstr("http://localhost:8901") },
            .{ "headers", h.jo(&.{
                .{ "content-type", h.vstr("application/json") },
            }) },
            .{ "entity", h.jo(&.{
                .{ "moon", h.omap() },
                .{ "planet", h.omap() },
            }) },
        }) },
        .{ "entity", h.jo(&.{
            .{ "moon", h.jo(&.{
                .{ "fields", h.ja(&.{
                    h.jo(&.{
                        .{ "name", h.vstr("diameter") },
                        .{ "title", h.vstr("Diameter") },
                        .{ "type", h.vstr("`$NUMBER`") },
                        .{ "req", h.vbool(true) },
                        .{ "format", h.vstr("float") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("id") },
                        .{ "title", h.vstr("Id") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("kind") },
                        .{ "title", h.vstr("Kind") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("name") },
                        .{ "title", h.vstr("Name") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("planet_id") },
                        .{ "title", h.vstr("Planet Id") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                }) },
                .{ "id", h.jo(&.{
                    .{ "field", h.vstr("id") },
                    .{ "name", h.vstr("id") },
                }) },
                .{ "name", h.vstr("moon") },
                .{ "op", h.jo(&.{
                    .{ "create", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("create") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("planet_id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("moon") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                }) },
                                .{ "rename", h.omap() },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "list", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("list") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("planet_id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("moon") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                }) },
                                .{ "rename", h.omap() },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "load", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("load") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon/{moon_id}") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("planet_id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("moon") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                    h.vstr("{id}"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "moon_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("moon_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                        h.jo(&.{
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "remove", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("remove") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("DELETE") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon/{moon_id}") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("planet_id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("moon") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                    h.vstr("{id}"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "moon_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("moon_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                        h.jo(&.{
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "update", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("update") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("PUT") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon/{moon_id}") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("planet_id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("moon") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                    h.vstr("{id}"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "moon_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("moon_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                        h.jo(&.{
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                }) },
                .{ "relations", h.jo(&.{
                    .{ "ancestors", h.ja(&.{
                        h.ja(&.{
                            h.vstr("$.main.kit.entity.planet"),
                        }),
                    }) },
                }) },
            }) },
            .{ "planet", h.jo(&.{
                .{ "fields", h.ja(&.{
                    h.jo(&.{
                        .{ "name", h.vstr("diameter") },
                        .{ "title", h.vstr("Diameter") },
                        .{ "type", h.vstr("`$NUMBER`") },
                        .{ "req", h.vbool(true) },
                        .{ "format", h.vstr("float") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("forbidReason") },
                        .{ "title", h.vstr("Forbid Reason") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "short", h.vstr("Why the planet is forbidden, carried from the forbid action's `why`.") },
                        .{ "readOnly", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("forbidState") },
                        .{ "title", h.vstr("Forbid State") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "short", h.vstr("Set by the forbid action, and absent until it first runs.") },
                        .{ "readOnly", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("id") },
                        .{ "title", h.vstr("Id") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("kind") },
                        .{ "title", h.vstr("Kind") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("name") },
                        .{ "title", h.vstr("Name") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "req", h.vbool(true) },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("terraformState") },
                        .{ "title", h.vstr("Terraform State") },
                        .{ "type", h.vstr("`$STRING`") },
                        .{ "short", h.vstr("Set by the terraform action, and absent until it first runs.") },
                        .{ "readOnly", h.vbool(true) },
                    }),
                }) },
                .{ "id", h.jo(&.{
                    .{ "field", h.vstr("id") },
                    .{ "name", h.vstr("id") },
                }) },
                .{ "name", h.vstr("planet") },
                .{ "op", h.jo(&.{
                    .{ "create", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("create") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/forbid") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("forbid") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{id}"),
                                    h.vstr("forbid"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "planet_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "$action", h.vstr("forbid") },
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                            }),
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/terraform") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("terraform") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{id}"),
                                    h.vstr("terraform"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "planet_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "$action", h.vstr("terraform") },
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                            }),
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                }) },
                                .{ "rename", h.omap() },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.omap() },
                                .{ "select", h.omap() },
                            }),
                        }) },
                    }) },
                    .{ "list", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("list") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                }) },
                                .{ "rename", h.omap() },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.omap() },
                                .{ "select", h.omap() },
                            }),
                        }) },
                    }) },
                    .{ "load", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("load") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{id}"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "planet_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "remove", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("remove") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("DELETE") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{id}"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "planet_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "update", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("update") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("PUT") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}") },
                                .{ "segments", h.ja(&.{
                                    h.jo(&.{
                                        .{ "lit", h.vstr("api") },
                                    }),
                                    h.jo(&.{
                                        .{ "lit", h.vstr("planet") },
                                    }),
                                    h.jo(&.{
                                        .{ "var", h.vstr("id") },
                                    }),
                                }) },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{id}"),
                                }) },
                                .{ "rename", h.jo(&.{
                                    .{ "param", h.jo(&.{
                                        .{ "planet_id", h.vstr("id") },
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "type", h.vstr("`$STRING`") },
                                            .{ "kind", h.vstr("param") },
                                            .{ "reqd", h.vbool(true) },
                                        }),
                                    }) },
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                            }),
                        }) },
                    }) },
                }) },
                .{ "relations", h.jo(&.{
                    .{ "ancestors", h.olist() },
                }) },
            }) },
        }) },
    });
}

// SHARED CONFIG (sdkgen rung L2).
//
// The SDK reads the config on every request and never writes to it, so one
// instance is shared by every client rather than rebuilt per client. Above the
// size threshold make_config re-parses the whole embedded JSON, so this is the
// difference between parsing the model once and once per client.
//
// Value nodes are arena-allocated and reference-stable, so the shared value is
// genuinely one structure, not a copy.
var shared_config_val: ?Value = null;

/// The process-wide config, built once on first use.
///
/// The returned Value SHARES its nodes: treat it as read-only. Callers that
/// need to mutate should use make_config, which always returns a fresh copy.
pub fn shared_config() Value {
    if (shared_config_val) |c| return c;
    const c = make_config();
    shared_config_val = c;
    return c;
}

pub fn make_feature(name: []const u8) Feature {
    if (std.mem.eql(u8, name, "audit")) return @import("../feature/audit.zig").AuditFeature.make();
    if (std.mem.eql(u8, name, "cache")) return @import("../feature/cache.zig").CacheFeature.make();
    if (std.mem.eql(u8, name, "clienttrack")) return @import("../feature/clienttrack.zig").ClienttrackFeature.make();
    if (std.mem.eql(u8, name, "cost")) return @import("../feature/cost.zig").CostFeature.make();
    if (std.mem.eql(u8, name, "debug")) return @import("../feature/debug.zig").DebugFeature.make();
    if (std.mem.eql(u8, name, "idempotency")) return @import("../feature/idempotency.zig").IdempotencyFeature.make();
    if (std.mem.eql(u8, name, "log")) return @import("../feature/log.zig").LogFeature.make();
    if (std.mem.eql(u8, name, "metrics")) return @import("../feature/metrics.zig").MetricsFeature.make();
    if (std.mem.eql(u8, name, "netsim")) return @import("../feature/netsim.zig").NetsimFeature.make();
    if (std.mem.eql(u8, name, "paging")) return @import("../feature/paging.zig").PagingFeature.make();
    if (std.mem.eql(u8, name, "proxy")) return @import("../feature/proxy.zig").ProxyFeature.make();
    if (std.mem.eql(u8, name, "ratelimit")) return @import("../feature/ratelimit.zig").RatelimitFeature.make();
    if (std.mem.eql(u8, name, "rbac")) return @import("../feature/rbac.zig").RbacFeature.make();
    if (std.mem.eql(u8, name, "retry")) return @import("../feature/retry.zig").RetryFeature.make();
    if (std.mem.eql(u8, name, "streaming")) return @import("../feature/streaming.zig").StreamingFeature.make();
    if (std.mem.eql(u8, name, "telemetry")) return @import("../feature/telemetry.zig").TelemetryFeature.make();
    if (std.mem.eql(u8, name, "test")) return @import("../feature/test.zig").TestFeature.make();
    if (std.mem.eql(u8, name, "timeout")) return @import("../feature/timeout.zig").TimeoutFeature.make();
    if (std.mem.eql(u8, name, "secrets")) return @import("../feature/secrets.zig").SecretsFeature.make();
    return @import("../feature/base.zig").BaseFeature.make();
}
