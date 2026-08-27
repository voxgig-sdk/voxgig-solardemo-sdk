# Solardemo SDK configuration


_shared_config = None


def shared_config():
    """Return the process-wide config, built once on first use.

    The SDK reads the config on every request and never writes to it, so one
    instance is shared by every client rather than rebuilt per client.

    The returned dict is shared: treat it as read-only. Callers that need to
    mutate should use make_config, which always returns a fresh copy.
    """
    global _shared_config
    if _shared_config is None:
        _shared_config = make_config()
    return _shared_config


def make_config():
    """Build a fresh, fully materialised config dict.

    Every call rebuilds the whole structure, so prefer shared_config unless
    you need a private copy you intend to mutate.
    """
    return {
        "main": {
            "name": "Solardemo",
            "slug": "solardemo",
            "version": "0.1.0",
            "target": "py",
        },
        "feature": {
            "test": {
        "options": {
          "active": False,
        },
        "transport": "base",
      },
        },
        "options": {
            "base": "http://localhost:8901",
            "headers": {
        "content-type": "application/json",
      },
            "entity": {
                "moon": {},
                "planet": {},
            },
        },
        "entity": {
      "moon": {
        "fields": [
          {
            "name": "diameter",
            "req": True,
            "type": "`$NUMBER`",
          },
          {
            "name": "id",
            "req": True,
            "type": "`$STRING`",
          },
          {
            "name": "kind",
            "req": True,
            "type": "`$STRING`",
          },
          {
            "name": "name",
            "req": True,
            "type": "`$STRING`",
          },
          {
            "name": "planet_id",
            "req": True,
            "type": "`$STRING`",
          },
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "POST",
                "orig": "/api/planet/{planet_id}/moon",
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                ],
                "select": {
                  "exist": [
                    "planet_id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "GET",
                "orig": "/api/planet/{planet_id}/moon",
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                ],
                "select": {
                  "exist": [
                    "planet_id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                    {
                      "kind": "param",
                      "name": "planet_id",
                      "orig": "planet_id",
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "GET",
                "orig": "/api/planet/{planet_id}/moon/{moon_id}",
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "moon_id": "id",
                  },
                },
                "select": {
                  "exist": [
                    "id",
                    "planet_id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                    {
                      "kind": "param",
                      "name": "planet_id",
                      "orig": "planet_id",
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "DELETE",
                "orig": "/api/planet/{planet_id}/moon/{moon_id}",
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "moon_id": "id",
                  },
                },
                "select": {
                  "exist": [
                    "id",
                    "planet_id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                    {
                      "kind": "param",
                      "name": "planet_id",
                      "orig": "planet_id",
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "PUT",
                "orig": "/api/planet/{planet_id}/moon/{moon_id}",
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "moon_id": "id",
                  },
                },
                "select": {
                  "exist": [
                    "id",
                    "planet_id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [
            [
              "planet",
            ],
          ],
        },
      },
      "planet": {
        "fields": [
          {
            "name": "diameter",
            "req": True,
            "type": "`$NUMBER`",
          },
          {
            "name": "forbid",
            "type": "`$BOOLEAN`",
          },
          {
            "name": "id",
            "req": True,
            "type": "`$STRING`",
          },
          {
            "name": "kind",
            "req": True,
            "type": "`$STRING`",
          },
          {
            "name": "name",
            "req": True,
            "type": "`$STRING`",
          },
          {
            "name": "ok",
            "type": "`$BOOLEAN`",
          },
          {
            "name": "start",
            "type": "`$BOOLEAN`",
          },
          {
            "name": "state",
            "type": "`$STRING`",
          },
          {
            "name": "stop",
            "type": "`$BOOLEAN`",
          },
          {
            "name": "why",
            "type": "`$STRING`",
          },
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "POST",
                "orig": "/api/planet/{planet_id}/forbid",
                "parts": [
                  "api",
                  "planet",
                  "{id}",
                  "forbid",
                ],
                "rename": {
                  "param": {
                    "planet_id": "id",
                  },
                },
                "select": {
                  "$action": "forbid",
                  "exist": [
                    "id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
              {
                "args": {
                  "params": [
                    {
                      "kind": "param",
                      "name": "id",
                      "orig": "planet_id",
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "POST",
                "orig": "/api/planet/{planet_id}/terraform",
                "parts": [
                  "api",
                  "planet",
                  "{id}",
                  "terraform",
                ],
                "rename": {
                  "param": {
                    "planet_id": "id",
                  },
                },
                "select": {
                  "$action": "terraform",
                  "exist": [
                    "id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
              {
                "args": {},
                "kind": "http",
                "method": "POST",
                "orig": "/api/planet",
                "parts": [
                  "api",
                  "planet",
                ],
                "select": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                  "planet",
                ],
                "select": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "GET",
                "orig": "/api/planet/{planet_id}",
                "parts": [
                  "api",
                  "planet",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "planet_id": "id",
                  },
                },
                "select": {
                  "exist": [
                    "id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "DELETE",
                "orig": "/api/planet/{planet_id}",
                "parts": [
                  "api",
                  "planet",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "planet_id": "id",
                  },
                },
                "select": {
                  "exist": [
                    "id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
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
                      "reqd": True,
                      "type": "`$STRING`",
                    },
                  ],
                },
                "kind": "http",
                "method": "PUT",
                "orig": "/api/planet/{planet_id}",
                "parts": [
                  "api",
                  "planet",
                  "{id}",
                ],
                "rename": {
                  "param": {
                    "planet_id": "id",
                  },
                },
                "select": {
                  "exist": [
                    "id",
                  ],
                },
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [],
        },
      },
    },
    }
