package core

func MakeConfig() map[string]any {
	return map[string]any{
		"main": map[string]any{
			"name": "Solardemo",
		},
		"feature": map[string]any{
			"test": map[string]any{
				"options": map[string]any{
					"active": false,
				},
			},
		},
		"options": map[string]any{
			"base": "http://localhost:8901",
			"auth": map[string]any{
				"prefix": "Bearer",
			},
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
						"active": true,
						"name": "diameter",
						"req": true,
						"type": "`$NUMBER`",
						"index$": 0,
					},
					map[string]any{
						"active": true,
						"name": "id",
						"req": true,
						"type": "`$STRING`",
						"index$": 1,
					},
					map[string]any{
						"active": true,
						"name": "kind",
						"req": true,
						"type": "`$STRING`",
						"index$": 2,
					},
					map[string]any{
						"active": true,
						"name": "name",
						"req": true,
						"type": "`$STRING`",
						"index$": 3,
					},
					map[string]any{
						"active": true,
						"name": "planet_id",
						"req": true,
						"type": "`$STRING`",
						"index$": 4,
					},
				},
				"name": "moon",
				"op": map[string]any{
					"create": map[string]any{
						"input": "data",
						"name": "create",
						"points": []any{
							map[string]any{
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "moon_id",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "moon_id",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "moon_id",
											"reqd": true,
											"type": "`$STRING`",
										},
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "planet_id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
						"active": true,
						"name": "diameter",
						"req": true,
						"type": "`$NUMBER`",
						"index$": 0,
					},
					map[string]any{
						"active": true,
						"name": "forbid",
						"req": false,
						"type": "`$BOOLEAN`",
						"index$": 1,
					},
					map[string]any{
						"active": true,
						"name": "id",
						"req": true,
						"type": "`$STRING`",
						"index$": 2,
					},
					map[string]any{
						"active": true,
						"name": "kind",
						"req": true,
						"type": "`$STRING`",
						"index$": 3,
					},
					map[string]any{
						"active": true,
						"name": "name",
						"req": true,
						"type": "`$STRING`",
						"index$": 4,
					},
					map[string]any{
						"active": true,
						"name": "ok",
						"req": false,
						"type": "`$BOOLEAN`",
						"index$": 5,
					},
					map[string]any{
						"active": true,
						"name": "start",
						"req": false,
						"type": "`$BOOLEAN`",
						"index$": 6,
					},
					map[string]any{
						"active": true,
						"name": "state",
						"req": false,
						"type": "`$STRING`",
						"index$": 7,
					},
					map[string]any{
						"active": true,
						"name": "stop",
						"req": false,
						"type": "`$BOOLEAN`",
						"index$": 8,
					},
					map[string]any{
						"active": true,
						"name": "why",
						"req": false,
						"type": "`$STRING`",
						"index$": 9,
					},
				},
				"name": "planet",
				"op": map[string]any{
					"create": map[string]any{
						"input": "data",
						"name": "create",
						"points": []any{
							map[string]any{
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{},
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
								"active": true,
								"args": map[string]any{},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
								"active": true,
								"args": map[string]any{
									"params": []any{
										map[string]any{
											"active": true,
											"kind": "param",
											"name": "id",
											"orig": "planet_id",
											"reqd": true,
											"type": "`$STRING`",
										},
									},
								},
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
