import { describe, test } from 'node:test'
import { SDK } from '..'
import { runDefinitionPoint } from './definition-runner'
import { isControlSkipped } from './utility'


// Generated from the API definition, not from the model this SDK was built
// from: the route, the declared query parameters, the credential the security
// scheme names, and the definition's own response example.
const PLAN: any[] = [
  {
    "entity": "moon",
    "accessor": "Moon",
    "op": "create",
    "method": "POST",
    "path": "/api/planet/{planet_id}/moon",
    "args": [
      {
        "name": "planet_id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 201,
    "sample": {
      "id": "x",
      "name": "x",
      "planet_id": "x",
      "kind": "x",
      "diameter": 1
    },
    "idField": "id"
  },
  {
    "entity": "moon",
    "accessor": "Moon",
    "op": "list",
    "method": "GET",
    "path": "/api/planet/{planet_id}/moon",
    "args": [
      {
        "name": "planet_id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": [
      {
        "id": "x",
        "name": "x",
        "planet_id": "x",
        "kind": "x",
        "diameter": 1
      }
    ],
    "idField": "id"
  },
  {
    "entity": "moon",
    "accessor": "Moon",
    "op": "load",
    "method": "GET",
    "path": "/api/planet/{planet_id}/moon/{moon_id}",
    "args": [
      {
        "name": "id",
        "wire": "moon_id",
        "value": "p1"
      },
      {
        "name": "planet_id",
        "wire": "planet_id",
        "value": "p2"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": {
      "id": "x",
      "name": "x",
      "planet_id": "x",
      "kind": "x",
      "diameter": 1
    },
    "idField": "id"
  },
  {
    "entity": "moon",
    "accessor": "Moon",
    "op": "remove",
    "method": "DELETE",
    "path": "/api/planet/{planet_id}/moon/{moon_id}",
    "args": [
      {
        "name": "id",
        "wire": "moon_id",
        "value": "p1"
      },
      {
        "name": "planet_id",
        "wire": "planet_id",
        "value": "p2"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 204,
    "sample": null,
    "idField": "id"
  },
  {
    "entity": "moon",
    "accessor": "Moon",
    "op": "update",
    "method": "PUT",
    "path": "/api/planet/{planet_id}/moon/{moon_id}",
    "args": [
      {
        "name": "id",
        "wire": "moon_id",
        "value": "p1"
      },
      {
        "name": "planet_id",
        "wire": "planet_id",
        "value": "p2"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": {
      "id": "x",
      "name": "x",
      "planet_id": "x",
      "kind": "x",
      "diameter": 1
    },
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "create",
    "method": "POST",
    "path": "/api/planet/{planet_id}/forbid",
    "action": "forbid",
    "args": [
      {
        "name": "id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": {
      "ok": true,
      "state": "x"
    },
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "create",
    "method": "POST",
    "path": "/api/planet/{planet_id}/terraform",
    "action": "terraform",
    "args": [
      {
        "name": "id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": {
      "ok": true,
      "state": "x"
    },
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "create",
    "method": "POST",
    "path": "/api/planet",
    "args": [],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 201,
    "sample": {
      "id": "x",
      "name": "x",
      "kind": "x",
      "diameter": 1,
      "terraformState": "x",
      "forbidState": "x",
      "forbidReason": "x"
    },
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "list",
    "method": "GET",
    "path": "/api/planet",
    "args": [],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": [
      {
        "id": "x",
        "name": "x",
        "kind": "x",
        "diameter": 1,
        "terraformState": "x",
        "forbidState": "x",
        "forbidReason": "x"
      }
    ],
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "load",
    "method": "GET",
    "path": "/api/planet/{planet_id}",
    "args": [
      {
        "name": "id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": {
      "id": "x",
      "name": "x",
      "kind": "x",
      "diameter": 1,
      "terraformState": "x",
      "forbidState": "x",
      "forbidReason": "x"
    },
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "remove",
    "method": "DELETE",
    "path": "/api/planet/{planet_id}",
    "args": [
      {
        "name": "id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 204,
    "sample": null,
    "idField": "id"
  },
  {
    "entity": "planet",
    "accessor": "Planet",
    "op": "update",
    "method": "PUT",
    "path": "/api/planet/{planet_id}",
    "args": [
      {
        "name": "id",
        "wire": "planet_id",
        "value": "p1"
      }
    ],
    "select": {},
    "headers": [],
    "cookies": [],
    "responseMedia": [
      "application/json"
    ],
    "query": [],
    "queryArgs": [],
    "auth": null,
    "status": 200,
    "sample": {
      "id": "x",
      "name": "x",
      "kind": "x",
      "diameter": 1,
      "terraformState": "x",
      "forbidState": "x",
      "forbidReason": "x"
    },
    "idField": "id"
  }
]


describe('definition', () => {
  for (const point of PLAN) {
    test(point.entity + '.' + point.op + ' ' + point.method + ' ' + point.path, async (t) => {
      const control = isControlSkipped('entityOp', point.entity + '.' + point.op, 'definition')
      if (control.skip) {
        t.skip(control.reason || 'skipped via sdk-test-control.json')
        return
      }
      await runDefinitionPoint(SDK, point)
    })
  }
})
