
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
          "name": "diameter",
          "req": false,
          "type": "`$NUMBER`",
          "active": true,
          "index$": 0
        },
        {
          "name": "id",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 1
        },
        {
          "name": "kind",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 2
        },
        {
          "name": "name",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 3
        },
        {
          "name": "planet_id",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 4
        }
      ],
      "name": "moon",
      "op": {
        "create": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              },
              "active": true
            }
          ],
          "name": "create"
        },
        "list": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              "active": true
            }
          ],
          "name": "list"
        },
        "load": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
                  },
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              "active": true
            }
          ],
          "name": "load"
        },
        "remove": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
                  },
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              "active": true
            }
          ],
          "name": "remove"
        },
        "update": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "moon_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
                  },
                  {
                    "kind": "param",
                    "name": "planet_id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              "active": true
            }
          ],
          "name": "update"
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
          "name": "diameter",
          "req": false,
          "type": "`$NUMBER`",
          "active": true,
          "index$": 0
        },
        {
          "name": "forbid",
          "req": false,
          "type": "`$BOOLEAN`",
          "active": true,
          "index$": 1
        },
        {
          "name": "id",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 2
        },
        {
          "name": "kind",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 3
        },
        {
          "name": "name",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 4
        },
        {
          "name": "ok",
          "req": false,
          "type": "`$BOOLEAN`",
          "active": true,
          "index$": 5
        },
        {
          "name": "start",
          "req": false,
          "type": "`$BOOLEAN`",
          "active": true,
          "index$": 6
        },
        {
          "name": "state",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 7
        },
        {
          "name": "stop",
          "req": false,
          "type": "`$BOOLEAN`",
          "active": true,
          "index$": 8
        },
        {
          "name": "why",
          "req": false,
          "type": "`$STRING`",
          "active": true,
          "index$": 9
        }
      ],
      "name": "planet",
      "op": {
        "create": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              },
              "active": true
            },
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              },
              "active": true
            },
            {
              "method": "POST",
              "orig": "/api/planet",
              "parts": [
                "api",
                "planet"
              ],
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "active": true,
              "args": {
                "param": []
              },
              "select": {}
            }
          ],
          "name": "create"
        },
        "list": {
          "alts": [
            {
              "method": "GET",
              "orig": "/api/planet",
              "parts": [
                "api",
                "planet"
              ],
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "active": true,
              "args": {
                "param": []
              },
              "select": {}
            }
          ],
          "name": "list"
        },
        "load": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              },
              "active": true
            }
          ],
          "name": "load"
        },
        "remove": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "active": true
            }
          ],
          "name": "remove"
        },
        "update": {
          "alts": [
            {
              "args": {
                "param": [
                  {
                    "kind": "param",
                    "name": "id",
                    "orig": "planet_id",
                    "reqd": true,
                    "type": "`$STRING`",
                    "active": true
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
              "select": {
                "exist": [
                  "id"
                ]
              },
              "transform": {
                "req": "`reqdata`",
                "res": "`body`"
              },
              "active": true
            }
          ],
          "name": "update"
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

