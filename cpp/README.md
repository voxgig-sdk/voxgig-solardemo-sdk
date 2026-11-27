# VoxgigSolardemo C++ SDK



The C++ SDK for the VoxgigSolardemo API — a header-only,
entity-oriented client following idiomatic modern C++ (C++17) conventions.

The SDK exposes the API as semantic **Entities** — for example `client->moon()` — each
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
[Tags](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/tags)).

```bash
# Add the SDK as a submodule (or copy the cpp/ directory into your tree).
git submodule add https://github.com/voxgig-sdk/voxgig-solardemo-sdk third_party/voxgigsolardemo-sdk
```

Then include the umbrella header and compile with C++17:

```cpp
#include "core/sdk.hpp"
```

```bash
g++ -std=c++17 -Ithird_party/voxgigsolardemo-sdk/cpp your_app.cpp -o your_app
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and loading a specific record.

### 1. Create a client

```cpp
#include "core/sdk.hpp"

using namespace sdk;

auto client = VoxgigSolardemoSDK::create();
```

### 2. List moon records

`list()` returns a `std::vector` of entities, one per record, and throws
`sdk::SdkErrorPtr` on error; `data()` reads an entity's record.

```cpp
try {
  std::vector<SdkEntityPtr> moons = client->moon()->list(vmap({{"planet_id", Value("example")}}), Value::undef());
  for (const auto& moon : moons) {
    std::cout << Struct::jsonify(moon->data()) << std::endl;
  }
} catch (const SdkErrorPtr& err) {
  std::cerr << "list failed: " << err->msg << std::endl;
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`load()` returns the entity and throws on error; `data()` reads its record.

```cpp
try {
  SdkEntityPtr moon = client->moon()->load(vmap({{"planet_id", Value("example_planet_id")}, {"id", Value("example_id")}}), Value::undef());
  std::cout << Struct::jsonify(moon->data()) << std::endl;
} catch (const SdkErrorPtr& err) {
  std::cerr << "load failed: " << err->msg << std::endl;
}
```

### 4. Create, update, and remove

```cpp
// Create — returns the created entity.
SdkEntityPtr created = client->moon()->create(vmap({{"planet_id", Value("example_planet_id")}, {"diameter", Value(1)}, {"id", Value("example_id")}, {"kind", Value("example_kind")}, {"name", Value("example_name")}}), Value::undef());

// Update — reuse the created record's id
client->moon()->update(vmap({{"id", getp(created->data(), "id")}, {"planet_id", Value("example_planet_id")}, {"diameter", Value(1)}}), Value::undef());

// Remove
client->moon()->remove(vmap({{"id", getp(created->data(), "id")}, {"planet_id", Value("example_planet_id")}}), Value::undef());
```


## Error handling

Entity operations throw `SdkErrorPtr` on failure, so wrap them in `try` / `catch`:

```cpp
try {
  std::vector<SdkEntityPtr> planets = client->planet()->list(Value::undef(), Value::undef());
  for (const auto& planet : planets) {
    std::cout << Struct::jsonify(planet->data()) << std::endl;
  }
} catch (const SdkErrorPtr& err) {
  std::cerr << "list failed: " << err->msg << std::endl;
}
```

`direct()` does **not** throw — it
returns the result `Value`. Branch on `ok`; on failure `status` holds the HTTP
status (for error responses) and `err` holds a transport error:

```cpp
Value result = client->direct(vmap({
    {"path", Value("/api/planet/{planet_id}/moon")},
    {"method", Value("GET")},
    {"params", vmap({{"planet_id", Value("example_id")}})},
}));

if (!(getp(result, "ok") == Value(true))) {
  std::cerr << "request failed: " << Helpers::toInt(getp(result, "status")) << " "
            << Struct::jsonify(getp(result, "err")) << std::endl;
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```cpp
Value result = client->direct(vmap({
    {"path", Value("/api/planet/{planet_id}/moon")},
    {"method", Value("GET")},
    {"params", vmap({{"planet_id", Value("example")}})},
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
    {"path", Value("/api/planet/{planet_id}/moon")},
    {"method", Value("GET")},
    {"params", vmap({{"planet_id", Value("example")}})},
}));

std::cout << Struct::stringify(getp(fetchdef, "url")) << std::endl;
std::cout << Struct::stringify(getp(fetchdef, "method")) << std::endl;
std::cout << Struct::jsonify(getp(fetchdef, "headers")) << std::endl;
```

### Use test mode

Create a mock client for unit testing — no server required. The test
feature installs an in-memory mock transport:

```cpp
auto client = VoxgigSolardemoSDK::testSDK();

// list returns one entity per mock record, and throws on error.
for (const auto& planet : client->planet()->list(Value::undef(), Value::undef())) {
  std::cout << Struct::jsonify(planet->data()) << std::endl;
}
```

You can seed the mock store by passing test options — see the generated
`test/` suite for worked examples.

### Run live tests

Create a `.env.local` file at the project root:

```
VOXGIG_SOLARDEMO_TEST_LIVE=TRUE
```

Each entity's tests also read `VOXGIG_SOLARDEMO_TEST_<ENTITY>_ENTID`, with the
entity's name in capitals: a JSON object of the ids of existing records, for
the tests that do not create their own.

The SDK has no HTTP transport of its own: a client sends nothing until it
is given a `system.fetch`. The entity tests build their live client from
these variables without one, so a live run fails at its first request with
`fetch_no_transport`.

Then build and run the test suite:

```bash
cd cpp && make test
```


## Reference

### VoxgigSolardemoSDK

```cpp
#include "core/sdk.hpp"

using namespace sdk;

auto client = std::make_shared<VoxgigSolardemoSDK>(options);
```

Creates a new SDK client. `options` is an `sdk::Value` map.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `std::string` | Base URL of the API server. |
| `prefix` | `std::string` | URL path prefix prepended to all requests. |
| `suffix` | `std::string` | URL path suffix appended to all requests. |
| `headers` | `Value` | Headers sent with every request. |
| `feature` | `Value` | Feature activation flags. |
| `system` | `Value` | System overrides, such as a custom fetch function. |

### testSDK

```cpp
auto client = VoxgigSolardemoSDK::testSDK(testopts, sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be
`Value::undef()`; a no-arg `VoxgigSolardemoSDK::testSDK()` overload is
also provided.

### VoxgigSolardemoSDK methods

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
| `load` | `(reqmatch, ctrl) -> SdkEntityPtr` | Load a single entity by match criteria. Throws on error. |
| `list` | `(reqmatch, ctrl) -> std::vector<SdkEntityPtr>` | List entities matching the criteria, one per record. Throws on error. |
| `create` | `(reqdata, ctrl) -> SdkEntityPtr` | Create a new entity. Throws on error. |
| `update` | `(reqdata, ctrl) -> SdkEntityPtr` | Update an existing entity. Throws on error. |
| `remove` | `(reqmatch, ctrl) -> SdkEntityPtr` | Remove an entity, which is returned marked as deleted. Throws on error. |
| `data` | `(arg) -> Value` | Get (no arg) or set (with arg) entity data. |
| `match` | `(arg) -> Value` | Get (no arg) or set (with arg) entity match criteria. |
| `make` | `() -> EntityPtr` | Create a new instance with the same options. |
| `getName` | `() -> std::string` | Return the entity name. |

### Result shape

Entity operations return the entity, and `list` a `std::vector` of
entities, one per record; `data()` reads an entity's record. They throw
`sdk::SdkErrorPtr` on error, so wrap calls in `try`/`catch` to handle
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

Operations: list, load, create, update, remove.

API path: `/api/planet/{planet_id}/moon`

#### Planet

| Field | Description |
| --- | --- |
| `diameter` |  |
| `forbidReason` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | Set by the forbid action, and absent until it first runs. |
| `id` |  |
| `kind` |  |
| `name` |  |
| `terraformState` | Set by the terraform action, and absent until it first runs. |

Operations: list, load, create, update, remove.

API path: `/api/planet`



## Entities


### Moon

Create an instance: `auto moon = client->moon();`

#### Operations

| Method | Description |
| --- | --- |
| `list(match, ctrl) -> std::vector<SdkEntityPtr>` | List entities, optionally matching the given criteria: one entity per record. |
| `load(match, ctrl) -> SdkEntityPtr` | Load a single entity by match criteria. |
| `create(data, ctrl) -> SdkEntityPtr` | Create a new entity with the given data. |
| `update(data, ctrl) -> SdkEntityPtr` | Update an existing entity. |
| `remove(match, ctrl) -> SdkEntityPtr` | Remove the matching entity, which is returned marked as deleted. |

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
SdkEntityPtr moon = client->moon()->load(vmap({{"id", Value("moon_id")}, {"planet_id", Value("planet_id")}}), Value::undef());
std::cout << Struct::jsonify(moon->data()) << std::endl;
```

#### Example: List

```cpp
std::vector<SdkEntityPtr> moons = client->moon()->list(vmap({{"planet_id", Value("example")}}), Value::undef());
for (const auto& moon : moons) {
  std::cout << Struct::jsonify(moon->data()) << std::endl;
}
```

#### Example: Create

```cpp
SdkEntityPtr moon = client->moon()->create(vmap({
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
| `list(match, ctrl) -> std::vector<SdkEntityPtr>` | List entities, optionally matching the given criteria: one entity per record. |
| `load(match, ctrl) -> SdkEntityPtr` | Load a single entity by match criteria. |
| `create(data, ctrl) -> SdkEntityPtr` | Create a new entity with the given data. |
| `update(data, ctrl) -> SdkEntityPtr` | Update an existing entity. |
| `remove(match, ctrl) -> SdkEntityPtr` | Remove the matching entity, which is returned marked as deleted. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `forbidReason` | `std::string` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `std::string` | Set by the forbid action, and absent until it first runs. |
| `id` | `std::string` |  |
| `kind` | `std::string` |  |
| `name` | `std::string` |  |
| `terraformState` | `std::string` | Set by the terraform action, and absent until it first runs. |

#### Example: Load

```cpp
SdkEntityPtr planet = client->planet()->load(vmap({{"id", Value("planet_id")}}), Value::undef());
std::cout << Struct::jsonify(planet->data()) << std::endl;
```

#### Example: List

```cpp
std::vector<SdkEntityPtr> planets = client->planet()->list(Value::undef(), Value::undef());
for (const auto& planet : planets) {
  std::cout << Struct::jsonify(planet->data()) << std::endl;
}
```

#### Example: Create

```cpp
SdkEntityPtr planet = client->planet()->create(vmap({
    {"diameter", Value(1)},  // double
    {"id", Value("example_id")},  // std::string
    {"kind", Value("example_kind")},  // std::string
    {"name", Value("example_name")},  // std::string
}), Value::undef());
```

## Features

This SDK ships 9 optional features.
Each is **inactive until you switch it on**, so an SDK you have not
configured behaves exactly as if none of them existed, with no measurable overhead.

Activate a feature by name in the `feature` client option:

| Feature | What it does |
|---|---|
| [`debug`](#debug) | Debug capture |
| [`idempotency`](#idempotency) | Idempotency |
| [`metrics`](#metrics) | Metrics |
| [`paging`](#paging) | Paging |
| [`ratelimit`](#ratelimit) | Rate limiting |
| [`retry`](#retry) | Retry |
| [`secrets`](#secrets) | Secrets |
| [`test`](#test) | Test transport |
| [`timeout`](#timeout) | Timeout |

> **Order matters for `ratelimit`, `retry`, `secrets`, `timeout`.** These wrap the
> transport, so each one wraps whatever is already installed: the order you
> activate them in IS the nesting order. Activating them as an ordered list
> rather than a map is what fixes that order.

### debug

Debug capture.

| Option | Default |
|---|---|
| `active` | `false` |
| `max` | `100` |
| `redact` | `['authorization', 'cookie', 'set-cookie', 'api-key', 'apikey', 'x-api-key', 'idempotency-key']` |

Set `feature.debug.active` to enable it, then override any of the options above.

### idempotency

Idempotency.

| Option | Default |
|---|---|
| `active` | `false` |
| `header` | `'Idempotency-Key'` |
| `methods` | `['POST', 'PUT', 'PATCH', 'DELETE']` |
| `ops` | `['create', 'update', 'remove']` |

Set `feature.idempotency.active` to enable it, then override any of the options above.

### metrics

Metrics.

| Option | Default |
|---|---|
| `active` | `false` |

Set `feature.metrics.active` to enable it, then override any of the options above.

### paging

Paging.

| Option | Default |
|---|---|
| `active` | `false` |
| `afterVar` | `'after'` |
| `cursorParam` | `'cursor'` |
| `firstVar` | `'first'` |
| `limitParam` | `'limit'` |
| `pageParam` | `'page'` |
| `startPage` | `1` |

Set `feature.paging.active` to enable it, then override any of the options above.

### ratelimit

Rate limiting.

| Option | Default |
|---|---|
| `active` | `false` |
| `burst` | `5` |
| `rate` | `5` |

Set `feature.ratelimit.active` to enable it, then override any of the options above.

`ratelimit` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.

### retry

Retry.

| Option | Default |
|---|---|
| `active` | `false` |
| `factor` | `2` |
| `maxDelay` | `2000` |
| `minDelay` | `50` |
| `retries` | `2` |
| `statuses` | `[408, 425, 429, 500, 502, 503, 504]` |

Set `feature.retry.active` to enable it, then override any of the options above.

`retry` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.

### secrets

Secrets.

| Option | Default |
|---|---|
| `active` | `false` |
| `cache` | `true` |
| `exchange` | `{active: false, method: 'POST', path: 'auth/token', redirect: 'refuse', refresh: '', request: 'refresh_token', response: 'access_token', retries: 1, statuses: [401]}` |
| `name` | `'apikey'` |
| `providers` | `[]` |

Set `feature.secrets.active` to enable it, then override any of the options above.

`secrets` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.

### test

Test transport.

| Option | Default |
|---|---|
| `active` | `false` |

Set `feature.test.active` to enable it, then override any of the options above.

### timeout

Timeout.

| Option | Default |
|---|---|
| `active` | `false` |
| `ms` | `30000` |

Set `feature.timeout.active` to enable it, then override any of the options above.

`timeout` wraps the transport, so its position among the other
transport features decides what it sees. A feature activated later wraps one
activated earlier.


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

- **PrePoint**: Resolves which API endpoint to call based on the operation name and entity configuration.
- **PreSpec**: Builds the HTTP spec — URL, method, headers, body — from the resolved point and the caller's parameters.
- **PreRequest**: Sends the HTTP request. Features can intercept here to replace the transport.
- **PreResponse**: Parses the raw HTTP response.
- **PreResult**: Extracts the business data from the parsed response.
- **PreDone**: Final stage before returning to the caller. Entity state (match, data) is updated here.

If any stage errors, the pipeline short-circuits and the error surfaces
to the caller — see [Error handling](#error-handling) for how that looks
in this language.

### Features and hooks

Features are the extension mechanism. A feature is a class derived from
`Feature` that overrides a method per pipeline stage (e.g. `prePoint`,
`preSpec`). Each method receives the context.

The SDK ships with built-in features:

- **DebugFeature**: Debug capture
- **IdempotencyFeature**: Idempotency
- **MetricsFeature**: Metrics
- **PagingFeature**: Paging
- **RatelimitFeature**: Rate limiting
- **RetryFeature**: Retry
- **SecretsFeature**: Secrets
- **TestFeature**: Test transport
- **TimeoutFeature**: Timeout

Features are initialized in order. Hooks fire in the order features
were added, so later features can override earlier ones.

### Data as `Value`

The C++ SDK uses a single dynamic `sdk::Value` type (a JSON-like variant
over string / number / bool / list / map) throughout rather than generated
typed structs. This mirrors the dynamic nature of the API and keeps the
SDK flexible: code that works with `sdk::Value` needs no regeneration
when the API schema changes. The typed models in
`voxgigsolardemo_types.hpp` follow the schema only when the
SDK is regenerated.

Build maps with `sdk::vmap({{"key", sdk::Value("v")}})` and lists with
`sdk::vlist({...})`; read fields back with `sdk::getp(value, "key")`. Use
`sdk::to_map()` to safely coerce a value that should be a map, and
`sdk::Struct::jsonify(value)` to render it as JSON.

### Directory structure

```
cpp/
├── core/                        -- Runtime type graph, config, generated client
├── entity/                      -- Per-entity client headers
├── feature/                     -- Feature implementations
├── utility/                     -- Operation pipeline + vendored struct library
├── test/                        -- Test suites
├── Makefile                     -- Build & run the tests (C++17)
└── VERSION                      -- SDK version
```

Include the umbrella header `core/sdk.hpp` to pull in the whole SDK: the
runtime types, the pipeline utilities, the vendored struct, the generated
config, the per-entity clients and the generated `VoxgigSolardemoSDK`
client class. Everything lives in the `sdk` namespace.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally.

```cpp
auto planet = client->planet();
planet->list(Value::undef(), Value::undef());

// planet->data() now returns the planet data from the last list
// planet->match() returns the last match criteria
```

Call `make()` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for the operations each
entity declares.

`direct()` gives full control over the HTTP request. Use it for
non-standard endpoints, bulk operations, or any path not modelled as
an entity. `prepare()` builds the request without sending it — useful
for debugging or custom transport.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
