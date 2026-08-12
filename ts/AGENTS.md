# AGENTS.md — VoxgigSolardemo TypeScript SDK

Type-safe, entity-oriented client for the VoxgigSolardemo API. Async/await
throughout; every operation returns a `Result`.

## Install

```bash
npm install @voxgig-sdk/voxgig-solardemo
```

## Create a client

```ts
import { VoxgigSolardemoSDK } from '@voxgig-sdk/voxgig-solardemo'

const client = new VoxgigSolardemoSDK({
  base: process.env.VOXGIG-SOLARDEMO_BASE_URL,   // base URL of the API server
  apikey: process.env.VOXGIG-SOLARDEMO_APIKEY,   // bearer credential
})
```

The SDK is **server-agnostic**: set `base` to whichever API endpoint you target.

## Minimal example

```ts
const result = await client.Planet().list()

if (result.ok) {
  for (const item of result.data) {
    console.log(item.id, item.name)
  }
} else {
  console.error(result.status, result.error)
}
```

## Result shape

Every entity operation resolves to a `Result`:

```ts
{
  ok: boolean      // true when the HTTP status is 2xx
  status: number   // HTTP status code
  headers: object  // response headers
  data: any        // parsed JSON body
}
```

Always branch on `result.ok` before reading `result.data`.

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
- Do not throw on failure — inspect `result.ok` / `result.status`.
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
