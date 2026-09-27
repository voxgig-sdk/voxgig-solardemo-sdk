# VoxgigSolardemo SDK configuration


# The sekreto plugin DEFINITIONS the model selected per feature, imported
# above by name from the modules the catalogue's active `plugin.def`
# entries declare. Handed to each feature (secrets builds its Sekreto
# with them): a provider kind not listed here is unknown to that SDK.
FEATURE_PLUGINS = {
}


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
            "name": "VoxgigSolardemo",
            "slug": "voxgig-solardemo",
            "version": "0.1.0",
            "target": "py",
        },
        "feature": {
            "debug": {
        "options": {
          "active": False,
          "max": 100,
          "redact": [
            "authorization",
            "cookie",
            "set-cookie",
            "api-key",
            "apikey",
            "x-api-key",
            "idempotency-key",
          ],
        },
        "optspec": {
          "now": "`$FUNCTION`",
          "onEntry": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "none",
      },
            "idempotency": {
        "options": {
          "active": False,
          "header": "Idempotency-Key",
          "methods": [
            "POST",
            "PUT",
            "PATCH",
            "DELETE",
          ],
          "ops": [
            "create",
            "update",
            "remove",
          ],
        },
        "optspec": {
          "keygen": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "none",
      },
            "metrics": {
        "options": {
          "active": False,
        },
        "optspec": {
          "now": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "none",
      },
            "paging": {
        "options": {
          "active": False,
          "afterVar": "after",
          "cursorParam": "cursor",
          "firstVar": "first",
          "limitParam": "limit",
          "pageParam": "page",
          "startPage": 1,
        },
        "optspec": {
          "limit": "`$NUMBER`",
          "ops": "`$LIST`",
        },
        "strict": False,
        "transport": "none",
      },
            "ratelimit": {
        "options": {
          "active": False,
          "burst": 5,
          "rate": 5,
        },
        "optspec": {
          "now": "`$FUNCTION`",
          "sleep": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "wrap",
      },
            "retry": {
        "options": {
          "active": False,
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
            504,
          ],
        },
        "optspec": {
          "jitter": "`$BOOLEAN`",
          "sleep": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "wrap",
      },
            "secrets": {
        "options": {
          "active": False,
          "cache": True,
          "exchange": {
            "active": False,
            "method": "POST",
            "path": "auth/token",
            "refresh": "",
            "request": "refresh_token",
            "response": "access_token",
            "retries": 1,
            "statuses": [
              401,
            ],
          },
          "name": "apikey",
          "providers": [],
        },
        "optspec": {},
        "strict": False,
        "transport": "wrap",
      },
            "test": {
        "options": {
          "active": False,
        },
        "optspec": {
          "entity": "`$MAP`",
          "net": "`$MAP`",
        },
        "strict": False,
        "transport": "base",
      },
            "timeout": {
        "options": {
          "active": False,
          "ms": 30000,
        },
        "optspec": {
          "clearTimer": "`$FUNCTION`",
          "setTimer": "`$FUNCTION`",
        },
        "strict": False,
        "transport": "wrap",
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
            "title": "Diameter",
            "type": "`$NUMBER`",
            "req": True,
            "format": "float",
          },
          {
            "name": "id",
            "title": "Id",
            "type": "`$STRING`",
            "req": True,
          },
          {
            "name": "kind",
            "title": "Kind",
            "type": "`$STRING`",
            "req": True,
          },
          {
            "name": "name",
            "title": "Name",
            "type": "`$STRING`",
            "req": True,
          },
          {
            "name": "planet_id",
            "title": "Planet Id",
            "type": "`$STRING`",
            "req": True,
          },
        ],
        "id": {
          "field": "id",
          "name": "id",
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "planet_id",
                  },
                  {
                    "lit": "moon",
                  },
                ],
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "planet_id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "planet_id",
                  ],
                },
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "planet_id",
                  },
                  {
                    "lit": "moon",
                  },
                ],
                "parts": [
                  "api",
                  "planet",
                  "{planet_id}",
                  "moon",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "planet_id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "planet_id",
                  ],
                },
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "planet_id",
                  },
                  {
                    "lit": "moon",
                  },
                  {
                    "var": "id",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "moon_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                    {
                      "name": "planet_id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                    "planet_id",
                  ],
                },
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "planet_id",
                  },
                  {
                    "lit": "moon",
                  },
                  {
                    "var": "id",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "moon_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                    {
                      "name": "planet_id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                    "planet_id",
                  ],
                },
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "planet_id",
                  },
                  {
                    "lit": "moon",
                  },
                  {
                    "var": "id",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "moon_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                    {
                      "name": "planet_id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                    "planet_id",
                  ],
                },
              },
            ],
          },
        },
        "relations": {
          "ancestors": [
            [
              "$.main.kit.entity.planet",
            ],
          ],
        },
      },
      "planet": {
        "fields": [
          {
            "name": "diameter",
            "title": "Diameter",
            "type": "`$NUMBER`",
            "req": True,
            "format": "float",
          },
          {
            "name": "forbidReason",
            "title": "Forbid Reason",
            "type": "`$STRING`",
            "short": "Why the planet is forbidden, carried from the forbid action's `why`.",
            "readOnly": True,
          },
          {
            "name": "forbidState",
            "title": "Forbid State",
            "type": "`$STRING`",
            "short": "Set by the forbid action, and absent until it first runs.",
            "readOnly": True,
          },
          {
            "name": "id",
            "title": "Id",
            "type": "`$STRING`",
            "req": True,
          },
          {
            "name": "kind",
            "title": "Kind",
            "type": "`$STRING`",
            "req": True,
          },
          {
            "name": "name",
            "title": "Name",
            "type": "`$STRING`",
            "req": True,
          },
          {
            "name": "terraformState",
            "title": "Terraform State",
            "type": "`$STRING`",
            "short": "Set by the terraform action, and absent until it first runs.",
            "readOnly": True,
          },
        ],
        "id": {
          "field": "id",
          "name": "id",
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "id",
                  },
                  {
                    "lit": "forbid",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "$action": "forbid",
                  "exist": [
                    "id",
                  ],
                },
              },
              {
                "kind": "http",
                "method": "POST",
                "orig": "/api/planet/{planet_id}/terraform",
                "segments": [
                  {
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "id",
                  },
                  {
                    "lit": "terraform",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "$action": "terraform",
                  "exist": [
                    "id",
                  ],
                },
              },
              {
                "kind": "http",
                "method": "POST",
                "orig": "/api/planet",
                "segments": [
                  {
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                ],
                "parts": [
                  "api",
                  "planet",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {},
                "select": {},
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                ],
                "parts": [
                  "api",
                  "planet",
                ],
                "rename": {},
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {},
                "select": {},
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "id",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                  ],
                },
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "id",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                  ],
                },
              },
            ],
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
                    "lit": "api",
                  },
                  {
                    "lit": "planet",
                  },
                  {
                    "var": "id",
                  },
                ],
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
                "transform": {
                  "req": "`reqdata`",
                  "res": "`body`",
                },
                "args": {
                  "params": [
                    {
                      "name": "id",
                      "orig": "planet_id",
                      "type": "`$STRING`",
                      "kind": "param",
                      "reqd": True,
                    },
                  ],
                },
                "select": {
                  "exist": [
                    "id",
                  ],
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
