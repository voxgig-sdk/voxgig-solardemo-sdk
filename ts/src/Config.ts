
import { BaseFeature } from './feature/base/BaseFeature'
import { TestFeature } from './feature/test/TestFeature'



const FEATURE_CLASS: Record<string, typeof BaseFeature> = {
   test: TestFeature

}


class Config {

  makeFeature(this: any, fn: string) {
    const fc = FEATURE_CLASS[fn]
    const fi = new fc()
    // TODO: errors etc
    return fi
  }


  main = {
    name: 'Solardemo',
  }


  feature = {
     test:     {
      "options": {
        "active": false
      }
    }

  }


  options = {
    base: 'http://localhost:8901',

    auth: {
      prefix: 'Bearer',
    },

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
          "active": true,
          "name": "diameter",
          "req": true,
          "type": "`$NUMBER`",
          "index$": 0
        },
        {
          "active": true,
          "name": "id",
          "req": true,
          "type": "`$STRING`",
          "index$": 1
        },
        {
          "active": true,
          "name": "kind",
          "req": true,
          "type": "`$STRING`",
          "index$": 2
        },
        {
          "active": true,
          "name": "name",
          "req": true,
          "type": "`$STRING`",
          "index$": 3
        },
        {
          "active": true,
          "name": "planet_id",
          "req": true,
          "type": "`$STRING`",
          "index$": 4
        }
      ],
      "name": "moon",
      "op": {
        "create": {
          "input": "data",
          "name": "create",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "POST",
              "orig": "/api/planet/{planet_id}/moon",
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon"
              ],
              "select": {
                "exist": [
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            }
          ]
        },
        "list": {
          "input": "data",
          "name": "list",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "index$": 0
                  }
                ]
              },
              "method": "GET",
              "orig": "/api/planet/{planet_id}/moon",
              "parts": [
                "api",
                "planet",
                "{planet_id}",
                "moon"
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
              "index$": 0
            }
          ]
        },
        "load": {
          "input": "data",
          "name": "load",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "index$": 0
                  },
                  {
                    "active": true,
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "index$": 1
                  }
                ]
              },
              "method": "GET",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
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
              "index$": 0
            }
          ]
        },
        "remove": {
          "input": "data",
          "name": "remove",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  },
                  {
                    "active": true,
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "DELETE",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
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
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            }
          ]
        },
        "update": {
          "input": "data",
          "name": "update",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  },
                  {
                    "active": true,
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "PUT",
              "orig": "/api/planet/{planet_id}/moon/{moon_id}",
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
              "select": {
                "exist": [
                  "id",
                  "planet_id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
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
          "active": true,
          "name": "diameter",
          "req": true,
          "type": "`$NUMBER`",
          "index$": 0
        },
        {
          "active": true,
          "name": "forbid",
          "req": false,
          "type": "`$BOOLEAN`",
          "index$": 1
        },
        {
          "active": true,
          "name": "id",
          "req": true,
          "type": "`$STRING`",
          "index$": 2
        },
        {
          "active": true,
          "name": "kind",
          "req": true,
          "type": "`$STRING`",
          "index$": 3
        },
        {
          "active": true,
          "name": "name",
          "req": true,
          "type": "`$STRING`",
          "index$": 4
        },
        {
          "active": true,
          "name": "ok",
          "req": false,
          "type": "`$BOOLEAN`",
          "index$": 5
        },
        {
          "active": true,
          "name": "start",
          "req": false,
          "type": "`$BOOLEAN`",
          "index$": 6
        },
        {
          "active": true,
          "name": "state",
          "req": false,
          "type": "`$STRING`",
          "index$": 7
        },
        {
          "active": true,
          "name": "stop",
          "req": false,
          "type": "`$BOOLEAN`",
          "index$": 8
        },
        {
          "active": true,
          "name": "why",
          "req": false,
          "type": "`$STRING`",
          "index$": 9
        }
      ],
      "name": "planet",
      "op": {
        "create": {
          "input": "data",
          "name": "create",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "POST",
              "orig": "/api/planet/{planet_id}/forbid",
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
              "select": {
                "$action": "forbid",
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            },
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "POST",
              "orig": "/api/planet/{planet_id}/terraform",
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
              "select": {
                "$action": "terraform",
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            },
            {
              "active": true,
              "args": {},
              "method": "POST",
              "orig": "/api/planet",
              "parts": [
                "api",
                "planet"
              ],
              "select": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            }
          ]
        },
        "list": {
          "input": "data",
          "name": "list",
          "points": [
            {
              "active": true,
              "args": {},
              "method": "GET",
              "orig": "/api/planet",
              "parts": [
                "api",
                "planet"
              ],
              "select": {},
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            }
          ]
        },
        "load": {
          "input": "data",
          "name": "load",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "GET",
              "orig": "/api/planet/{planet_id}",
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
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            }
          ]
        },
        "remove": {
          "input": "data",
          "name": "remove",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "DELETE",
              "orig": "/api/planet/{planet_id}",
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
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              }
            }
          ]
        },
        "update": {
          "input": "data",
          "name": "update",
          "points": [
            {
              "active": true,
              "args": {
                "params": [
                  {
                    "active": true,
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`"
                  }
                ]
              },
              "method": "PUT",
              "orig": "/api/planet/{planet_id}",
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
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
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

export {
  config
}

