// Generated API configuration (mirrors go/rust core/config).

const std = @import("std");
const h = @import("helpers.zig");
const types = @import("types.zig");
const Value = h.Value;
const Feature = types.Feature;

pub fn make_config() Value {
    return h.jo(&.{
        .{ "main", h.jo(&.{
            .{ "name", h.vstr("Solardemo") },
            .{ "slug", h.vstr("solardemo") },
            .{ "version", h.vstr("0.1.0") },
            .{ "target", h.vstr("zig") },
        }) },
        .{ "feature", h.jo(&.{
            .{ "test", h.jo(&.{
                .{ "options", h.jo(&.{
                    .{ "active", h.vbool(false) },
                }) },
                .{ "transport", h.vstr("base") },
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
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$NUMBER`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("id") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("kind") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("name") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("planet_id") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                }) },
                .{ "name", h.vstr("moon") },
                .{ "op", h.jo(&.{
                    .{ "create", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("create") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon") },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "list", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("list") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon") },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                    h.vstr("{planet_id}"),
                                    h.vstr("moon"),
                                }) },
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "load", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("load") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("moon_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon/{moon_id}") },
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
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "remove", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("remove") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("moon_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("DELETE") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon/{moon_id}") },
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
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "update", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("update") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("moon_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("planet_id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("PUT") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/moon/{moon_id}") },
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
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                        h.vstr("planet_id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                }) },
                .{ "relations", h.jo(&.{
                    .{ "ancestors", h.ja(&.{
                        h.ja(&.{
                            h.vstr("planet"),
                        }),
                    }) },
                }) },
            }) },
            .{ "planet", h.jo(&.{
                .{ "fields", h.ja(&.{
                    h.jo(&.{
                        .{ "name", h.vstr("diameter") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$NUMBER`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("forbid") },
                        .{ "type", h.vstr("`$BOOLEAN`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("id") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("kind") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("name") },
                        .{ "req", h.vbool(true) },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("ok") },
                        .{ "type", h.vstr("`$BOOLEAN`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("start") },
                        .{ "type", h.vstr("`$BOOLEAN`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("state") },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("stop") },
                        .{ "type", h.vstr("`$BOOLEAN`") },
                    }),
                    h.jo(&.{
                        .{ "name", h.vstr("why") },
                        .{ "type", h.vstr("`$STRING`") },
                    }),
                }) },
                .{ "name", h.vstr("planet") },
                .{ "op", h.jo(&.{
                    .{ "create", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("create") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/forbid") },
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
                                .{ "select", h.jo(&.{
                                    .{ "$action", h.vstr("forbid") },
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}/terraform") },
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
                                .{ "select", h.jo(&.{
                                    .{ "$action", h.vstr("terraform") },
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                            h.jo(&.{
                                .{ "args", h.omap() },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("POST") },
                                .{ "orig", h.vstr("/api/planet") },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                }) },
                                .{ "select", h.omap() },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "list", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("list") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.omap() },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet") },
                                .{ "parts", h.ja(&.{
                                    h.vstr("api"),
                                    h.vstr("planet"),
                                }) },
                                .{ "select", h.omap() },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "load", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("load") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("GET") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}") },
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
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "remove", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("remove") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("DELETE") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}") },
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
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
                                }) },
                            }),
                        }) },
                    }) },
                    .{ "update", h.jo(&.{
                        .{ "input", h.vstr("data") },
                        .{ "name", h.vstr("update") },
                        .{ "points", h.ja(&.{
                            h.jo(&.{
                                .{ "args", h.jo(&.{
                                    .{ "params", h.ja(&.{
                                        h.jo(&.{
                                            .{ "kind", h.vstr("param") },
                                            .{ "name", h.vstr("id") },
                                            .{ "orig", h.vstr("planet_id") },
                                            .{ "reqd", h.vbool(true) },
                                            .{ "type", h.vstr("`$STRING`") },
                                        }),
                                    }) },
                                }) },
                                .{ "kind", h.vstr("http") },
                                .{ "method", h.vstr("PUT") },
                                .{ "orig", h.vstr("/api/planet/{planet_id}") },
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
                                .{ "select", h.jo(&.{
                                    .{ "exist", h.ja(&.{
                                        h.vstr("id"),
                                    }) },
                                }) },
                                .{ "transform", h.jo(&.{
                                    .{ "req", h.vstr("`reqdata`") },
                                    .{ "res", h.vstr("`body`") },
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
    return @import("../feature/base.zig").BaseFeature.make();
}
