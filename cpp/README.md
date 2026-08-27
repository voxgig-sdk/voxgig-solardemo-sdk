# Solardemo C++ SDK



The C++ SDK for the Solardemo API — a header-only,
entity-oriented client following idiomatic modern C++ (C++17) conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `client->moon()` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low. Every value flows through a single dynamic
`sdk::Value` type (a JSON-like variant), so there is no schema-driven code to
regenerate when the API changes.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
The C++ SDK is **header-only** — there is no package to install
from a registry. Vendor the `cpp/` directory into your project (or add the
repository as a git submodule) and put it on your compiler's include path.
Releases are cut as the git tag `cpp/vX.Y.Z` (see
[Releases](https://github.com/voxgig-sdk/solardemo-sdk/releases)).

```bash
# Add the SDK as a submodule (or copy the cpp/ directory into your tree).
git submodule add <repo-url> third_party/solardemo-sdk
```

Then include the umbrella header and compile with C++17:

```cpp
#include "core/sdk.hpp"
```

```bash
g++ -std=c++17 -Ithird_party/solardemo-sdk/cpp your_app.cpp -o your_app
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and
loading a specific record.

### 1. Create a client

```cpp
#include "core/sdk.hpp"

using namespace sdk;

auto client = SolardemoSDK::create();
```

### 2. List moon records

`list()` returns an `sdk::Value` list and throws `sdk::SdkErrorPtr`
on error — iterate it directly.

```cpp
try {
  Value moons = client->moon()->list(Value::undef(), Value::undef());
  for (const auto& moon : *moons.as_list()) {
    std::cout << Struct::jsonify(moon) << std::endl;
  }
} catch (const SdkErrorPtr& err) {
  std::cerr << "list failed: " << err->msg << std::endl;
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`load()` returns the bare record and throws on error.

```cpp
try {
  Value moon = client->moon()->load(vmap({{"planet_id", Value("example_planet_id")}, {"id", Value("example_id")}}), Value::undef());
  std::cout << Struct::jsonify(moon) << std::endl;
} catch (const SdkErrorPtr& err) {
  std::cerr << "load failed: " << err->msg << std::endl;
}
```

### 4. Create, update, and remove

```cpp
// Create — returns the bare created record.
Value created = client->moon()->create(vmap({{"planet_id", Value("example_planet_id")}, {"diameter", Value(1)}, {"id", Value("example_id")}, {"kind", Value("example_kind")}, {"name", Value("example_name")}}), Value::undef());

// Update — reuse the created record's id
client->moon()->update(vmap({{"id", getp(created, "id")}, {"planet_id", Value("example_planet_id")}, {"diameter", Value(1)}}), Value::undef());

// Remove
client->moon()->remove(vmap({{"id", getp(created, "id")}, {"planet_id", Value("example_planet_id")}}), Value::undef());
```


## Error handling

Entity operations reject on failure, so wrap them in `try` / `catch`:

```ts
try {
  const moons = await client.Moon().list()
  console.log(moons)
} catch (err) {
  console.error('list failed:', err)
}
```

The low-level `direct()` method does **not** throw — it returns the
value or an `Error`, so check the result before using it:

```ts
const result = await client.direct({
  path: '/api/resource/{id}',
  method: 'GET',
  params: { id: 'example_id' },
})

if (result instanceof Error) {
  throw result
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```cpp
Value result = client->direct(vmap({
    {"path", Value("/api/resource/{id}")},
    {"method", Value("GET")},
    {"params", vmap({{"id", Value("example")}})},
}));

if (getp(result, "ok") == Value(true)) {
  std::cout << Helpers::toInt(getp(result, "status")) << std::endl;  // 200
  std::cout << Struct::jsonify(getp(result, "data")) << std::endl;   // response body
} else {
  // A non-2xx response carries status + data (the error body); a
  // transport-level failure carries err instead. Only one is present.
  std::cerr << Helpers::toInt(getp(result, "status")) << " "
            << Struct::jsonify(getp(result, "err")) << std::endl;
}
```

`direct()` is the escape hatch: it never throws — branch on
`getp(result, "ok")`.

### Prepare a request without sending it

```cpp
// prepare() returns the fetch definition and throws on error.
Value fetchdef = client->prepare(vmap({
    {"path", Value("/api/resource/{id}")},
    {"method", Value("DELETE")},
    {"params", vmap({{"id", Value("example")}})},
}));

std::cout << Struct::stringify(getp(fetchdef, "url")) << std::endl;
std::cout << Struct::stringify(getp(fetchdef, "method")) << std::endl;
std::cout << Struct::jsonify(getp(fetchdef, "headers")) << std::endl;
```

### Use test mode

Create a mock client for unit testing — no server required. The test
feature installs an in-memory mock transport:

```cpp
auto client = SolardemoSDK::testSDK();

// Entity ops return the bare record and throw on error.
Value moon = client->moon()->list(Value::undef(), Value::undef());
// moon contains the mock response record
std::cout << Struct::jsonify(moon) << std::endl;
```

You can seed the mock store by passing test options — see the generated
`test/` suite for worked examples.

### Run live tests

Create a `.env.local` file at the project root:

```
SOLARDEMO_TEST_LIVE=TRUE
```

Then build and run the test suite:

```bash
cd cpp && make test
```


## Reference

### SolardemoSDK

```cpp
#include "core/sdk.hpp"

using namespace sdk;

auto client = std::make_shared<SolardemoSDK>(options);
```

Creates a new SDK client. `options` is an `sdk::Value` map.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `std::string` | Base URL of the API server. |
| `prefix` | `std::string` | URL path prefix prepended to all requests. |
| `suffix` | `std::string` | URL path suffix appended to all requests. |
| `feature` | `Value` | Feature activation flags. |
| `system` | `Value` | System overrides. |

### testSDK

```cpp
auto client = SolardemoSDK::testSDK(testopts, sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be
`Value::undef()`; a no-arg `SolardemoSDK::testSDK()` overload is
also provided.

### SolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `optionsMap` | `() -> Value` | Deep copy of current SDK options. |
| `getUtility` | `() -> UtilityPtr` | Copy of the SDK utility object. |
| `prepare` | `(fetchargs) -> Value` | Build an HTTP request definition without sending. Throws on error. |
| `direct` | `(fetchargs) -> Value` | Build and send an HTTP request. Returns a result Value (branch on `ok`). |
| `moon` | `(entopts) -> std::shared_ptr<MoonEntity>` | Create a Moon entity instance. |
| `planet` | `(entopts) -> std::shared_ptr<PlanetEntity>` | Create a Planet entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `(reqmatch, ctrl) -> Value` | Load a single entity by match criteria. Throws on error. |
| `list` | `(reqmatch, ctrl) -> Value` | List entities matching the criteria (a Value list). Throws on error. |
| `create` | `(reqdata, ctrl) -> Value` | Create a new entity. Throws on error. |
| `update` | `(reqdata, ctrl) -> Value` | Update an existing entity. Throws on error. |
| `remove` | `(reqmatch, ctrl) -> Value` | Remove an entity. Throws on error. |
| `data` | `(arg) -> Value` | Get (no arg) or set (with arg) entity data. |
| `match` | `(arg) -> Value` | Get (no arg) or set (with arg) entity match criteria. |
| `make` | `() -> EntityPtr` | Create a new instance with the same options. |
| `getName` | `() -> std::string` | Return the entity name. |

### Result shape

Entity operations return the bare result data (a map `Value` for
single-entity ops, a list `Value` for `list`) and throw
`sdk::SdkErrorPtr` on error. Wrap calls in `try`/`catch` to handle
failures.

The `direct()` escape hatch never throws — it returns a result `Value`
you branch on via `getp(result, "ok")`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `bool` | `true` if the HTTP status is 2xx. |
| `status` | `int` | HTTP status code. |
| `headers` | `Value` | Response headers. |
| `data` | `Value` | Parsed JSON response body. |

On error, `ok` is `false` and `err` contains the error value.

### Entities

#### Moon

| Field | Description |
| --- | --- |
| `diameter` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `planet_id` |  |

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/moon`

#### Planet

| Field | Description |
| --- | --- |
| `diameter` |  |
| `forbid` |  |
| `id` |  |
| `kind` |  |
| `name` |  |
| `ok` |  |
| `start` |  |
| `state` |  |
| `stop` |  |
| `why` |  |

Operations: Create, List, Load, Remove, Update.

API path: `/api/planet/{planet_id}/forbid`



## Entities


### Moon

Create an instance: `auto moon = client->moon();`

#### Operations

| Method | Description |
| --- | --- |
| `create(data, ctrl)` | Create a new entity with the given data. |
| `list(match, ctrl)` | List entities, optionally matching the given criteria. |
| `load(match, ctrl)` | Load a single entity by match criteria. |
| `remove(match, ctrl)` | Remove the matching entity. |
| `update(data, ctrl)` | Update an existing entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `id` | `std::string` |  |
| `kind` | `std::string` |  |
| `name` | `std::string` |  |
| `planet_id` | `std::string` |  |

#### Example: Load

```cpp
Value moon = client->moon()->load(vmap({{"id", Value("moon_id")}, {"planet_id", Value("planet_id")}}), Value::undef());
```

#### Example: List

```cpp
Value moons = client->moon()->list(Value::undef(), Value::undef());
```

#### Example: Create

```cpp
Value moon = client->moon()->create(vmap({
    {"planet_id", Value("example_planet_id")},  // std::string
    {"diameter", Value(1)},  // double
    {"id", Value("example_id")},  // std::string
    {"kind", Value("example_kind")},  // std::string
    {"name", Value("example_name")},  // std::string
}), Value::undef());
```


### Planet

Create an instance: `auto planet = client->planet();`

#### Operations

| Method | Description |
| --- | --- |
| `create(data, ctrl)` | Create a new entity with the given data. |
| `list(match, ctrl)` | List entities, optionally matching the given criteria. |
| `load(match, ctrl)` | Load a single entity by match criteria. |
| `remove(match, ctrl)` | Remove the matching entity. |
| `update(data, ctrl)` | Update an existing entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `forbid` | `bool` |  |
| `id` | `std::string` |  |
| `kind` | `std::string` |  |
| `name` | `std::string` |  |
| `ok` | `bool` |  |
| `start` | `bool` |  |
| `state` | `std::string` |  |
| `stop` | `bool` |  |
| `why` | `std::string` |  |

#### Example: Load

```cpp
Value planet = client->planet()->load(vmap({{"id", Value("planet_id")}}), Value::undef());
```

#### Example: List

```cpp
Value planets = client->planet()->list(Value::undef(), Value::undef());
```

#### Example: Create

```cpp
Value planet = client->planet()->create(vmap({
    {"diameter", Value(1)},  // double
    {"id", Value("example_id")},  // std::string
    {"kind", Value("example_kind")},  // std::string
    {"name", Value("example_name")},  // std::string
}), Value::undef());
```


## Advanced

> The sections above cover everyday use. The material below explains the
> SDK's internals — useful when extending it with custom features, but not
> needed for normal use.

### The operation pipeline

Every entity operation follows a six-stage pipeline. Each stage fires a
feature hook before executing:

```
PrePoint → PreSpec → PreRequest → PreResponse → PreResult → PreDone
```

- **PrePoint**: Resolves which API endpoint to call based on the
  operation name and entity configuration.
- **PreSpec**: Builds the HTTP spec — URL, method, headers, body —
  from the resolved point and the caller's parameters.
- **PreRequest**: Sends the HTTP request. Features can intercept here
  to replace the transport (as TestFeature does with mocks).
- **PreResponse**: Parses the raw HTTP response.
- **PreResult**: Extracts the business data from the parsed response.
- **PreDone**: Final stage before returning to the caller. Entity
  state (match, data) is updated here.

If any stage errors, the pipeline short-circuits and the error surfaces
to the caller — see [Error handling](#error-handling) for how that looks
in this language.

### Features and hooks

Features are the extension mechanism. A feature is an object with a
`hooks` map. Each hook key is a pipeline stage name, and the value is
a function that receives the context.

The SDK ships with built-in features:

- **TestFeature**: In-memory mock transport for testing without a live server

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as `Value`

The C++ SDK uses a single dynamic `sdk::Value` type (a JSON-like variant
over string / number / bool / list / map) throughout rather than generated
typed structs. This mirrors the dynamic nature of the API and keeps the
SDK flexible — no code generation is needed when the API schema changes.

Build maps with `sdk::vmap({{"key", sdk::Value("v")}})` and lists with
`sdk::vlist({...})`; read fields back with `sdk::getp(value, "key")`. Use
`sdk::to_map()` to safely coerce a value that should be a map, and
`sdk::Struct::jsonify(value)` to render it as JSON.

### Directory structure

```
cpp/
├── core/                        -- Runtime type graph, config, generated client
├── entity/                      -- Per-entity client headers
├── feature/                     -- Built-in features (Base, Test, Log, ...)
├── utility/                     -- Operation pipeline + vendored struct library
├── test/                        -- Test suites
├── Makefile                     -- Build & run the tests (C++17)
└── VERSION                      -- SDK version
```

Include the umbrella header `core/sdk.hpp` to pull in the whole SDK: the
runtime types, the pipeline utilities, the vendored struct, the generated
config, the per-entity clients and the generated `SolardemoSDK`
client class. Everything lives in the `sdk` namespace.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally. Subsequent
calls on the same instance can rely on this state.

```ts
const moon = client.Moon()
await moon.list()

// moon.data() now returns the moon data from the last `list`
// moon.match() returns the last match criteria
```

Call `make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for standard CRUD operations.

The `direct` method gives full control over the HTTP request. Use it
for non-standard endpoints, bulk operations, or any path not modelled
as an entity. The `prepare` method is useful for debugging — it
shows exactly what `direct` would send.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
