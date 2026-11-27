# VoxgigSolardemo C SDK



The C SDK for the VoxgigSolardemo API — an entity-oriented client following idiomatic C conventions (explicit structs, function-pointer vtables, and a trailing `PNError**` out-param for errors).

The SDK exposes the API as semantic **Entities** — for example `voxgigsolardemo_moon(client, NULL)` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
C has no central package registry — a release is the git tag
(`c/vX.Y.Z`, see [Tags](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/tags)). Build from a
source checkout with the bundled `Makefile`; the voxgig struct library is
vendored under `utility/struct`, so there are no external dependencies to
fetch:

```bash
cd c && make          # builds libsdk.a
cd c && make test     # builds + runs the test binaries
```

Link your program against `libsdk.a` and the libraries `make -s ldlibs`
prints, and include `core/api.h`:

```bash
cc -I c/core -I c/utility/struct \
   myapp.c c/libsdk.a $(make -s -C c ldlibs) -o myapp
```

Every global name in `libsdk.a` carries this SDK's prefix
(`voxgigsolardemo_sdk_prepare`, `voxgigsolardemo_cmap`, ...), so one program can link several
generated SDKs. `make` maps each short name to its prefixed one in
`c/core/prefix.h`, which the SDK is compiled with, and each name its
headers declare in `c/core/prefix_api.h`, which `core/api.h` includes,
so your code keeps the short names and the SDK's private names never rename
your own. Include `core/api.h` before any other SDK header, and give each SDK
a source file of its own: the headers of two SDKs declare the same type names.


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and loading a specific record.

### 1. Create a client

```c
#include <stdio.h>
#include <stdlib.h>
#include "core/api.h"

PNError* err = NULL;
VoxgigSolardemoSDK* client = voxgigsolardemo_sdk_new(NULL, &err);
if (NULL == client) {
    fprintf(stderr, "%s\n", err->msg);
    exit(1);
}
```

### 2. List moon records

`list()` returns a `NULL`-terminated array of entities, one per record,
and sets `*err` on failure — check `err` after the call. `vt->data`
reads an entity's record.

```c
Entity* moon = voxgigsolardemo_moon(client, NULL);
Entity** moons = moon->vt->list(moon, cmap(1, "planet_id", v_str("example")), NULL, &err);
if (err) {
    fprintf(stderr, "list failed: %s\n", err->msg);
} else {
    for (size_t i = 0; moons[i]; i++) {
        printf("%s\n", voxgig_to_json(moons[i]->vt->data(moons[i], NULL)));
    }
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`load()` returns the entity and sets `*err` on failure; `vt->data` reads
its record.

```c
Entity* moon = voxgigsolardemo_moon(client, NULL);
Entity* loaded = moon->vt->load(moon, cmap(2, "planet_id", v_str("example_planet_id"), "id", v_str("example_id")), NULL, &err);
if (err) {
    fprintf(stderr, "load failed: %s\n", err->msg);
} else {
    printf("%s\n", voxgig_to_json(loaded->vt->data(loaded, NULL)));
}
```

### 4. Create, update, and remove

```c
// Create — returns the created entity, or NULL with *err set
Entity* created = moon->vt->create(moon, cmap(5, "planet_id", v_str("example_planet_id"), "diameter", v_num(1), "id", v_str("example_id"), "kind", v_str("example_kind"), "name", v_str("example_name")), NULL, &err);
voxgig_value* created_id = created
    ? getp(created->vt->data(created, NULL), "id") : v_undef();

// Update
moon->vt->update(moon, cmap(3, "id", created_id, "planet_id", v_str("example_planet_id"), "diameter", v_num(1)), NULL, &err);

// Remove
moon->vt->remove(moon, cmap(2, "id", created_id, "planet_id", v_str("example_planet_id")), NULL, &err);
```


## Error handling

Entity operations set `*err` on failure, so check `err` after each call:

```c
Entity* planet = voxgigsolardemo_planet(client, NULL);
PNError* err = NULL;
Entity** planets = planet->vt->list(planet, NULL, NULL, &err);
if (err) {
    fprintf(stderr, "list failed: %s\n", err->msg);
} else {
    for (size_t i = 0; planets[i]; i++) {
        printf("%s\n", voxgig_to_json(planets[i]->vt->data(planets[i], NULL)));
    }
}
```

`sdk_direct()` does **not** set `*err` for an error response — it
returns the result map. Branch on `ok`; on failure `status` holds the HTTP
status (for error responses) and `err` holds a transport error:

```c
PNError* err = NULL;
voxgig_value* result = sdk_direct(client, cmap(3,
    "path", v_str("/api/planet/{planet_id}/moon"),
    "method", v_str("GET"),
    "params", cmap(1, "planet_id", v_str("example_id"))), &err);

if (!voxgig_as_bool(getp(result, "ok"))) {
    fprintf(stderr, "request failed: %lld %s\n",
        (long long)to_int(getp(result, "status")), voxgig_to_json(getp(result, "err")));
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity operations:

```c
PNError* err = NULL;
voxgig_value* result = sdk_direct(client, cmap(3,
    "path", v_str("/api/planet/{planet_id}/moon"),
    "method", v_str("GET"),
    "params", cmap(1, "planet_id", v_str("example"))), &err);

if (voxgig_as_bool(getp(result, "ok"))) {
    printf("%lld\n", (long long)to_int(getp(result, "status")));  // 200
    printf("%s\n", voxgig_to_json(getp(result, "data")));         // response body
} else {
    // A non-2xx response carries status + data (the error body); a
    // transport-level failure carries err instead. Only one is present.
    printf("%s\n", voxgig_to_json(getp(result, "err")));
}
```

`sdk_direct()` never sets `*err` for a non-2xx response — it always returns
a result map you branch on via `getp(result, "ok")`.

### Prepare a request without sending it

```c
PNError* err = NULL;
voxgig_value* fetchdef = sdk_prepare(client, cmap(3,
    "path", v_str("/api/planet/{planet_id}/moon"),
    "method", v_str("GET"),
    "params", cmap(1, "planet_id", v_str("example"))), &err);

printf("%s\n", get_str(fetchdef, "url"));
printf("%s\n", get_str(fetchdef, "method"));
printf("%s\n", voxgig_to_json(getp(fetchdef, "headers")));
```

### Use test mode

Create a mock client for unit testing — no server required:

```c
VoxgigSolardemoSDK* client = test_sdk(NULL, NULL);
PNError* err = NULL;

// list returns one entity per mock record, and sets *err on failure.
Entity* planet = voxgigsolardemo_planet(client, NULL);
Entity** planets = planet->vt->list(planet, NULL, NULL, &err);
// planets[i]->vt->data(planets[i], NULL) is a mock record
```

### Send requests over HTTP and HTTPS

On a POSIX system the SDK sends each request itself: HTTP/1.1 on a
socket, one request per connection. It reads a response framed by
`Content-Length`, by chunks or by the connection closing, gives up on an
exchange 30 seconds after it starts to connect, refuses a response larger
than 32 MiB, and follows no redirect. Looking up the host comes before those
30 seconds, and is bounded by the system resolver alone. A failure to
connect, send or read is a `fetch_transport` error. On Windows there is no
default transport: supply `options.system.fetch`, described next.

`https://` binds the platform's OpenSSL: `make` uses it wherever its headers
are installed (`make TLS=openssl` insists on it), and a program linking
`libsdk.a` links what `make -s ldlibs` prints. The server's certificate is
verified against the system's trust store and its name against the host, and
nothing turns that off. A build made with `TLS=none` links no TLS library and
refuses every `https://` request. Two environment variables change what is
trusted:

- `VOXGIG_SOLARDEMO_CA_BUNDLE` names a PEM file of roots added to the system's.
- `VOXGIG_SOLARDEMO_TLS_PIN` is the SHA-256 fingerprint of the one certificate to trust
  in place of any store, for a local service with a self-signed certificate.
  `openssl x509 -noout -fingerprint -sha256 -in cert.pem` prints it, and the
  host name is still checked against that certificate.


### Use a custom fetch function

Replace the HTTP transport with your own function (the same shape the test
transport uses). A response is read through its `json` only when it carries
a `body`:

```c
static voxgig_value* mock_fetch(void* ud, voxgig_value* args) {
    (void)ud; (void)args;
    return cmap(5,
        "status", v_num(200),
        "statusText", v_str("OK"),
        "headers", v_map(),
        "body", v_str("{\"id\":\"mock01\"}"),
        "json", json_thunk(cmap(1, "id", v_str("mock01"))));
}

PNError* err = NULL;
VoxgigSolardemoSDK* client = voxgigsolardemo_sdk_new(cmap(2,
    "base", v_str("http://localhost:8080"),
    "system", cmap(1, "fetch", vfn(mock_fetch, NULL))), &err);
if (NULL == client) fprintf(stderr, "%s\n", err->msg);
```

### Point at a different server

Override the base URL to reach a local or staging server:

```c
PNError* err = NULL;
VoxgigSolardemoSDK* client = voxgigsolardemo_sdk_new(cmap(1,
    "base", v_str("http://localhost:8080")), &err);
if (NULL == client) fprintf(stderr, "%s\n", err->msg);
```

### Run the test suite

The generated suite runs offline, against the mock transport. This SDK
has no live tests.

```bash
cd c && make test
```


## Reference

### VoxgigSolardemoSDK

```c
#include "core/api.h"

PNError* err = NULL;
VoxgigSolardemoSDK* client = voxgigsolardemo_sdk_new(options, &err);
```

Creates a new SDK client. `options` is a `voxgig_value*` map (`NULL` for
none) carrying any of the following keys:

| Option | Value type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `headers` | `map` | Headers sent with every request. |
| `feature` | `map` | Feature activation flags. |
| `system` | `map` | System overrides, such as a custom fetch function. |

### test_sdk

```c
VoxgigSolardemoSDK* client = test_sdk(testopts, sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be
`NULL`.

### VoxgigSolardemoSDK functions

| Function | Signature | Description |
| --- | --- | --- |
| `sdk_prepare` | `(VoxgigSolardemoSDK*, fetchargs, PNError**) -> voxgig_value*` | Build an HTTP request definition without sending. |
| `sdk_direct` | `(VoxgigSolardemoSDK*, fetchargs, PNError**) -> voxgig_value*` | Build and send an HTTP request. Returns a result map (branch on `ok`). |
| `voxgigsolardemo_moon` | `(VoxgigSolardemoSDK*, entopts) -> Entity*` | Create a Moon entity instance. |
| `voxgigsolardemo_planet` | `(VoxgigSolardemoSDK*, entopts) -> Entity*` | Create a Planet entity instance. |

### Entity interface (vtable)

All entities share the same `EntityVT` vtable, reached via `e->vt->...`.

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `(Entity*, reqmatch, ctrl, PNError**) -> Entity*` | Load a single entity by match criteria. |
| `list` | `(Entity*, reqmatch, ctrl, PNError**) -> Entity**` | List entities matching the criteria: a `NULL`-terminated array, one per record. |
| `create` | `(Entity*, reqdata, ctrl, PNError**) -> Entity*` | Create a new entity. |
| `update` | `(Entity*, reqdata, ctrl, PNError**) -> Entity*` | Update an existing entity. |
| `remove` | `(Entity*, reqmatch, ctrl, PNError**) -> Entity*` | Remove an entity, which is returned marked as deleted. |
| `data` | `(Entity*, args) -> voxgig_value*` | Get entity data (pass a map to set). |
| `matchv` | `(Entity*, args) -> voxgig_value*` | Get entity match criteria (pass a map to set). |
| `make` | `(Entity*) -> Entity*` | Create a new instance with the same options. |
| `get_name` | `(Entity*) -> const char*` | Return the entity name. |

### Result shape

Entity operations return the entity, and `list` a `NULL`-terminated array
of entities, one per record; `vt->data` reads an entity's record. On
failure they return `NULL` and set `*err` to a `PNError*`. Always
initialise `PNError* err = NULL;` and check it after the call.

The `sdk_direct()` escape hatch never sets `*err` for a non-2xx response —
it returns a result map you branch on via `getp(result, "ok")`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `bool` | `true` if the HTTP status is 2xx. |
| `status` | `number` | HTTP status code. |
| `headers` | `map` | Response headers. |
| `data` | `any` | Parsed JSON response body. |

On error, `ok` is `false` and `err` carries the error value.

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

Create an instance: `Entity* moon = voxgigsolardemo_moon(client, NULL);`

#### Operations

| Method | Description |
| --- | --- |
| `Entity** vt->list(e, reqmatch, ctrl, &err)` | List entities, optionally matching the given criteria: a `NULL`-terminated array, one per record. |
| `Entity* vt->load(e, reqmatch, ctrl, &err)` | Load a single entity by match criteria. |
| `Entity* vt->create(e, reqdata, ctrl, &err)` | Create a new entity with the given data. |
| `Entity* vt->update(e, reqdata, ctrl, &err)` | Update an existing entity. |
| `Entity* vt->remove(e, reqmatch, ctrl, &err)` | Remove the matching entity, which is returned marked as deleted. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `id` | `char*` |  |
| `kind` | `char*` |  |
| `name` | `char*` |  |
| `planet_id` | `char*` |  |

#### Example: Load

```c
Entity* moon = voxgigsolardemo_moon(client, NULL);
Entity* loaded = moon->vt->load(moon, cmap(2, "id", v_str("moon_id"), "planet_id", v_str("planet_id")), NULL, &err);
if (loaded) {
    printf("%s\n", voxgig_to_json(loaded->vt->data(loaded, NULL)));
}
```

#### Example: List

```c
Entity* moon = voxgigsolardemo_moon(client, NULL);
Entity** moons = moon->vt->list(moon, cmap(1, "planet_id", v_str("example")), NULL, &err);
for (size_t i = 0; moons && moons[i]; i++) {
    printf("%s\n", voxgig_to_json(moons[i]->vt->data(moons[i], NULL)));
}
```

#### Example: Create

```c
Entity* moon = voxgigsolardemo_moon(client, NULL);
Entity* created = moon->vt->create(moon, cmap(5,
    "planet_id", v_str("example_planet_id"),  // char*
    "diameter", v_num(1),  // double
    "id", v_str("example_id"),  // char*
    "kind", v_str("example_kind"),  // char*
    "name", v_str("example_name"))  // char*
, NULL, &err);
```


### Planet

Create an instance: `Entity* planet = voxgigsolardemo_planet(client, NULL);`

#### Operations

| Method | Description |
| --- | --- |
| `Entity** vt->list(e, reqmatch, ctrl, &err)` | List entities, optionally matching the given criteria: a `NULL`-terminated array, one per record. |
| `Entity* vt->load(e, reqmatch, ctrl, &err)` | Load a single entity by match criteria. |
| `Entity* vt->create(e, reqdata, ctrl, &err)` | Create a new entity with the given data. |
| `Entity* vt->update(e, reqdata, ctrl, &err)` | Update an existing entity. |
| `Entity* vt->remove(e, reqmatch, ctrl, &err)` | Remove the matching entity, which is returned marked as deleted. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `double` |  |
| `forbidReason` | `char*` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `char*` | Set by the forbid action, and absent until it first runs. |
| `id` | `char*` |  |
| `kind` | `char*` |  |
| `name` | `char*` |  |
| `terraformState` | `char*` | Set by the terraform action, and absent until it first runs. |

#### Example: Load

```c
Entity* planet = voxgigsolardemo_planet(client, NULL);
Entity* loaded = planet->vt->load(planet, cmap(1, "id", v_str("planet_id")), NULL, &err);
if (loaded) {
    printf("%s\n", voxgig_to_json(loaded->vt->data(loaded, NULL)));
}
```

#### Example: List

```c
Entity* planet = voxgigsolardemo_planet(client, NULL);
Entity** planets = planet->vt->list(planet, NULL, NULL, &err);
for (size_t i = 0; planets && planets[i]; i++) {
    printf("%s\n", voxgig_to_json(planets[i]->vt->data(planets[i], NULL)));
}
```

#### Example: Create

```c
Entity* planet = voxgigsolardemo_planet(client, NULL);
Entity* created = planet->vt->create(planet, cmap(4,
    "diameter", v_num(1),  // double
    "id", v_str("example_id"),  // char*
    "kind", v_str("example_kind"),  // char*
    "name", v_str("example_name"))  // char*
, NULL, &err);
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

Features are the extension mechanism. A feature is a struct whose first
member is a `Feature` holding its vtable. The vtable's `hook` function
receives each pipeline stage's name and the context.

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

### Data as `voxgig_value*`

The C SDK uses a single dynamic `voxgig_value*` type throughout rather than
a typed struct per entity. `voxgig_value` is the vendored voxgig struct
port (a JSON-shaped tagged union: string, number, bool, list, map, null,
undef). This mirrors the dynamic nature of the API and keeps the SDK
flexible: code that works with `voxgig_value` needs no regeneration when
the API schema changes. The typed models in `entity/types.h` follow the
schema only when the SDK is regenerated.

Build request maps with the `cmap` / `clist` / `v_str` / `v_num` /
`v_bool` helper builders, and read fields back with `getp` (or the typed
`get_str` / `get_bool` / `to_int`); use `to_map` to safely coerce a
value to a map.

Memory follows a retain-heavy, never-free discipline — pipeline values are
never released. This is safe (no use-after-free) and leaks are acceptable
for the short-lived SDK and test binaries.

### Error handling

Fallible functions return a `voxgig_value*` (or a struct pointer) and take a
trailing `PNError** err` out-param. On success `*err` is left `NULL`; on
failure `*err` points to a heap `PNError` carrying `code` and `msg`.
Always initialise `PNError* err = NULL;` and branch on it after each call.

### Project structure

```
c/
├── core/          -- Pipeline types, config, client (client.c), api.h + sdk.h
├── entity/        -- Per-entity implementations (one .c each)
├── feature/       -- Feature implementations
├── utility/       -- Utilities + the vendored voxgig struct port (utility/struct)
├── tests/         -- Test binaries (each a standalone main())
└── Makefile       -- Builds libsdk.a and runs every tests/*.c
```

The public entry header is `core/api.h` — it includes `core/sdk.h` (the
umbrella runtime header) and declares each entity's constructor and SDK
accessor. Include it and link against `libsdk.a`.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally.

```c
Entity* planet = voxgigsolardemo_planet(client, NULL);
PNError* err = NULL;
planet->vt->list(planet, NULL, NULL, &err);

// planet->vt->data(planet, NULL) now returns the planet data from the last list
// planet->vt->matchv(planet, NULL) returns the last match criteria
```

Call `vt->make` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for the operations each
entity declares.

`sdk_direct()` gives full control over the HTTP request. Use it for
non-standard endpoints, bulk operations, or any path not modelled as
an entity. `sdk_prepare()` builds the request without sending it — useful
for debugging or custom transport.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
