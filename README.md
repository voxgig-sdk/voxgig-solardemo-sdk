# Solardemo SDK

The Solardemo SDK provides a high-level, entity-oriented interface to the
Solardemo API. Rather than constructing HTTP requests manually, you work
with business entities — Planet and Moon — using familiar CRUD operations.

Available for [TypeScript](ts/) and [Go](go/).


## Entities

The API exposes two entities:

| Entity | Description | API path |
| --- | --- | --- |
| **Planet** | A top-level resource. | `/api/planet/{id}` |
| **Moon** | A resource nested under Planet. | `/api/planet/{planet_id}/moon/{id}` |

Each entity supports five operations: **load**, **list**, **create**,
**update**, and **remove**.


## Architecture

### Entity-operation model

Every SDK call follows the same pipeline:

1. **Point** — resolve the API endpoint from the operation definition.
2. **Spec** — build the HTTP specification (URL, method, headers, body).
3. **Request** — send the HTTP request.
4. **Response** — receive and parse the response.
5. **Result** — extract the result data for the caller.

At each stage a feature hook fires (e.g. `PrePoint`, `PreSpec`,
`PreRequest`), allowing features to inspect or modify the pipeline.

### Features

Features are hook-based middleware that extend SDK behaviour.

| Feature | Purpose |
| --- | --- |
| **BaseFeature** | Core request/response handling. Always active. |
| **TestFeature** | Mock transport for offline testing. Active in test mode. |
| **LogFeature** | Structured logging via pino (TypeScript) or standard log (Go). |

You can add custom features by passing them in the `extend` option at
construction time.

### Direct and Prepare

For endpoints not covered by the entity model, use the low-level methods:

- **`direct(fetchargs)`** — build and send an HTTP request in one step.
- **`prepare(fetchargs)`** — build the request without sending it.

Both accept a map with `path`, `method`, `params`, `query`, `headers`,
and `body`.


## Quick start

### TypeScript

```ts
import { SolardemoSDK } from 'solardemo'

const client = new SolardemoSDK({
  apikey: process.env.SOLARDEMO_APIKEY,
})

// List all planets
const planets = await client.Planet().list()

// Load a specific moon under a planet
const moon = await client.Moon().load({
  planet_id: 'earth',
  id: 'luna',
})
```

### Go

```go
import sdk "voxgigsolardemosdk"

client := sdk.NewSolardemoSDK(map[string]any{
    "apikey": os.Getenv("SOLARDEMO_APIKEY"),
})

// List all planets
planets, err := client.Planet(nil).List(nil, nil)

// Load a specific moon under a planet
moon, err := client.Moon(nil).Load(
    map[string]any{"planet_id": "earth", "id": "luna"}, nil,
)
```


## Testing

Both SDKs provide a test mode that replaces the HTTP transport with an
in-memory mock, so tests run without a network connection.

### TypeScript

```ts
const client = SolardemoSDK.test()
const result = await client.Planet().load({ id: 'mars' })
// result.ok === true, result.data contains mock data
```

### Go

```go
client := sdk.TestSDK(nil, nil)
result, err := client.Planet(nil).Load(
    map[string]any{"id": "mars"}, nil,
)
```

### Live testing

Set the following environment variables (or create a `.env.local` file)
to run tests against a live server:

```
SOLARDEMO_TEST_LIVE=TRUE
SOLARDEMO_APIKEY=<your-api-key>
```

Entity-specific ID mappings can be provided as JSON:

```
SOLARDEMO_TEST_MOON_ENTID={"planet01":"earth"}
SOLARDEMO_TEST_PLANET_ENTID={}
```


## How-to guides

### Make a direct API call

When the entity interface does not cover an endpoint, use `direct`:

**TypeScript:**
```ts
const result = await client.direct({
  path: '/api/planet/{id}',
  method: 'GET',
  params: { id: 'mars' },
})
console.log(result.data)
```

**Go:**
```go
result, err := client.Direct(map[string]any{
    "path":   "/api/planet/{id}",
    "method": "GET",
    "params": map[string]any{"id": "mars"},
})
```

### Work with nested entities

Moon is nested under Planet. Always provide the parent ID:

**TypeScript:**
```ts
const moon = client.Moon()
const result = await moon.create({
  planet_id: 'earth',
  name: 'Luna',
})
```

**Go:**
```go
moon := client.Moon(nil)
result, err := moon.Create(
    map[string]any{"planet_id": "earth", "name": "Luna"}, nil,
)
```

### Add a custom feature

Extend the SDK with your own hook-based middleware:

**TypeScript:**
```ts
const myFeature = {
  hooks: {
    PreRequest: (ctx) => {
      ctx.spec.headers['X-Custom'] = 'value'
    },
  },
}

const client = new SolardemoSDK({
  apikey: '...',
  extend: [myFeature],
})
```

### Inspect a request before sending

Use `prepare` to see what the SDK would send without executing it:

**TypeScript:**
```ts
const fetchdef = await client.prepare({
  path: '/api/planet',
  method: 'GET',
})
console.log(fetchdef.url, fetchdef.method, fetchdef.headers)
```

**Go:**
```go
fetchdef, err := client.Prepare(map[string]any{
    "path":   "/api/planet",
    "method": "GET",
})
// fetchdef["url"], fetchdef["method"], fetchdef["headers"]
```


## Language-specific documentation

- [TypeScript SDK](ts/README.md)
- [Go SDK](go/README.md)
