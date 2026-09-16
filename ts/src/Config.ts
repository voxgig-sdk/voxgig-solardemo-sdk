
import { BaseFeature } from './feature/base/BaseFeature'
import { SecretsFeature } from './feature/secrets/SecretsFeature'
import { TestFeature } from './feature/test/TestFeature'



const FEATURE_CLASS: Record<string, typeof BaseFeature> = {
   secrets: SecretsFeature,
 test: TestFeature,

}


// Per-feature plugin DEFINITIONS (voxgig/plugin `Definition` values), from
// the model's active plugin groups. A feature that takes a `plugins` option
// (secrets over sekreto) reads its own entry; a feature with no plugins has
// none. Named imports above make each definition statically reachable, so
// an SDK carries exactly the plugin modules its model selects — the same
// leanness the old side-effect registry imports bought, without a registry.
const FEATURE_PLUGINS: Record<string, any[]> = {
  
}


class Config {

  makeFeature(this: any, fn: string) {
    const fc = FEATURE_CLASS[fn]
    const fi = new fc()
    // TODO: errors etc
    return fi
  }

  // False for a feature added at runtime via options.extend (station's
  // adopt path) - the constructor uses this to skip makeFeature for names
  // no generated class backs.
  hasFeature(this: any, fn: string) {
    return null != FEATURE_CLASS[fn]
  }


  main = {
    name: 'Solardemo',
        slug: "solardemo",
    version: "0.1.0",
    target: "ts",

  }


  feature = {
     secrets:     {
      "options": {
        "active": false,
        "cache": true,
        "exchange": {
          "active": false,
          "method": "POST",
          "path": "auth/token",
          "refresh": "",
          "request": "refresh_token",
          "response": "access_token",
          "retries": 1,
          "statuses": [
            401
          ]
        },
        "name": "apikey",
        "providers": []
      },
      "transport": "wrap"
    },
 test:     {
      "options": {
        "active": false
      },
      "transport": "base"
    },

  }


  options = {
    base: "http://localhost:8901",

    headers: {
      "content-type": "application/json"
    },

    entity: {
      
      moon: {
      },

      planet: {
      },

    }
  }


  entity = {
    "moon": {
      "fields": [
        {
          "format": "float",
          "name": "diameter",
          "req": true,
          "type": "`$NUMBER`"
        },
        {
          "name": "id",
          "req": true,
          "type": "`$STRING`"
        },
        {
          "name": "kind",
          "req": true,
          "type": "`$STRING`"
        },
        {
          "name": "name",
          "req": true,
          "type": "`$STRING`"
        },
        {
          "name": "planet_id",
          "req": true,
          "type": "`$STRING`"
        }
      ],
      "name": "moon",
      "op": {
        "create": {
          "input": "data",
          "name": "create",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "POST /api/planet/{planet_id}/moon",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "POST",
              "orig": "/api/planet/{planet_id}/moon",
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "planet_id"
                },
                {
                  "lit": "moon"
                }
              ],
              "select": {
                "exist": [
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon"
              ]
            }
          ]
        },
        "list": {
          "input": "data",
          "name": "list",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "GET /api/planet/{planet_id}/moon",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "GET",
              "orig": "/api/planet/{planet_id}/moon",
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "planet_id"
                },
                {
                  "lit": "moon"
                }
              ],
              "select": {
                "exist": [
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon"
              ]
            }
          ]
        },
        "load": {
          "input": "data",
          "name": "load",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  },
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "GET /api/planet/{planet_id}/moon/{moon_id}",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "GET",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
              "rename": {
                "param": {
                  "moon_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "planet_id"
                },
                {
                  "lit": "moon"
                },
                {
                  "var": "id"
                }
              ],
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon",
                "{id}"
              ]
            }
          ]
        },
        "remove": {
          "input": "data",
          "name": "remove",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  },
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "DELETE /api/planet/{planet_id}/moon/{moon_id}",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "DELETE",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
              "rename": {
                "param": {
                  "moon_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "planet_id"
                },
                {
                  "lit": "moon"
                },
                {
                  "var": "id"
                }
              ],
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon",
                "{id}"
              ]
            }
          ]
        },
        "update": {
          "input": "data",
          "name": "update",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  },
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "PUT /api/planet/{planet_id}/moon/{moon_id}",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "PUT",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
              "rename": {
                "param": {
                  "moon_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "planet_id"
                },
                {
                  "lit": "moon"
                },
                {
                  "var": "id"
                }
              ],
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon",
                "{id}"
              ]
            }
          ]
        }
      },
      "relations": {
        "ancestors": [
          [
            "planet"
          ]
        ]
      }
    },
    "planet": {
      "fields": [
        {
          "format": "float",
          "name": "diameter",
          "req": true,
          "type": "`$NUMBER`"
        },
        {
          "name": "forbidReason",
          "readOnly": true,
          "short": "Why the planet is forbidden, carried from the forbid action's `why`.",
          "type": "`$STRING`"
        },
        {
          "name": "forbidState",
          "readOnly": true,
          "short": "Set by the forbid action, and absent until it first runs.",
          "type": "`$STRING`"
        },
        {
          "name": "id",
          "req": true,
          "type": "`$STRING`"
        },
        {
          "name": "kind",
          "req": true,
          "type": "`$STRING`"
        },
        {
          "name": "name",
          "req": true,
          "type": "`$STRING`"
        },
        {
          "name": "terraformState",
          "readOnly": true,
          "short": "Set by the terraform action, and absent until it first runs.",
          "type": "`$STRING`"
        }
      ],
      "name": "planet",
      "op": {
        "create": {
          "input": "data",
          "name": "create",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "POST /api/planet/{planet_id}/forbid",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"forbid\":{\"type\":\"boolean\"},\"why\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "POST",
              "orig": "/api/planet/{planet_id}/forbid",
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "id"
                },
                {
                  "lit": "forbid"
                }
              ],
              "select": {
                "$action": "forbid",
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{id}",
                "forbid"
              ]
            },
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "POST /api/planet/{planet_id}/terraform",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"start\":{\"type\":\"boolean\"},\"stop\":{\"type\":\"boolean\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "POST",
              "orig": "/api/planet/{planet_id}/terraform",
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "id"
                },
                {
                  "lit": "terraform"
                }
              ],
              "select": {
                "$action": "terraform",
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{id}",
                "terraform"
              ]
            },
            {
              "args": {},
              "contract": {
                "id": "POST /api/planet",
                "json": "{\"parameters\":[],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "POST",
              "orig": "/api/planet",
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                }
              ],
              "select": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet"
              ]
            }
          ]
        },
        "list": {
          "input": "data",
          "name": "list",
          "points": [
            {
              "args": {},
              "contract": {
                "id": "GET /api/planet",
                "json": "{\"parameters\":[],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "GET",
              "orig": "/api/planet",
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                }
              ],
              "select": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet"
              ]
            }
          ]
        },
        "load": {
          "input": "data",
          "name": "load",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "GET /api/planet/{planet_id}",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "GET",
              "orig": "/api/planet/{planet_id}",
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "id"
                }
              ],
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{id}"
              ]
            }
          ]
        },
        "remove": {
          "input": "data",
          "name": "remove",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "DELETE /api/planet/{planet_id}",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "DELETE",
              "orig": "/api/planet/{planet_id}",
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "id"
                }
              ],
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{id}"
              ]
            }
          ]
        },
        "update": {
          "input": "data",
          "name": "update",
          "points": [
            {
              "args": {
                "params": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "contract": {
                "id": "PUT /api/planet/{planet_id}",
                "json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
                "source": "openapi3",
                "version": 1
              },
              "kind": "http",
              "method": "PUT",
              "orig": "/api/planet/{planet_id}",
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "segments": [
                {
                  "lit": "api"
                },
                {
                  "lit": "planet"
                },
                {
                  "var": "id"
                }
              ],
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "parts": [
                "api",
                "planet",
                "{id}"
              ]
            }
          ]
        }
      },
      "relations": {
        "ancestors": []
      }
    }
  }
}


const config = new Config()

export {
  config,
  FEATURE_PLUGINS,
}

