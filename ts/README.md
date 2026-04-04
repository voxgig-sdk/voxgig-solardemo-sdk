
# Solardemo TypeScript SDK

## Introduction



### Features

- Entity-based API: work with business objects directly.
- Type safe: full TypeScript definitions included.
- Direct HTTP access: call any API endpoint using `client.direct()`.
- Testable: built-in test mode with mock support.


## Install
```ts
npm install solardemo
```
## Quick Start


### Create a Client

```ts
import { SolardemoSDK } from 'solardemo'

const client = new SolardemoSDK({
  apikey: process.env.SOLARDEMO_APIKEY,
})
```

### Direct API Access

Use `client.direct()` to call any API endpoint directly:

```ts
const result = await client.direct({
  path: '/custom/endpoint/{id}',
  method: 'GET',
  params: { id: 'abc123' },
})

if (result.ok) {
  console.log(result.data)
}
```


## SDK Structure

This SDK uses an entity-oriented interface rather than exposing API
endpoint paths directly. Business logic maps directly to business
entities in your code.


### Client

Create a client instance using the constructor or the static `test` method:

```ts
// Production client
const client = new SolardemoSDK({ apikey: '...' })

// Test client with mock features
const testClient = SolardemoSDK.test()
```


### Client Methods

| Method | Description |
| --- | --- |
| `options()` | Return a copy of the current SDK options. |
| `utility()` | Return a copy of the SDK utility object. |
| `direct(fetchargs)` | Make a direct HTTP request to any API endpoint. |
| `prepare(fetchargs)` | Prepare a fetch definition without sending the request. |
| `tester(testopts?, sdkopts?)` | Create a test client instance. |


### Entity Methods

Each entity instance provides the following methods, where available:

| Method | Description |
| --- | --- |
| `data(data?)` | Get or set the entity data. Returns the current data. |
| `match(match?)` | Get or set the entity match criteria. Returns the current match. |
| `load(match)` | Load a single entity by match criteria. |
| `list(match)` | List entities matching the criteria. Returns an array. |
| `create(data)` | Create a new entity with the given data. |
| `update(data)` | Update an existing entity with the given data. |
| `remove(match)` | Remove the entity matching the criteria. |
| `make()` | Create a new entity instance with the same options. |
| `client()` | Return the parent client instance. |
| `entopts()` | Return a copy of the entity options. |


### Direct API Access

The `direct` method allows you to call any API endpoint without
using the entity interface:

```ts
const result = await client.direct({
  path: '/api/v1/resource/{id}',
  method: 'GET',
  params: { id: 'abc123' },
  query: { fields: 'name,status' },
  headers: { 'X-Custom': 'value' },
  body: { key: 'value' },
})
```

The result object has the following shape:

```ts
{
  ok: boolean,     // true if status is 2xx
  status: number,  // HTTP status code
  headers: object, // Response headers
  data: any,       // Parsed JSON response body
}
```

Use the `prepare` method to build the fetch definition without
sending the request:

```ts
const fetchdef = await client.prepare({
  path: '/api/v1/resource',
  method: 'POST',
  body: { name: 'example' },
})

// fetchdef contains: { url, method, headers, body }
```


### Testing

Create a test client using the static `test` method. The test
client activates the test feature, which provides mock responses:

```ts
const client = SolardemoSDK.test()
```


## Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
