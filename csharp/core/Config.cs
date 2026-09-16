// Solardemo SDK - generated model configuration and feature
// factory. GENERATED from the API model - do not edit by hand.

namespace SolardemoSdk;

public static class SdkConfig
{
    public static Dictionary<string, object?> MakeConfig()
    {
        return new Dictionary<string, object?>
        {
            ["main"] = new Dictionary<string, object?>
            {
                ["name"] = "Solardemo",
                ["slug"] = "solardemo",
                ["version"] = "0.1.0",
                ["target"] = "csharp",
            },
            ["feature"] = new Dictionary<string, object?>
            {
                ["test"] = new Dictionary<string, object?>
                {
                    ["options"] = new Dictionary<string, object?>
                    {
                        ["active"] = false,
                    },
                    ["transport"] = "base",
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
                            ["format"] = "float",
                            ["name"] = "diameter",
                            ["req"] = true,
                            ["type"] = "`$NUMBER`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "id",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "kind",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "name",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "planet_id",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "POST /api/planet/{planet_id}/moon",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "planet_id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "GET /api/planet/{planet_id}/moon",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "planet_id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "moon_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "GET /api/planet/{planet_id}/moon/{moon_id}",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "GET",
                                    ["orig"] = "/api/planet/{planet_id}/moon/{moon_id}",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["moon_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                            "planet_id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                        "{id}",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "moon_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "DELETE /api/planet/{planet_id}/moon/{moon_id}",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "DELETE",
                                    ["orig"] = "/api/planet/{planet_id}/moon/{moon_id}",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["moon_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                            "planet_id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                        "{id}",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "moon_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "planet_id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "PUT /api/planet/{planet_id}/moon/{moon_id}",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "PUT",
                                    ["orig"] = "/api/planet/{planet_id}/moon/{moon_id}",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["moon_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                            "planet_id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{planet_id}",
                                        "moon",
                                        "{id}",
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
                                "planet",
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
                            ["format"] = "float",
                            ["name"] = "diameter",
                            ["req"] = true,
                            ["type"] = "`$NUMBER`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "forbidReason",
                            ["readOnly"] = true,
                            ["short"] = "Why the planet is forbidden, carried from the forbid action's `why`.",
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "forbidState",
                            ["readOnly"] = true,
                            ["short"] = "Set by the forbid action, and absent until it first runs.",
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "id",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "kind",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "name",
                            ["req"] = true,
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "terraformState",
                            ["readOnly"] = true,
                            ["short"] = "Set by the terraform action, and absent until it first runs.",
                            ["type"] = "`$STRING`",
                        },
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "POST /api/planet/{planet_id}/forbid",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"forbid\":{\"type\":\"boolean\"},\"why\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "POST",
                                    ["orig"] = "/api/planet/{planet_id}/forbid",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["$action"] = "forbid",
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                        "forbid",
                                    },
                                },
                                new Dictionary<string, object?>
                                {
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "POST /api/planet/{planet_id}/terraform",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"start\":{\"type\":\"boolean\"},\"stop\":{\"type\":\"boolean\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "POST",
                                    ["orig"] = "/api/planet/{planet_id}/terraform",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["$action"] = "terraform",
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
                                        "terraform",
                                    },
                                },
                                new Dictionary<string, object?>
                                {
                                    ["args"] = new Dictionary<string, object?>(),
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "POST /api/planet",
                                        ["json"] = "{\"parameters\":[],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
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
                                    ["select"] = new Dictionary<string, object?>(),
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
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
                                    ["args"] = new Dictionary<string, object?>(),
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "GET /api/planet",
                                        ["json"] = "{\"parameters\":[],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
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
                                    ["select"] = new Dictionary<string, object?>(),
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "GET /api/planet/{planet_id}",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "GET",
                                    ["orig"] = "/api/planet/{planet_id}",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "DELETE /api/planet/{planet_id}",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "DELETE",
                                    ["orig"] = "/api/planet/{planet_id}",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
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
                                    ["args"] = new Dictionary<string, object?>
                                    {
                                        ["params"] = new List<object?>
                                        {
                                            new Dictionary<string, object?>
                                            {
                                                ["kind"] = "param",
                                                ["name"] = "id",
                                                ["orig"] = "planet_id",
                                                ["reqd"] = true,
                                                ["type"] = "`$STRING`",
                                            },
                                        },
                                    },
                                    ["contract"] = new Dictionary<string, object?>
                                    {
                                        ["id"] = "PUT /api/planet/{planet_id}",
                                        ["json"] = "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                                        ["source"] = "openapi3",
                                        ["version"] = 1,
                                    },
                                    ["kind"] = "http",
                                    ["method"] = "PUT",
                                    ["orig"] = "/api/planet/{planet_id}",
                                    ["rename"] = new Dictionary<string, object?>
                                    {
                                        ["param"] = new Dictionary<string, object?>
                                        {
                                            ["planet_id"] = "id",
                                        },
                                    },
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
                                    ["select"] = new Dictionary<string, object?>
                                    {
                                        ["exist"] = new List<object?>
                                        {
                                            "id",
                                        },
                                    },
                                    ["transform"] = new Dictionary<string, object?>
                                    {
                                        ["req"] = "`reqdata`",
                                        ["res"] = "`body`",
                                    },
                                    ["parts"] = new List<object?>
                                    {
                                        "api",
                                        "planet",
                                        "{id}",
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

    public static Feature.BaseFeature MakeFeature(string name)
    {
        switch (name)
        {
            case "test":
                return new Feature.TestFeature();
            default:
                return new Feature.BaseFeature();
        }
    }
}
