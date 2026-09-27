
const { BaseFeature } = require('./feature/base/BaseFeature')
const { DebugFeature } = require('./feature/debug/DebugFeature')
const { IdempotencyFeature } = require('./feature/idempotency/IdempotencyFeature')
const { MetricsFeature } = require('./feature/metrics/MetricsFeature')
const { PagingFeature } = require('./feature/paging/PagingFeature')
const { RatelimitFeature } = require('./feature/ratelimit/RatelimitFeature')
const { RetryFeature } = require('./feature/retry/RetryFeature')
const { SecretsFeature } = require('./feature/secrets/SecretsFeature')
const { TestFeature } = require('./feature/test/TestFeature')
const { TimeoutFeature } = require('./feature/timeout/TimeoutFeature')



const FEATURE_CLASS = {
   debug: DebugFeature,
 idempotency: IdempotencyFeature,
 metrics: MetricsFeature,
 paging: PagingFeature,
 ratelimit: RatelimitFeature,
 retry: RetryFeature,
 secrets: SecretsFeature,
 test: TestFeature,
 timeout: TimeoutFeature,

}


// Per-feature plugin DEFINITIONS (voxgig/plugin `Definition` values), from
// the model's active plugin groups. A feature that takes a `plugins` option
// (secrets over sekreto) reads its own entry; a feature with no plugins has
// none. Named requires above make each definition statically reachable, so
// an SDK carries exactly the plugin modules its model selects — the same
// leanness the old side-effect registry imports bought, without a registry.
//
// Read by SecretsFeature through a DEFERRED require of this module: the
// requires above make the pair circular, and this file replaces
// module.exports at the end of its body, so anything reading the map at
// module load would get undefined. See tm/js/src/feature/secrets.
const FEATURE_PLUGINS = {
  
}


class Config {

  makeFeature(fn) {
    const fc = FEATURE_CLASS[fn]
    const fi = new fc()
    // TODO: errors etc
    return fi
  }

  // False for a feature added at runtime via options.extend (station's
  // adopt path) - the constructor uses this to skip makeFeature for names
  // no generated class backs.
  hasFeature(fn) {
    return null != FEATURE_CLASS[fn]
  }


  main = {
    name: 'VoxgigSolardemo',
        slug: "voxgig-solardemo",
    version: "0.1.0",
    target: "js",

  }


  feature = {
     debug:     {
      "options": {
        "active": false,
        "max": 100,
        "redact": [
          "authorization",
          "cookie",
          "set-cookie",
          "api-key",
          "apikey",
          "x-api-key",
          "idempotency-key"
        ]
      },
      "optspec": {
        "now": "`$FUNCTION`",
        "onEntry": "`$FUNCTION`"
      },
      "strict": false,
      "transport": "none"
    },
 idempotency:     {
      "options": {
        "active": false,
        "header": "Idempotency-Key",
        "methods": [
          "POST",
          "PUT",
          "PATCH",
          "DELETE"
        ],
        "ops": [
          "create",
          "update",
          "remove"
        ]
      },
      "optspec": {
        "keygen": "`$FUNCTION`"
      },
      "strict": false,
      "transport": "none"
    },
 metrics:     {
      "options": {
        "active": false
      },
      "optspec": {
        "now": "`$FUNCTION`"
      },
      "strict": false,
      "transport": "none"
    },
 paging:     {
      "options": {
        "active": false,
        "afterVar": "after",
        "cursorParam": "cursor",
        "firstVar": "first",
        "limitParam": "limit",
        "pageParam": "page",
        "startPage": 1
      },
      "optspec": {
        "limit": "`$NUMBER`",
        "ops": "`$LIST`"
      },
      "strict": false,
      "transport": "none"
    },
 ratelimit:     {
      "options": {
        "active": false,
        "burst": 5,
        "rate": 5
      },
      "optspec": {
        "now": "`$FUNCTION`",
        "sleep": "`$FUNCTION`"
      },
      "strict": false,
      "transport": "wrap"
    },
 retry:     {
      "options": {
        "active": false,
        "factor": 2,
        "maxDelay": 2000,
        "minDelay": 50,
        "retries": 2,
        "statuses": [
          408,
          425,
          429,
          500,
          502,
          503,
          504
        ]
      },
      "optspec": {
        "jitter": "`$BOOLEAN`",
        "sleep": "`$FUNCTION`"
      },
      "strict": false,
      "transport": "wrap"
    },
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
      "optspec": {},
      "strict": false,
      "transport": "wrap"
    },
 test:     {
      "options": {
        "active": false
      },
      "optspec": {
        "entity": "`$MAP`",
        "net": "`$MAP`"
      },
      "strict": false,
      "transport": "base"
    },
 timeout:     {
      "options": {
        "active": false,
        "ms": 30000
      },
      "optspec": {
        "clearTimer": "`$FUNCTION`",
        "setTimer": "`$FUNCTION`"
      },
      "strict": false,
      "transport": "wrap"
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
          "name": "diameter",
          "title": "Diameter",
          "type": "`$NUMBER`",
          "req": true,
          "format": "float"
        },
        {
          "name": "id",
          "title": "Id",
          "type": "`$STRING`",
          "req": true
        },
        {
          "name": "kind",
          "title": "Kind",
          "type": "`$STRING`",
          "req": true
        },
        {
          "name": "name",
          "title": "Name",
          "type": "`$STRING`",
          "req": true
        },
        {
          "name": "planet_id",
          "title": "Planet Id",
          "type": "`$STRING`",
          "req": true
        }
      ],
      "id": {
        "field": "id",
        "name": "id"
      },
      "name": "moon",
      "op": {
        "create": {
          "input": "data",
          "name": "create",
          "points": [
            {
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
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon"
              ],
              "rename": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "planet_id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "planet_id"
                ]
              }
            }
          ]
        },
        "list": {
          "input": "data",
          "name": "list",
          "points": [
            {
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
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon"
              ],
              "rename": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "planet_id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "planet_id"
                ]
              }
            }
          ]
        },
        "load": {
          "input": "data",
          "name": "load",
          "points": [
            {
              "kind": "http",
              "method": "GET",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
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
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon",
                "{id}"
              ],
              "rename": {
                "param": {
                  "moon_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "moon_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  },
                  {
                    "name": "planet_id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              }
            }
          ]
        },
        "remove": {
          "input": "data",
          "name": "remove",
          "points": [
            {
              "kind": "http",
              "method": "DELETE",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
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
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon",
                "{id}"
              ],
              "rename": {
                "param": {
                  "moon_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "moon_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  },
                  {
                    "name": "planet_id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              }
            }
          ]
        },
        "update": {
          "input": "data",
          "name": "update",
          "points": [
            {
              "kind": "http",
              "method": "PUT",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
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
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon",
                "{id}"
              ],
              "rename": {
                "param": {
                  "moon_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "moon_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  },
                  {
                    "name": "planet_id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              }
            }
          ]
        }
      },
      "relations": {
        "ancestors": [
          [
            "$.main.kit.entity.planet"
          ]
        ]
      }
    },
    "planet": {
      "fields": [
        {
          "name": "diameter",
          "title": "Diameter",
          "type": "`$NUMBER`",
          "req": true,
          "format": "float"
        },
        {
          "name": "forbidReason",
          "title": "Forbid Reason",
          "type": "`$STRING`",
          "short": "Why the planet is forbidden, carried from the forbid action's `why`.",
          "readOnly": true
        },
        {
          "name": "forbidState",
          "title": "Forbid State",
          "type": "`$STRING`",
          "short": "Set by the forbid action, and absent until it first runs.",
          "readOnly": true
        },
        {
          "name": "id",
          "title": "Id",
          "type": "`$STRING`",
          "req": true
        },
        {
          "name": "kind",
          "title": "Kind",
          "type": "`$STRING`",
          "req": true
        },
        {
          "name": "name",
          "title": "Name",
          "type": "`$STRING`",
          "req": true
        },
        {
          "name": "terraformState",
          "title": "Terraform State",
          "type": "`$STRING`",
          "short": "Set by the terraform action, and absent until it first runs.",
          "readOnly": true
        }
      ],
      "id": {
        "field": "id",
        "name": "id"
      },
      "name": "planet",
      "op": {
        "create": {
          "input": "data",
          "name": "create",
          "points": [
            {
              "kind": "http",
              "method": "POST",
              "orig": "/api/planet/{planet_id}/forbid",
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
              "parts": [
                "api",
                "planet",
                "{id}",
                "forbid"
              ],
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "$action": "forbid",
                "exist": [
                  "id"
                ]
              }
            },
            {
              "kind": "http",
              "method": "POST",
              "orig": "/api/planet/{planet_id}/terraform",
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
              "parts": [
                "api",
                "planet",
                "{id}",
                "terraform"
              ],
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "$action": "terraform",
                "exist": [
                  "id"
                ]
              }
            },
            {
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
              "parts": [
                "api",
                "planet"
              ],
              "rename": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {},
              "select": {}
            }
          ]
        },
        "list": {
          "input": "data",
          "name": "list",
          "points": [
            {
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
              "parts": [
                "api",
                "planet"
              ],
              "rename": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {},
              "select": {}
            }
          ]
        },
        "load": {
          "input": "data",
          "name": "load",
          "points": [
            {
              "kind": "http",
              "method": "GET",
              "orig": "/api/planet/{planet_id}",
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
              "parts": [
                "api",
                "planet",
                "{id}"
              ],
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "id"
                ]
              }
            }
          ]
        },
        "remove": {
          "input": "data",
          "name": "remove",
          "points": [
            {
              "kind": "http",
              "method": "DELETE",
              "orig": "/api/planet/{planet_id}",
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
              "parts": [
                "api",
                "planet",
                "{id}"
              ],
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "id"
                ]
              }
            }
          ]
        },
        "update": {
          "input": "data",
          "name": "update",
          "points": [
            {
              "kind": "http",
              "method": "PUT",
              "orig": "/api/planet/{planet_id}",
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
              "parts": [
                "api",
                "planet",
                "{id}"
              ],
              "rename": {
                "param": {
                  "planet_id": "id"
                }
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "args": {
                "params": [
                  {
                    "name": "id",
                    "orig": "planet_id",
                    "type": "`$STRING`",
                    "kind": "param",
                    "reqd": true
                  }
                ]
              },
              "select": {
                "exist": [
                  "id"
                ]
              }
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

module.exports = {
  config,
  FEATURE_PLUGINS,
}

