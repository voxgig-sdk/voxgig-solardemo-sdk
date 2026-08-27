-- Solardemo SDK configuration

-- Build a fresh, fully materialised config table. Every call rebuilds the
-- whole structure, so prefer require("config_shared") unless you need a
-- private copy you intend to mutate.
local function make_config()
  return {
    main = {
      name = "Solardemo",
      slug = "solardemo",
      version = "0.1.0",
      target = "lua",
    },
    feature = {
      ["test"] = {
        ["options"] = {
          ["active"] = false,
        },
        ["transport"] = "base",
      },
    },
    options = {
      base = "http://localhost:8901",
      headers = {
        ["content-type"] = "application/json",
      },
      entity = {
        ["moon"] = {},
        ["planet"] = {},
      },
    },
    entity = {
      ["moon"] = {
        ["fields"] = {
          {
            ["name"] = "diameter",
            ["req"] = true,
            ["type"] = "`$NUMBER`",
          },
          {
            ["name"] = "id",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "kind",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "name",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "planet_id",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "moon",
        ["op"] = {
          ["create"] = {
            ["input"] = "data",
            ["name"] = "create",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                },
                ["select"] = {
                  ["exist"] = {
                    "planet_id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["list"] = {
            ["input"] = "data",
            ["name"] = "list",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                },
                ["select"] = {
                  ["exist"] = {
                    "planet_id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "moon_id",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["moon_id"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                    "planet_id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["remove"] = {
            ["input"] = "data",
            ["name"] = "remove",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "moon_id",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["moon_id"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                    "planet_id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["update"] = {
            ["input"] = "data",
            ["name"] = "update",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
                    {
                      ["kind"] = "param",
                      ["name"] = "id",
                      ["orig"] = "moon_id",
                      ["reqd"] = true,
                      ["type"] = "`$STRING`",
                    },
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["moon_id"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                    "planet_id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {
            {
              "planet",
            },
          },
        },
      },
      ["planet"] = {
        ["fields"] = {
          {
            ["name"] = "diameter",
            ["req"] = true,
            ["type"] = "`$NUMBER`",
          },
          {
            ["name"] = "forbid",
            ["type"] = "`$BOOLEAN`",
          },
          {
            ["name"] = "id",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "kind",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "name",
            ["req"] = true,
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "ok",
            ["type"] = "`$BOOLEAN`",
          },
          {
            ["name"] = "start",
            ["type"] = "`$BOOLEAN`",
          },
          {
            ["name"] = "state",
            ["type"] = "`$STRING`",
          },
          {
            ["name"] = "stop",
            ["type"] = "`$BOOLEAN`",
          },
          {
            ["name"] = "why",
            ["type"] = "`$STRING`",
          },
        },
        ["name"] = "planet",
        ["op"] = {
          ["create"] = {
            ["input"] = "data",
            ["name"] = "create",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{id}",
                  "forbid",
                },
                ["rename"] = {
                  ["param"] = {
                    ["planet_id"] = "id",
                  },
                },
                ["select"] = {
                  ["$action"] = "forbid",
                  ["exist"] = {
                    "id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{id}",
                  "terraform",
                },
                ["rename"] = {
                  ["param"] = {
                    ["planet_id"] = "id",
                  },
                },
                ["select"] = {
                  ["$action"] = "terraform",
                  ["exist"] = {
                    "id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
              {
                ["args"] = {},
                ["kind"] = "http",
                ["method"] = "POST",
                ["orig"] = "/api/planet",
                ["parts"] = {
                  "api",
                  "planet",
                },
                ["select"] = {},
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["list"] = {
            ["input"] = "data",
            ["name"] = "list",
            ["points"] = {
              {
                ["args"] = {},
                ["kind"] = "http",
                ["method"] = "GET",
                ["orig"] = "/api/planet",
                ["parts"] = {
                  "api",
                  "planet",
                },
                ["select"] = {},
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["load"] = {
            ["input"] = "data",
            ["name"] = "load",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["planet_id"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["remove"] = {
            ["input"] = "data",
            ["name"] = "remove",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["planet_id"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
          ["update"] = {
            ["input"] = "data",
            ["name"] = "update",
            ["points"] = {
              {
                ["args"] = {
                  ["params"] = {
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
                ["parts"] = {
                  "api",
                  "planet",
                  "{id}",
                },
                ["rename"] = {
                  ["param"] = {
                    ["planet_id"] = "id",
                  },
                },
                ["select"] = {
                  ["exist"] = {
                    "id",
                  },
                },
                ["transform"] = {
                  ["req"] = "`reqdata`",
                  ["res"] = "`body`",
                },
              },
            },
          },
        },
        ["relations"] = {
          ["ancestors"] = {},
        },
      },
    },
  }
end


local function make_feature(name)
  local features = require("features")
  local factory = features[name]
  if factory ~= nil then
    return factory()
  end
  return features.base()
end


-- Attach make_feature to the SDK class
local function setup_sdk(SDK)
  SDK._make_feature = make_feature
end


return make_config
