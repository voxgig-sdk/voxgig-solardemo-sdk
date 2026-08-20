# AGENTS.md — Solardemo TypeScript SDK

Type-safe, entity-oriented client for the Solardemo API. Async/await
throughout; every entity operation resolves to an **entity** and **throws**
on failure.

## Install

```bash
npm install @voxgig-sdk/voxgig-solardemo
```

## Create a client

```ts
import { SolardemoSDK } from '@voxgig-sdk/voxgig-solardemo'

const client = new SolardemoSDK({
  base: process.env.SOLARDEMO_BASE_URL,   // base URL of the API server
  apikey: process.env.SOLARDEMO_APIKEY,   // bearer credential
})
```

The SDK is **server-agnostic**: set `base` to whichever API endpoint you target.

## Minimal example

```ts
try {
  for (const item of await client.Planet().list()) {
    console.log(item.data().id, item.data().name)
  }
} catch (err) {
  console.error('list failed:', err)
}
```

## Entity operations return ENTITIES

This is the single most important thing to get right, and it is where a
`Result`-style API would mislead you:

| Operation | Resolves to | On failure |
| --- | --- | --- |
| `load` / `create` / `update` | the **entity** | **throws** |
| `list` | an **array of entities** | **throws** |
| `remove` | `void` | **throws** |

The record is absorbed into the entity — reach it with `.data()`:

```ts
const created = await client.Planet().create({ /* ... */ })
console.log(created.data().id)          // the record
const again = await client.Planet().load({ id: created.data().id })
```

There is no `.ok` and no `.data` property on these results, so do not branch
on one — wrap calls in `try`/`catch` instead.

## `direct()` is the exception

The low-level `direct()` escape hatch does **not** throw. It returns either an
`Error` or a result envelope, so check before use:

```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example_id' },
})

if (result instanceof Error) {
  throw result
}
if (result.ok) {
  console.log(result.status, result.data)
}
```

```ts
{
  ok: boolean      // true when the HTTP status is 2xx
  status: number   // HTTP status code
  headers: object  // response headers
  data: any        // parsed JSON body
}
```

## Constructor options

| Option | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `apikey` | `string` | Credential sent on each request. |
| `prefix` | `string` | Path prefix prepended to every request. |
| `suffix` | `string` | Path suffix appended to every request. |
| `feature` | `object` | Feature activation flags, e.g. `{ log: { active: true } }`. |
| `extend` | `Feature[]` | Extra feature instances (custom hooks). |

## Entities

### Moon

Handle: `client.Moon()`

Fields:

| Field | Type | Required |
| --- | --- | --- |
| `diameter` | number | yes |
| `id` | string | yes |
| `kind` | string | yes |
| `name` | string | yes |
| `planet_id` | string | yes |

Operations:

| Operation | Method | Path |
| --- | --- | --- |
| `create` | POST | `/api/planet/{planet_id}/moon` |
| `list` | GET | `/api/planet/{planet_id}/moon` |
| `load` | GET | `/api/planet/{planet_id}/moon/{moon_id}` |
| `remove` | DELETE | `/api/planet/{planet_id}/moon/{moon_id}` |
| `update` | PUT | `/api/planet/{planet_id}/moon/{moon_id}` |

### Planet

Handle: `client.Planet()`

Fields:

| Field | Type | Required |
| --- | --- | --- |
| `diameter` | number | yes |
| `forbid` | boolean | no |
| `id` | string | yes |
| `kind` | string | yes |
| `name` | string | yes |
| `ok` | boolean | no |
| `start` | boolean | no |
| `state` | string | no |
| `stop` | boolean | no |
| `why` | string | no |

Operations:

| Operation | Method | Path |
| --- | --- | --- |
| `create` | POST | `/api/planet` |
| `list` | GET | `/api/planet` |
| `load` | GET | `/api/planet/{planet_id}` |
| `remove` | DELETE | `/api/planet/{planet_id}` |
| `update` | PUT | `/api/planet/{planet_id}` |

## Conventions for agents

- Obtain an entity handle with `client.Planet()`, then call an operation.
- Pass match criteria (e.g. `{ id }`) to `load`/`remove`; pass data to
  `create`/`update`. Nested entities also need their parent id.
- Operations **throw** on failure — use `try`/`catch`. Only `direct()` returns
  an envelope to inspect.
- Read the record off an entity with `.data()`; the entity itself is not the
  record.
- Full prose reference: [`README.md`](README.md) and [`REFERENCE.md`](REFERENCE.md).

## Building this SDK from source

This package is **generated** from `../.sdk`. Do not hand-edit files here.

```bash
cd ts
npm install
npm run build      # tsc --build src test
npm test
```

To change behaviour, edit the model/templates in `../.sdk` and regenerate
(see [`../AGENTS.md`](../AGENTS.md)).
