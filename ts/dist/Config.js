"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.config = void 0;
const TestFeature_1 = require("./feature/test/TestFeature");
const FEATURE_CLASS = {
    test: TestFeature_1.TestFeature,
};
class Config {
    makeFeature(fn) {
        const fc = FEATURE_CLASS[fn];
        const fi = new fc();
        // TODO: errors etc
        return fi;
    }
    // False for a feature added at runtime via options.extend (station's
    // adopt path) - the constructor uses this to skip makeFeature for names
    // no generated class backs.
    hasFeature(fn) {
        return null != FEATURE_CLASS[fn];
    }
    main = {
        name: 'Solardemo',
        slug: "solardemo",
        version: "0.1.0",
        target: "ts",
    };
    feature = {
        test: {
            "options": {
                "active": false
            },
            "transport": "base"
        },
    };
    options = {
        base: "http://localhost:8901",
        headers: {
            "content-type": "application/json"
        },
        entity: {
            moon: {},
            planet: {},
        }
    };
    entity = {
        "moon": {
            "fields": [
                {
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
                            "kind": "http",
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
                            "kind": "http",
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
                            }
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
                            "kind": "http",
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
                            }
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
                            "kind": "http",
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
                            "kind": "http",
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
                    "name": "diameter",
                    "req": true,
                    "type": "`$NUMBER`"
                },
                {
                    "name": "forbid",
                    "type": "`$BOOLEAN`"
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
                    "name": "ok",
                    "type": "`$BOOLEAN`"
                },
                {
                    "name": "start",
                    "type": "`$BOOLEAN`"
                },
                {
                    "name": "state",
                    "type": "`$STRING`"
                },
                {
                    "name": "stop",
                    "type": "`$BOOLEAN`"
                },
                {
                    "name": "why",
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
                            "kind": "http",
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
                            "kind": "http",
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
                            "args": {},
                            "kind": "http",
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
                            "args": {},
                            "kind": "http",
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
                            "kind": "http",
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
                            "kind": "http",
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
                            "kind": "http",
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
    };
}
const config = new Config();
exports.config = config;
//# sourceMappingURL=Config.js.map