// VoxgigSolardemo SDK - generated model configuration and feature
// factory. GENERATED from the API model - do not edit by hand.

namespace VoxgigSolardemoSdk;

public static class SdkConfig
{
    public static Dictionary<string, object?> MakeConfig()
    {
        return new Dictionary<string, object?>
        {
            ["main"] = new Dictionary<string, object?>
            {
                ["name"] = "VoxgigSolardemo",
                ["slug"] = "voxgig-solardemo",
                ["version"] = "0.1.0",
                ["target"] = "csharp",
            },
            ["feature"] = new Dictionary<string, object?>
            {
                ["debug"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["max"] = 100,
                        ["redact"] = new List<object?>
                        {
                            "authorization",
                            "cookie",
                            "set-cookie",
                            "api-key",
                            "apikey",
                            "x-api-key",
                            "idempotency-key",
                        },
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["now"] = "`$FUNCTION`",
                        ["onEntry"] = "`$FUNCTION`",
                    },
                    ["strict"] = false,
                    ["transport"] = "none",
                },
                ["idempotency"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["header"] = "Idempotency-Key",
                        ["methods"] = new List<object?>
                        {
                            "POST",
                            "PUT",
                            "PATCH",
                            "DELETE",
                        },
                        ["ops"] = new List<object?>
                        {
                            "create",
                            "update",
                            "remove",
                        },
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["keygen"] = "`$FUNCTION`",
                    },
                    ["strict"] = false,
                    ["transport"] = "none",
                },
                ["metrics"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["now"] = "`$FUNCTION`",
                    },
                    ["strict"] = false,
                    ["transport"] = "none",
                },
                ["paging"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["afterVar"] = "after",
                        ["cursorParam"] = "cursor",
                        ["firstVar"] = "first",
                        ["limitParam"] = "limit",
                        ["pageParam"] = "page",
                        ["startPage"] = 1,
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["limit"] = "`$NUMBER`",
                        ["ops"] = "`$LIST`",
                    },
                    ["strict"] = false,
                    ["transport"] = "none",
                },
                ["ratelimit"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["burst"] = 5,
                        ["rate"] = 5,
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["now"] = "`$FUNCTION`",
                        ["sleep"] = "`$FUNCTION`",
                    },
                    ["strict"] = false,
                    ["transport"] = "wrap",
                },
                ["retry"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["factor"] = 2,
                        ["maxDelay"] = 2000,
                        ["minDelay"] = 50,
                        ["retries"] = 2,
                        ["statuses"] = new List<object?>
                        {
                            408,
                            425,
                            429,
                            500,
                            502,
                            503,
                            504,
                        },
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["jitter"] = "`$BOOLEAN`",
                        ["sleep"] = "`$FUNCTION`",
                    },
                    ["strict"] = false,
                    ["transport"] = "wrap",
                },
                ["secrets"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["cache"] = true,
                        ["exchange"] = new Dictionary<string, object?>
                        {
                            ["active"] = false,
                            ["method"] = "POST",
                            ["path"] = "auth/token",
                            ["refresh"] = "",
                            ["request"] = "refresh_token",
                            ["response"] = "access_token",
                            ["retries"] = 1,
                            ["statuses"] = new List<object?>
                            {
                                401,
                            },
                        },
                        ["name"] = "apikey",
                        ["providers"] = new List<object?>(),
                    },
                    ["optspec"] = new Dictionary<string, object?>(),
                    ["strict"] = false,
                    ["transport"] = "wrap",
                },
                ["test"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["entity"] = "`$MAP`",
                        ["net"] = "`$MAP`",
                    },
                    ["strict"] = false,
                    ["transport"] = "base",
                },
                ["timeout"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                        ["ms"] = 30000,
                    },
                    ["optspec"] = new Dictionary<string, object?>
                    {
                        ["clearTimer"] = "`$FUNCTION`",
                        ["setTimer"] = "`$FUNCTION`",
                    },
                    ["strict"] = false,
                    ["transport"] = "wrap",
                },
            },
            ["options"] = new Dictionary<string, object?>
            {
                ["base"] = "http://localhost:8901",
                ["headers"] = new Dictionary<string, object?>
                {
                    ["content-type"] = "application/json",
                },
                ["entity"] = new Dictionary<string, object?>
                {
                    ["moon"] = new Dictionary<string, object?>(),
                    ["planet"] = new Dictionary<string, object?>(),
                },
            },
            ["entity"] = new Dictionary<string, object?>
            {
                ["moon"] = new Dictionary<string, object?>
                {
                    ["fields"] = new List<object?>
                    {
                        new Dictionary<string, object?>
                        {
                            ["name"] = "diameter",
                            ["title"] = "Diameter",
                            ["type"] = "`$NUMBER`",
                            ["req"] = true,
                            ["format"] = "float",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "id",
                            ["title"] = "Id",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "kind",
                            ["title"] = "Kind",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "name",
                            ["title"] = "Name",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "planet_id",
                            ["title"] = "Planet Id",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                    },
                    ["id"] = new Dictionary<string, object?>
                    {
                        ["field"] = "id",
                        ["name"] = "id",
                    },
                    ["name"] = "moon",
                    ["op"] = new Dictionary<string, object?>
                    {
                        ["create"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "create",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "POST",
                                    ["orig"] = "/api/planet/{planet_id}/moon",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "planet_id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "moon",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                    },
                                    ["rename"] = new Dictionary<string, object?>(),
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "planet_id",
                                        },
                                    },
                                },
                            },
                        },
                        ["list"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "list",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "GET",
                                    ["orig"] = "/api/planet/{planet_id}/moon",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "planet_id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "moon",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                    },
                                    ["rename"] = new Dictionary<string, object?>(),
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "planet_id",
                                        },
                                    },
                                },
                            },
                        },
                        ["load"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "load",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "GET",
                                    ["orig"] = "/api/planet/{planet_id}/moon/{moon_id}",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "planet_id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "moon",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                        "{id}",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["moon_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "moon_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                            "planet_id",
                                        },
                                    },
                                },
                            },
                        },
                        ["remove"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "remove",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "DELETE",
                                    ["orig"] = "/api/planet/{planet_id}/moon/{moon_id}",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "planet_id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "moon",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                        "{id}",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["moon_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "moon_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                            "planet_id",
                                        },
                                    },
                                },
                            },
                        },
                        ["update"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "update",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "PUT",
                                    ["orig"] = "/api/planet/{planet_id}/moon/{moon_id}",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "planet_id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "moon",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                        "{id}",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["moon_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "moon_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                            "planet_id",
                                        },
                                    },
                                },
                            },
                        },
                    },
                    ["relations"] = new Dictionary<string, object?>
                    {
                        ["ancestors"] = new List<object?>
                        {
                            new List<object?>
                            {
                                "$.main.kit.entity.planet",
                            },
                        },
                    },
                },
                ["planet"] = new Dictionary<string, object?>
                {
                    ["fields"] = new List<object?>
                    {
                        new Dictionary<string, object?>
                        {
                            ["name"] = "diameter",
                            ["title"] = "Diameter",
                            ["type"] = "`$NUMBER`",
                            ["req"] = true,
                            ["format"] = "float",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "forbidReason",
                            ["title"] = "Forbid Reason",
                            ["type"] = "`$STRING`",
                            ["short"] = "Why the planet is forbidden, carried from the forbid action's `why`.",
                            ["readOnly"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "forbidState",
                            ["title"] = "Forbid State",
                            ["type"] = "`$STRING`",
                            ["short"] = "Set by the forbid action, and absent until it first runs.",
                            ["readOnly"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "id",
                            ["title"] = "Id",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "kind",
                            ["title"] = "Kind",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "name",
                            ["title"] = "Name",
                            ["type"] = "`$STRING`",
                            ["req"] = true,
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "terraformState",
                            ["title"] = "Terraform State",
                            ["type"] = "`$STRING`",
                            ["short"] = "Set by the terraform action, and absent until it first runs.",
                            ["readOnly"] = true,
                        },
                    },
                    ["id"] = new Dictionary<string, object?>
                    {
                        ["field"] = "id",
                        ["name"] = "id",
                    },
                    ["name"] = "planet",
                    ["op"] = new Dictionary<string, object?>
                    {
                        ["create"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "create",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "POST",
                                    ["orig"] = "/api/planet/{planet_id}/forbid",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "forbid",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                        "forbid",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["$action"] = "forbid",
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                },
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "POST",
                                    ["orig"] = "/api/planet/{planet_id}/terraform",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "terraform",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                        "terraform",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["$action"] = "terraform",
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                },
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "POST",
                                    ["orig"] = "/api/planet",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                    },
                                    ["rename"] = new Dictionary<string, object?>(),
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>(),
                                    ["select"] = new Dictionary<string, object?>(),
                                },
                            },
                        },
                        ["list"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "list",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "GET",
                                    ["orig"] = "/api/planet",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                    },
                                    ["rename"] = new Dictionary<string, object?>(),
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>(),
                                    ["select"] = new Dictionary<string, object?>(),
                                },
                            },
                        },
                        ["load"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "load",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "GET",
                                    ["orig"] = "/api/planet/{planet_id}",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                },
                            },
                        },
                        ["remove"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "remove",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "DELETE",
                                    ["orig"] = "/api/planet/{planet_id}",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                },
                            },
                        },
                        ["update"] = new Dictionary<string, object?>
                        {
                            ["input"] = "data",
                            ["name"] = "update",
                            ["points"] = new List<object?>
                            {
                                new Dictionary<string, object?>
                                {
                                    ["kind"] = "http",
                                    ["method"] = "PUT",
                                    ["orig"] = "/api/planet/{planet_id}",
                                    ["segments"] = new List<object?>
                                    {
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "api",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["lit"] = "planet",
                                        },
                                        new Dictionary<string, object?>
                                        {
                                            ["var"] = "id",
                                        },
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                    },
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["type"] = "`$STRING`",
                                                ["kind"] = "param",
                                                ["reqd"] = true,
                                            },
                                        },
                                    },
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                },
                            },
                        },
                    },
                    ["relations"] = new Dictionary<string, object?>
                    {
                        ["ancestors"] = new List<object?>(),
                    },
                },
            },
        };
    }

    private static readonly Lazy<Dictionary<string, object?>> SharedConfigVal =
        new(MakeConfig);

    // The process-wide config, built once on first use.
    //
    // The returned dictionary is SHARED: treat it as read-only. Callers that
    // need to mutate should use MakeConfig, which always returns a fresh copy.
    public static Dictionary<string, object?> SharedConfig()
    {
        return SharedConfigVal.Value;
    }

    public static List<object?> FeaturePlugins(string name)
    {
        switch (name)
        {
            default:
                return new List<object?>();
        }
    }

    public static Feature.BaseFeature MakeFeature(string name)
    {
        switch (name)
        {
            case "debug":
                return new Feature.DebugFeature();
            case "idempotency":
                return new Feature.IdempotencyFeature();
            case "metrics":
                return new Feature.MetricsFeature();
            case "paging":
                return new Feature.PagingFeature();
            case "ratelimit":
                return new Feature.RatelimitFeature();
            case "retry":
                return new Feature.RetryFeature();
            case "secrets":
                return new Feature.SecretsFeature();
            case "test":
                return new Feature.TestFeature();
            case "timeout":
                return new Feature.TimeoutFeature();
            default:
                return new Feature.BaseFeature();
        }
    }
}
