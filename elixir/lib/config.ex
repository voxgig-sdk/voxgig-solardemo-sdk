# Solardemo SDK configuration
#
# Returns the resolved SDK config as vendored-struct nodes (via
# Solardemo.Helpers.deep/1). Do not edit by hand.

defmodule Solardemo.Config do
  def make_config do
    Solardemo.Helpers.deep(%{
      "main" => %{
        "name" => "Solardemo",
        "slug" => "solardemo",
        "version" => "0.1.0",
        "target" => "elixir"
      },
      "feature" => %{
        "test" => %{
          "options" => %{
            "active" => false
          },
          "transport" => "base"
        },
      },
      "options" => %{
        "base" => "http://localhost:8901",
        "headers" => %{
          "content-type" => "application/json"
        },
        "entity" => %{
          "moon" => %{},
          "planet" => %{}
        }
      },
      "entity" => %{
        "moon" => %{
          "fields" => [
            %{
              "name" => "diameter",
              "req" => true,
              "type" => "`$NUMBER`"
            },
            %{
              "name" => "id",
              "req" => true,
              "type" => "`$STRING`"
            },
            %{
              "name" => "kind",
              "req" => true,
              "type" => "`$STRING`"
            },
            %{
              "name" => "name",
              "req" => true,
              "type" => "`$STRING`"
            },
            %{
              "name" => "planet_id",
              "req" => true,
              "type" => "`$STRING`"
            }
          ],
          "name" => "moon",
          "op" => %{
            "create" => %{
              "input" => "data",
              "name" => "create",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "planet_id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "POST",
                  "orig" => "/api/planet/{planet_id}/moon",
                  "parts" => [
                    "api",
                    "planet",
                    "{planet_id}",
                    "moon"
                  ],
                  "select" => %{
                    "exist" => [
                      "planet_id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "list" => %{
              "input" => "data",
              "name" => "list",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "planet_id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "GET",
                  "orig" => "/api/planet/{planet_id}/moon",
                  "parts" => [
                    "api",
                    "planet",
                    "{planet_id}",
                    "moon"
                  ],
                  "select" => %{
                    "exist" => [
                      "planet_id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "load" => %{
              "input" => "data",
              "name" => "load",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "moon_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      },
                      %{
                        "kind" => "param",
                        "name" => "planet_id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "GET",
                  "orig" => "/api/planet/{planet_id}/moon/{moon_id}",
                  "parts" => [
                    "api",
                    "planet",
                    "{planet_id}",
                    "moon",
                    "{id}"
                  ],
                  "rename" => %{
                    "param" => %{
                      "moon_id" => "id"
                    }
                  },
                  "select" => %{
                    "exist" => [
                      "id",
                      "planet_id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "remove" => %{
              "input" => "data",
              "name" => "remove",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "moon_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      },
                      %{
                        "kind" => "param",
                        "name" => "planet_id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "DELETE",
                  "orig" => "/api/planet/{planet_id}/moon/{moon_id}",
                  "parts" => [
                    "api",
                    "planet",
                    "{planet_id}",
                    "moon",
                    "{id}"
                  ],
                  "rename" => %{
                    "param" => %{
                      "moon_id" => "id"
                    }
                  },
                  "select" => %{
                    "exist" => [
                      "id",
                      "planet_id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "update" => %{
              "input" => "data",
              "name" => "update",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "moon_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      },
                      %{
                        "kind" => "param",
                        "name" => "planet_id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "PUT",
                  "orig" => "/api/planet/{planet_id}/moon/{moon_id}",
                  "parts" => [
                    "api",
                    "planet",
                    "{planet_id}",
                    "moon",
                    "{id}"
                  ],
                  "rename" => %{
                    "param" => %{
                      "moon_id" => "id"
                    }
                  },
                  "select" => %{
                    "exist" => [
                      "id",
                      "planet_id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            }
          },
          "relations" => %{
            "ancestors" => [
              [
                "planet"
              ]
            ]
          }
        },
        "planet" => %{
          "fields" => [
            %{
              "name" => "diameter",
              "req" => true,
              "type" => "`$NUMBER`"
            },
            %{
              "name" => "forbid",
              "type" => "`$BOOLEAN`"
            },
            %{
              "name" => "id",
              "req" => true,
              "type" => "`$STRING`"
            },
            %{
              "name" => "kind",
              "req" => true,
              "type" => "`$STRING`"
            },
            %{
              "name" => "name",
              "req" => true,
              "type" => "`$STRING`"
            },
            %{
              "name" => "ok",
              "type" => "`$BOOLEAN`"
            },
            %{
              "name" => "start",
              "type" => "`$BOOLEAN`"
            },
            %{
              "name" => "state",
              "type" => "`$STRING`"
            },
            %{
              "name" => "stop",
              "type" => "`$BOOLEAN`"
            },
            %{
              "name" => "why",
              "type" => "`$STRING`"
            }
          ],
          "name" => "planet",
          "op" => %{
            "create" => %{
              "input" => "data",
              "name" => "create",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "POST",
                  "orig" => "/api/planet/{planet_id}/forbid",
                  "parts" => [
                    "api",
                    "planet",
                    "{id}",
                    "forbid"
                  ],
                  "rename" => %{
                    "param" => %{
                      "planet_id" => "id"
                    }
                  },
                  "select" => %{
                    "$action" => "forbid",
                    "exist" => [
                      "id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                },
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "POST",
                  "orig" => "/api/planet/{planet_id}/terraform",
                  "parts" => [
                    "api",
                    "planet",
                    "{id}",
                    "terraform"
                  ],
                  "rename" => %{
                    "param" => %{
                      "planet_id" => "id"
                    }
                  },
                  "select" => %{
                    "$action" => "terraform",
                    "exist" => [
                      "id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                },
                %{
                  "args" => %{},
                  "kind" => "http",
                  "method" => "POST",
                  "orig" => "/api/planet",
                  "parts" => [
                    "api",
                    "planet"
                  ],
                  "select" => %{},
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "list" => %{
              "input" => "data",
              "name" => "list",
              "points" => [
                %{
                  "args" => %{},
                  "kind" => "http",
                  "method" => "GET",
                  "orig" => "/api/planet",
                  "parts" => [
                    "api",
                    "planet"
                  ],
                  "select" => %{},
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "load" => %{
              "input" => "data",
              "name" => "load",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "GET",
                  "orig" => "/api/planet/{planet_id}",
                  "parts" => [
                    "api",
                    "planet",
                    "{id}"
                  ],
                  "rename" => %{
                    "param" => %{
                      "planet_id" => "id"
                    }
                  },
                  "select" => %{
                    "exist" => [
                      "id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "remove" => %{
              "input" => "data",
              "name" => "remove",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "DELETE",
                  "orig" => "/api/planet/{planet_id}",
                  "parts" => [
                    "api",
                    "planet",
                    "{id}"
                  ],
                  "rename" => %{
                    "param" => %{
                      "planet_id" => "id"
                    }
                  },
                  "select" => %{
                    "exist" => [
                      "id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            },
            "update" => %{
              "input" => "data",
              "name" => "update",
              "points" => [
                %{
                  "args" => %{
                    "params" => [
                      %{
                        "kind" => "param",
                        "name" => "id",
                        "orig" => "planet_id",
                        "reqd" => true,
                        "type" => "`$STRING`"
                      }
                    ]
                  },
                  "kind" => "http",
                  "method" => "PUT",
                  "orig" => "/api/planet/{planet_id}",
                  "parts" => [
                    "api",
                    "planet",
                    "{id}"
                  ],
                  "rename" => %{
                    "param" => %{
                      "planet_id" => "id"
                    }
                  },
                  "select" => %{
                    "exist" => [
                      "id"
                    ]
                  },
                  "transform" => %{
                    "req" => "`reqdata`",
                    "res" => "`body`"
                  }
                }
              ]
            }
          },
          "relations" => %{
            "ancestors" => []
          }
        }
      }
    })
  end

  # SHARED CONFIG (sdkgen rung L2). See the data branch for the rationale, and
  # for why the cached handle is validated on read.
  @shared_key {__MODULE__, :shared_config}

  # The process-wide config, built once on first use. The returned node is
  # SHARED: treat it as read-only. Callers that need to mutate should use
  # make_config, which always returns a fresh copy.
  def shared_config do
    cached = :persistent_term.get(@shared_key, nil)

    if cached != nil and usable?(cached) do
      cached
    else
      cfg = make_config()
      :persistent_term.put(@shared_key, cfg)
      cfg
    end
  end

  defp usable?(cfg) do
    Voxgig.Struct.getprop(cfg, "main")
    true
  rescue
    ArgumentError -> false
  end
end
