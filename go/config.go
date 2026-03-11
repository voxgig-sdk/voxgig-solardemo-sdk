package solardemo

var config = map[string]any{
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
					"name": "diameter",
					"req": false,
					"type": "`$NUMBER`",
					"active": true,
					"index$": 0,
				},
				map[string]any{
					"name": "id",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 1,
				},
				map[string]any{
					"name": "kind",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 2,
				},
				map[string]any{
					"name": "name",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 3,
				},
				map[string]any{
					"name": "planet_id",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 4,
				},
			},
			"name": "moon",
			"op": map[string]any{
				"create": map[string]any{
					"name": "create",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "planet_id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
						},
					},
					"input": "data",
				},
				"list": map[string]any{
					"name": "list",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "planet_id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
						},
					},
					"input": "data",
				},
				"load": map[string]any{
					"name": "load",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "moon_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
									},
									map[string]any{
										"kind": "param",
										"name": "planet_id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
						},
					},
					"input": "data",
				},
				"remove": map[string]any{
					"name": "remove",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "moon_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
									},
									map[string]any{
										"kind": "param",
										"name": "planet_id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
						},
					},
					"input": "data",
				},
				"update": map[string]any{
					"name": "update",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "moon_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
									},
									map[string]any{
										"kind": "param",
										"name": "planet_id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
						},
					},
					"input": "data",
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
					"req": false,
					"type": "`$NUMBER`",
					"active": true,
					"index$": 0,
				},
				map[string]any{
					"name": "forbid",
					"req": false,
					"type": "`$BOOLEAN`",
					"active": true,
					"index$": 1,
				},
				map[string]any{
					"name": "id",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 2,
				},
				map[string]any{
					"name": "kind",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 3,
				},
				map[string]any{
					"name": "name",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 4,
				},
				map[string]any{
					"name": "ok",
					"req": false,
					"type": "`$BOOLEAN`",
					"active": true,
					"index$": 5,
				},
				map[string]any{
					"name": "start",
					"req": false,
					"type": "`$BOOLEAN`",
					"active": true,
					"index$": 6,
				},
				map[string]any{
					"name": "state",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 7,
				},
				map[string]any{
					"name": "stop",
					"req": false,
					"type": "`$BOOLEAN`",
					"active": true,
					"index$": 8,
				},
				map[string]any{
					"name": "why",
					"req": false,
					"type": "`$STRING`",
					"active": true,
					"index$": 9,
				},
			},
			"name": "planet",
			"op": map[string]any{
				"create": map[string]any{
					"name": "create",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
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
										"active": true,
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
							"active": true,
						},
						map[string]any{
							"method": "POST",
							"orig": "/api/planet",
							"parts": []any{
								"api",
								"planet",
							},
							"transform": map[string]any{
								"req": "`reqdata`",
								"res": "`body`",
							},
							"active": true,
							"args": map[string]any{
								"params": []any{},
							},
							"select": map[string]any{},
						},
					},
					"input": "data",
				},
				"list": map[string]any{
					"name": "list",
					"targets": []any{
						map[string]any{
							"method": "GET",
							"orig": "/api/planet",
							"parts": []any{
								"api",
								"planet",
							},
							"transform": map[string]any{
								"req": "`reqdata`",
								"res": "`body`",
							},
							"active": true,
							"args": map[string]any{
								"params": []any{},
							},
							"select": map[string]any{},
						},
					},
					"input": "data",
				},
				"load": map[string]any{
					"name": "load",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"active": true,
						},
					},
					"input": "data",
				},
				"remove": map[string]any{
					"name": "remove",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"select": map[string]any{
								"exist": []any{
									"id",
								},
							},
							"transform": map[string]any{
								"req": "`reqdata`",
								"res": "`body`",
							},
							"active": true,
						},
					},
					"input": "data",
				},
				"update": map[string]any{
					"name": "update",
					"targets": []any{
						map[string]any{
							"args": map[string]any{
								"params": []any{
									map[string]any{
										"kind": "param",
										"name": "id",
										"orig": "planet_id",
										"reqd": true,
										"type": "`$STRING`",
										"active": true,
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
							"select": map[string]any{
								"exist": []any{
									"id",
								},
							},
							"transform": map[string]any{
								"req": "`reqdata`",
								"res": "`body`",
							},
							"active": true,
						},
					},
					"input": "data",
				},
			},
			"relations": map[string]any{
				"ancestors": []any{},
			},
		},
	},
}
