package core

import (
	"sync"
)

// MakeConfig builds a fresh, fully materialised config map. Every call
// rebuilds the whole structure, so prefer SharedConfig unless you need a
// private copy you intend to mutate.
func MakeConfig() map[string]any {
	return map[string]any{
		"main": map[string]any{
			"name": "Solardemo",
			"slug": "solardemo",
			"version": "0.1.0",
			"target": "go",
		},
		"feature": map[string]any{
			"test": map[string]any{
				"options": map[string]any{
					"active": false,
				},
				"transport": "base",
			},
		},
		"options": map[string]any{
			"base": "http://localhost:8901",
			"headers": map[string]any{
				"content-type": "application/json",
			},
			"entity": map[string]any{
				"moon": map[string]any{},
				"planet": map[string]any{},
			},
		},
		"entity": map[string]any{
			"moon": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "diameter",
						"req": true,
						"type": "`$NUMBER`",
					},
					map[string]any{
						"name": "id",
						"req": true,
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "kind",
						"req": true,
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "name",
						"req": true,
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "planet_id",
						"req": true,
						"type": "`$STRING`",
					},
				},
				"name": "moon",
				"op": map[string]any{
					"create": map[string]any{
						"input": "data",
						"name": "create",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet/{planet_id}/moon",
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
								},
								"select": map[string]any{
									"exist": []any{
										"planet_id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"list": map[string]any{
						"input": "data",
						"name": "list",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet/{planet_id}/moon",
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
								},
								"select": map[string]any{
									"exist": []any{
										"planet_id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "moon_id",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet/{planet_id}/moon/{moon_id}",
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"moon_id": "id",
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
										"planet_id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"remove": map[string]any{
						"input": "data",
						"name": "remove",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "moon_id",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "DELETE",
								"orig": "/api/planet/{planet_id}/moon/{moon_id}",
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"moon_id": "id",
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
										"planet_id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"update": map[string]any{
						"input": "data",
						"name": "update",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "moon_id",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "PUT",
								"orig": "/api/planet/{planet_id}/moon/{moon_id}",
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"moon_id": "id",
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
										"planet_id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{
						[]any{
							"planet",
						},
					},
				},
			},
			"planet": map[string]any{
				"fields": []any{
					map[string]any{
						"name": "diameter",
						"req": true,
						"type": "`$NUMBER`",
					},
					map[string]any{
						"name": "forbid",
						"type": "`$BOOLEAN`",
					},
					map[string]any{
						"name": "id",
						"req": true,
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "kind",
						"req": true,
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "name",
						"req": true,
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "ok",
						"type": "`$BOOLEAN`",
					},
					map[string]any{
						"name": "start",
						"type": "`$BOOLEAN`",
					},
					map[string]any{
						"name": "state",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "stop",
						"type": "`$BOOLEAN`",
					},
					map[string]any{
						"name": "why",
						"type": "`$STRING`",
					},
				},
				"name": "planet",
				"op": map[string]any{
					"create": map[string]any{
						"input": "data",
						"name": "create",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet/{planet_id}/forbid",
								"parts": []any{
									"api",
									"planet",
									"{id}",
									"forbid",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"select": map[string]any{
									"$action": "forbid",
									"exist": []any{
										"id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet/{planet_id}/terraform",
								"parts": []any{
									"api",
									"planet",
									"{id}",
									"terraform",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"select": map[string]any{
									"$action": "terraform",
									"exist": []any{
										"id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
							map[string]any{
								"args": map[string]any{},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet",
								"parts": []any{
									"api",
									"planet",
								},
								"select": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"list": map[string]any{
						"input": "data",
						"name": "list",
						"points": []any{
							map[string]any{
								"args": map[string]any{},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet",
								"parts": []any{
									"api",
									"planet",
								},
								"select": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"load": map[string]any{
						"input": "data",
						"name": "load",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet/{planet_id}",
								"parts": []any{
									"api",
									"planet",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"remove": map[string]any{
						"input": "data",
						"name": "remove",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "DELETE",
								"orig": "/api/planet/{planet_id}",
								"parts": []any{
									"api",
									"planet",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
					"update": map[string]any{
						"input": "data",
						"name": "update",
						"points": []any{
							map[string]any{
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
								"kind": "http",
								"method": "PUT",
								"orig": "/api/planet/{planet_id}",
								"parts": []any{
									"api",
									"planet",
									"{id}",
								},
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"select": map[string]any{
									"exist": []any{
										"id",
									},
								},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
							},
						},
					},
				},
				"relations": map[string]any{
					"ancestors": []any{},
				},
			},
		},
	}
}

var (
	sharedConfigOnce sync.Once
	sharedConfigVal  map[string]any
)

// SharedConfig returns the process-wide config, built once on first use.
// The SDK reads the config on every request and never writes to it, so one
// instance is shared by every client rather than rebuilt per client.
//
// The returned map is shared: treat it as read-only. Callers that need to
// mutate should use MakeConfig, which always returns a fresh copy.
func SharedConfig() map[string]any {
	sharedConfigOnce.Do(func() {
		sharedConfigVal = MakeConfig()
	})
	return sharedConfigVal
}

func makeFeature(name string) Feature {
	switch name {
	case "test":
		if NewTestFeatureFunc != nil {
			return NewTestFeatureFunc()
		}
	default:
		if NewBaseFeatureFunc != nil {
			return NewBaseFeatureFunc()
		}
	}
	return nil
}
