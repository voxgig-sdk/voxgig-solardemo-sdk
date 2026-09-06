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
                            ["name"] = "diameter",
                            ["req"] = true,
                            ["type"] = "`$NUMBER`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "forbid",
                            ["type"] = "`$BOOLEAN`",
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
                            ["name"] = "ok",
                            ["type"] = "`$BOOLEAN`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "start",
                            ["type"] = "`$BOOLEAN`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "state",
                            ["type"] = "`$STRING`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "stop",
                            ["type"] = "`$BOOLEAN`",
                        },
                        new Dictionary<string, object?>
                        {
                            ["name"] = "why",
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
