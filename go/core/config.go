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
			"secrets": map[string]any{
				"options": map[string]any{
					"active": false,
					"cache": true,
					"exchange": map[string]any{
						"active": false,
						"method": "POST",
						"path": "auth/token",
						"refresh": "",
						"request": "refresh_token",
						"response": "access_token",
						"retries": 1,
						"statuses": []any{
							401,
						},
					},
					"name": "apikey",
					"providers": []any{},
				},
				"transport": "wrap",
			},
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
						"format": "float",
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
								"contract": map[string]any{
									"id": "POST /api/planet/{planet_id}/moon",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet/{planet_id}/moon",
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "planet_id",
									},
									map[string]any{
										"lit": "moon",
									},
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
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
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
								"contract": map[string]any{
									"id": "GET /api/planet/{planet_id}/moon",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet/{planet_id}/moon",
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "planet_id",
									},
									map[string]any{
										"lit": "moon",
									},
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
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
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
								"contract": map[string]any{
									"id": "GET /api/planet/{planet_id}/moon/{moon_id}",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet/{planet_id}/moon/{moon_id}",
								"rename": map[string]any{
									"param": map[string]any{
										"moon_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "planet_id",
									},
									map[string]any{
										"lit": "moon",
									},
									map[string]any{
										"var": "id",
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
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
									"{id}",
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
								"contract": map[string]any{
									"id": "DELETE /api/planet/{planet_id}/moon/{moon_id}",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "DELETE",
								"orig": "/api/planet/{planet_id}/moon/{moon_id}",
								"rename": map[string]any{
									"param": map[string]any{
										"moon_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "planet_id",
									},
									map[string]any{
										"lit": "moon",
									},
									map[string]any{
										"var": "id",
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
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
									"{id}",
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
								"contract": map[string]any{
									"id": "PUT /api/planet/{planet_id}/moon/{moon_id}",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}},{\"in\":\"path\",\"name\":\"moon_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"planet_id\":{\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"planet_id\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "PUT",
								"orig": "/api/planet/{planet_id}/moon/{moon_id}",
								"rename": map[string]any{
									"param": map[string]any{
										"moon_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "planet_id",
									},
									map[string]any{
										"lit": "moon",
									},
									map[string]any{
										"var": "id",
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
								"parts": []any{
									"api",
									"planet",
									"{planet_id}",
									"moon",
									"{id}",
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
						"format": "float",
						"name": "diameter",
						"req": true,
						"type": "`$NUMBER`",
					},
					map[string]any{
						"name": "forbidReason",
						"readOnly": true,
						"short": "Why the planet is forbidden, carried from the forbid action's `why`.",
						"type": "`$STRING`",
					},
					map[string]any{
						"name": "forbidState",
						"readOnly": true,
						"short": "Set by the forbid action, and absent until it first runs.",
						"type": "`$STRING`",
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
						"name": "terraformState",
						"readOnly": true,
						"short": "Set by the terraform action, and absent until it first runs.",
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
								"contract": map[string]any{
									"id": "POST /api/planet/{planet_id}/forbid",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"forbid\":{\"type\":\"boolean\"},\"why\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet/{planet_id}/forbid",
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "id",
									},
									map[string]any{
										"lit": "forbid",
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
								"parts": []any{
									"api",
									"planet",
									"{id}",
									"forbid",
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
								"contract": map[string]any{
									"id": "POST /api/planet/{planet_id}/terraform",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"start\":{\"type\":\"boolean\"},\"stop\":{\"type\":\"boolean\"}},\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"ok\":{\"type\":\"boolean\"},\"state\":{\"type\":\"string\"}},\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet/{planet_id}/terraform",
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "id",
									},
									map[string]any{
										"lit": "terraform",
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
								"parts": []any{
									"api",
									"planet",
									"{id}",
									"terraform",
								},
							},
							map[string]any{
								"args": map[string]any{},
								"contract": map[string]any{
									"id": "POST /api/planet",
									"json": "{\"parameters\":[],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"201\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"Created\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "POST",
								"orig": "/api/planet",
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
								},
								"select": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"parts": []any{
									"api",
									"planet",
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
								"contract": map[string]any{
									"id": "GET /api/planet",
									"json": "{\"parameters\":[],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"items\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"},\"type\":\"array\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet",
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
								},
								"select": map[string]any{},
								"transform": map[string]any{
									"req": "`reqdata`",
									"res": "`body`",
								},
								"parts": []any{
									"api",
									"planet",
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
								"contract": map[string]any{
									"id": "GET /api/planet/{planet_id}",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "GET",
								"orig": "/api/planet/{planet_id}",
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "id",
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
								"parts": []any{
									"api",
									"planet",
									"{id}",
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
								"contract": map[string]any{
									"id": "DELETE /api/planet/{planet_id}",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"responses\":{\"204\":{\"description\":\"No Content\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "DELETE",
								"orig": "/api/planet/{planet_id}",
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "id",
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
								"parts": []any{
									"api",
									"planet",
									"{id}",
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
								"contract": map[string]any{
									"id": "PUT /api/planet/{planet_id}",
									"json": "{\"parameters\":[{\"in\":\"path\",\"name\":\"planet_id\",\"required\":true,\"schema\":{\"type\":\"string\"}}],\"protocol\":\"http\",\"requestBody\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"required\":true},\"responses\":{\"200\":{\"content\":{\"application/json\":{\"schema\":{\"properties\":{\"diameter\":{\"format\":\"float\",\"type\":\"number\"},\"forbidReason\":{\"description\":\"Why the planet is forbidden, carried from the forbid action's `why`. Absent while the planet is allowed.\",\"readOnly\":true,\"type\":\"string\"},\"forbidState\":{\"description\":\"Set by the forbid action, and absent until it first runs. One of allowed or forbidden.\",\"readOnly\":true,\"type\":\"string\"},\"id\":{\"type\":\"string\"},\"kind\":{\"type\":\"string\"},\"name\":{\"type\":\"string\"},\"terraformState\":{\"description\":\"Set by the terraform action, and absent until it first runs. One of idle, terraforming or complete.\",\"readOnly\":true,\"type\":\"string\"}},\"required\":[\"id\",\"name\",\"kind\",\"diameter\"],\"type\":\"object\"}}},\"description\":\"OK\"}},\"securitySource\":\"unspecified\"}",
									"source": "openapi3",
									"version": 1,
								},
								"kind": "http",
								"method": "PUT",
								"orig": "/api/planet/{planet_id}",
								"rename": map[string]any{
									"param": map[string]any{
										"planet_id": "id",
									},
								},
								"segments": []any{
									map[string]any{
										"lit": "api",
									},
									map[string]any{
										"lit": "planet",
									},
									map[string]any{
										"var": "id",
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
								"parts": []any{
									"api",
									"planet",
									"{id}",
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

// The plugin definitions the model selected per feature, as []any so a
// feature package can consume them without core naming its types. Empty
// when no active feature declares active plugin groups for this target.
var featurePlugins = map[string][]any{
}

// FeaturePlugins is the definitions list for one feature's chain.
func FeaturePlugins(name string) []any {
	return featurePlugins[name]
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
	case "secrets":
		if NewSecretsFeatureFunc != nil {
			return NewSecretsFeatureFunc()
		}
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
