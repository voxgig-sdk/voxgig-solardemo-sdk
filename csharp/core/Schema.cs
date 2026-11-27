// VoxgigSolardemo SDK - generated schemas. GENERATED from the API model -
// do not edit by hand.
//
// Built from the model: `main.kit.optspec` and each feature's
// `config.options` for Optspec; entity `fields{}.type` for Entityspec.

namespace VoxgigSolardemoSdk;

public static class SdkSchema
{
    // Built ONCE, on first use. The spec is read on every client construction
    // and never mutated, so rebuilding it per call would be pure waste — and
    // a shared dictionary is safe for the same reason the spec is a constant:
    // MakeOptions validates AGAINST it and writes into the options, never
    // into the spec.
    //
    // A static field initializer, so the CLR's type initializer gives the
    // once-only, thread-safe guarantee with no locking on the read path.

    /// <summary>The option spec MakeOptions validates client options against.</summary>
    public static readonly Dictionary<string, object?> Optspec =
        new Dictionary<string, object?>
        {
            ["allow"] = new Dictionary<string, object?>
            {
                ["method"] = "GET,PUT,POST,PATCH,DELETE,OPTIONS",
                ["op"] = "create,update,patch,load,list,remove,command,direct,graphql",
            },
            ["apikey"] = "",
            ["auth"] = new Dictionary<string, object?>
            {
                ["basic"] = false,
                ["in"] = "",
                ["name"] = "",
                ["prefix"] = "",
            },
            ["base"] = "http://localhost:8000",
            ["clean"] = new Dictionary<string, object?>
            {
                ["active"] = true,
                ["hint"] = "0",
                ["keys"] = "key,secret,token,password,passwd,authorization,cookie,credential,signature",
                ["mask"] = "[redacted]",
                ["min"] = "4",
                ["values"] = "",
            },
            ["entity"] = new Dictionary<string, object?>
            {
                ["`$CHILD`"] = new Dictionary<string, object?>
                {
                    ["`$OPEN`"] = true,
                    ["active"] = false,
                    ["alias"] = new Dictionary<string, object?>(),
                },
            },
            ["extend"] = "`$ANY`",
            ["headers"] = new Dictionary<string, object?>
            {
                ["`$CHILD`"] = "`$STRING`",
            },
            ["prefix"] = "",
            ["secret"] = "",
            ["server"] = new Dictionary<string, object?>
            {
                ["`$CHILD`"] = "",
            },
            ["suffix"] = "",
            ["system"] = new Dictionary<string, object?>
            {
                ["fetch"] = "`$ANY`",
            },
            ["test"] = new Dictionary<string, object?>
            {
                ["active"] = false,
                ["entity"] = new Dictionary<string, object?>
                {
                    ["`$OPEN`"] = true,
                },
            },
            ["utility"] = new Dictionary<string, object?>(),
            ["feature"] = new Dictionary<string, object?>
            {
                ["`$CHILD`"] = new Dictionary<string, object?>
                {
                    ["`$OPEN`"] = true,
                    ["active"] = false,
                },
                ["debug"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["max"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["redact"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$LIST`",
                            "`$NIL`",
                        },
                        ["now"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                        ["onEntry"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["idempotency"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["header"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["methods"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$LIST`",
                            "`$NIL`",
                        },
                        ["ops"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$LIST`",
                            "`$NIL`",
                        },
                        ["keygen"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["metrics"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["now"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["paging"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["afterVar"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["cursorParam"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["firstVar"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["limitParam"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["pageParam"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["startPage"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["limit"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["ops"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$LIST`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["ratelimit"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["burst"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["rate"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["now"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                        ["sleep"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["retry"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["factor"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["maxDelay"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["minDelay"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["retries"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["statuses"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$LIST`",
                            "`$NIL`",
                        },
                        ["jitter"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["sleep"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["secrets"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["cache"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["exchange"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$MAP`",
                            "`$NIL`",
                        },
                        ["name"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$STRING`",
                            new List<object?>
                            {
                                "`$EXACT`",
                                "",
                            },
                            "`$NIL`",
                        },
                        ["providers"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$LIST`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["test"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["entity"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$MAP`",
                            "`$NIL`",
                        },
                        ["net"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$MAP`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
                ["timeout"] = new List<object?>
                {
                    "`$NOF`",
                    new Dictionary<string, object?>
                    {
                        ["min"] = 1,
                    },
                    new Dictionary<string, object?>
                    {
                        ["`$OPEN`"] = true,
                        ["active"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$BOOLEAN`",
                            "`$NIL`",
                        },
                        ["ms"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$NUMBER`",
                            "`$NIL`",
                        },
                        ["clearTimer"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                        ["now"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                        ["setTimer"] = new List<object?>
                        {
                            "`$NOF`",
                            new Dictionary<string, object?>
                            {
                                ["min"] = 1,
                            },
                            "`$FUNCTION`",
                            "`$NIL`",
                        },
                    },
                    "`$NIL`",
                },
            },
        };

    /// <summary>Per-entity data and request specs, keyed by entity name.</summary>
    public static readonly Dictionary<string, object?> Entityspec =
        new Dictionary<string, object?>();
}
