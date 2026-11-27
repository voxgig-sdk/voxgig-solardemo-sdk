# VoxgigSolardemo Perl SDK



The Perl SDK for the VoxgigSolardemo API — an entity-oriented client
following idiomatic Perl conventions.

The SDK exposes the API as capitalised, semantic **Entities** — for example `$client->Moon` — each
carrying a small, uniform set of operations (`list`, `load`, `create`, `update`, `remove`) instead of raw URL
paths and query strings. You work with named resources and verbs, which
keeps the cognitive load low.

> Other languages, the CLI, and MCP server live alongside this one — see
> the [top-level README](../README.md).


## Install
The SDK needs perl 5.36 or later.

This package is not yet published to CPAN. Install it from the GitHub
release tag (`perl/vX.Y.Z`, see [Tags](https://github.com/voxgig-sdk/voxgig-solardemo-sdk/tags)) or
from a source checkout.

The SDK is pure Perl with zero non-core runtime dependencies, so no build
step is required — just put its `lib` directory on `@INC`:

```perl
use lib 'lib';
use VoxgigSolardemoSDK;
```


## Tutorial: your first API call

This tutorial walks through creating a client, listing entities, and loading a specific record.

### 1. Create a client

```perl
use lib 'lib';
use VoxgigSolardemoSDK;

my $client = VoxgigSolardemoSDK->new;
```

### 2. List moon records

`list()` returns an `arrayref` of entities, one per record, and dies on
error; `data_get` reads each record.

```perl
my $moons = eval { $client->Moon->list({ 'planet_id' => 'example' }) };
if (my $err = $@) {
    print "list failed: $err\n";
}
else {
    for my $moon (@$moons) {
        print $moon->data_get->{id}, "\n";
    }
}
```

### 3. Load a moon

Moon is nested under planet, so provide the `planet_id`.
`load()` returns the ENTITY — call data_get for the record — and dies on error.

```perl
my $moon = eval { $client->Moon->load({ 'planet_id' => 'example_planet_id', 'id' => 'example_id' }) };
if (my $err = $@) {
    print "load failed: $err\n";
}
else {
    print $moon->data_get->{id}, "\n";
}
```

### 4. Create, update, and remove

```perl
# Create — returns the ENTITY (call data_get for the record)
my $created = $client->Moon->create({ 'planet_id' => 'example_planet_id', 'diameter' => 1, 'id' => 'example_id', 'kind' => 'example_kind', 'name' => 'example_name' });

# Update — the created entity's record holds its id
$client->Moon->update({ 'id' => $created->data_get->{id}, 'planet_id' => 'example_planet_id', 'diameter' => 1 });

# Remove
$client->Moon->remove({ 'id' => $created->data_get->{id}, 'planet_id' => 'example_planet_id' });
```


## Error handling

Entity operations die on failure, so wrap them in `eval` and check `$@`:

```perl
my $planets = eval { $client->Planet->list() };
if (my $err = $@) {
    warn "list failed: $err";
}
```

`direct` does **not** die — it
returns the result hashref. Branch on `ok`; on failure `status` holds the HTTP
status (for error responses) and `err` holds a transport error:

```perl
my $result = $client->direct({
    'path' => '/api/planet/{planet_id}/moon',
    'method' => 'GET',
    'params' => { 'planet_id' => 'example_id' },
});

unless ($result->{ok}) {
    warn 'request failed: ', ($result->{status} // ''), ' ', ($result->{err} // ''), "\n";
}
```


## How-to guides

### Make a direct HTTP request

For endpoints not covered by entity methods:

```perl
my $result = $client->direct({
    'path' => '/api/planet/{planet_id}/moon',
    'method' => 'GET',
    'params' => { 'planet_id' => 'example' },
});

if ($result->{ok}) {
    print $result->{status}, "\n";  # 200
    print $result->{data}, "\n";    # response body
}
else {
    # A non-2xx response carries status + data (the error body); a
    # transport-level failure carries err instead. Only one is present, so
    # read whichever is defined.
    print $result->{status}, ' ', ($result->{err} // ''), "\n";
}
```

### Prepare a request without sending it

```perl
# prepare() returns the fetch definition and dies on error.
my $fetchdef = $client->prepare({
    'path' => '/api/planet/{planet_id}/moon',
    'method' => 'GET',
    'params' => { 'planet_id' => 'example' },
});

print $fetchdef->{url}, "\n";
print $fetchdef->{method}, "\n";
print $fetchdef->{headers}, "\n";
```

### Use test mode

Create a mock client for unit testing — no server required:

```perl
my $client = VoxgigSolardemoSDK->test(undef, undef);

# Entity ops return the entity, and list one per record; they die on error.
my $planet = $client->Planet->list();
# data_get on an entity reads its mock response record
```

### Use a custom fetch function

Replace the HTTP transport with your own coderef:

```perl
my $mock_fetch = sub {
    my ($url, $init) = @_;
    return ({
        'status' => 200,
        'statusText' => 'OK',
        'headers' => {},
        'json' => sub { { 'id' => 'mock01' } },
    }, undef);
};

my $client = VoxgigSolardemoSDK->new({
    'base' => 'http://localhost:8080',
    'system' => { 'fetch' => $mock_fetch },
});
```

### Run live tests

Create a `.env.local` file at the project root:

```
VOXGIG_SOLARDEMO_TEST_LIVE=TRUE
```

Each entity's tests also read `VOXGIG_SOLARDEMO_TEST_<ENTITY>_ENTID`, with the
entity's name in capitals: a JSON object of the ids of existing records, for
the tests that do not create their own.

Then run:

```bash
cd perl && prove -Ilib t/
```


## Reference

### VoxgigSolardemoSDK

```perl
use lib 'lib';
use VoxgigSolardemoSDK;

my $client = VoxgigSolardemoSDK->new($options);
```

Creates a new SDK client.

| Option | Type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL of the API server. |
| `prefix` | `string` | URL path prefix prepended to all requests. |
| `suffix` | `string` | URL path suffix appended to all requests. |
| `headers` | `hashref` | Headers sent with every request. |
| `feature` | `hashref` | Feature activation flags. |
| `extend` | `arrayref` | Additional feature instances to load. |
| `system` | `hashref` | System overrides, such as a custom fetch function. |

### test

```perl
my $client = VoxgigSolardemoSDK->test($testopts, $sdkopts);
```

Creates a test-mode client with mock transport. Both arguments may be `undef`.

### VoxgigSolardemoSDK methods

| Method | Signature | Description |
| --- | --- | --- |
| `options_map` | `() -> hashref` | Deep copy of current SDK options. |
| `get_utility` | `() -> utility` | Copy of the SDK utility object. |
| `prepare` | `($fetchargs) -> hashref` | Build an HTTP request definition without sending. Dies on error. |
| `direct` | `($fetchargs) -> hashref` | Build and send an HTTP request. Returns a result hashref (branch on `ok`). |
| `Moon` | `($data) -> Moon entity` | Create a Moon entity instance. |
| `Planet` | `($data) -> Planet entity` | Create a Planet entity instance. |

### Entity interface

All entities share the same interface.

| Method | Signature | Description |
| --- | --- | --- |
| `load` | `($reqmatch, $ctrl) -> entity` | Load a single entity by match criteria, and return it. Dies on error. |
| `list` | `($reqmatch, $ctrl) -> arrayref` | List entities matching the criteria, one per record. Dies on error. |
| `create` | `($reqdata, $ctrl) -> entity` | Create a new entity, and return it. Dies on error. |
| `update` | `($reqdata, $ctrl) -> entity` | Update an existing entity, and return it. Dies on error. |
| `remove` | `($reqmatch, $ctrl) -> entity` | Remove an entity, and return it marked as deleted. Dies on error. |
| `data_get` | `() -> hashref` | Get entity data. |
| `data_set` | `($data)` | Set entity data. |
| `match_get` | `() -> hashref` | Get entity match criteria. |
| `match_set` | `($match)` | Set entity match criteria. |
| `make` | `() -> entity` | Create a new instance with the same options. |
| `get_name` | `() -> string` | Return the entity name. |

### Result shape

Entity operations return the entity, and `list` an `arrayref` of
entities, one per record; `data_get` reads an entity's record (a
`hashref`). They die on error, so wrap calls in `eval { ... }` and
inspect `$@` to handle failures.

The `direct()` escape hatch never dies — it returns a result `hashref`
you branch on via `$result->{ok}`:

| Key | Type | Description |
| --- | --- | --- |
| `ok` | `boolean` | True if the HTTP status is 2xx. |
| `status` | `integer` | HTTP status code. |
| `headers` | `hashref` | Response headers. |
| `data` | `any` | Parsed JSON response body. |

On error, `ok` is false and `err` contains the error value.

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

Create an instance: `my $moon = $client->Moon;`

#### Operations

| Method | Description |
| --- | --- |
| `list()` | List entities, optionally matching the given criteria. |
| `load($match)` | Load a single entity by match criteria. |
| `create($data)` | Create a new entity with the given data. |
| `update($data)` | Update an existing entity. |
| `remove($match)` | Remove the matching entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `number` |  |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `planet_id` | `string` |  |

#### Example: Load

```perl
my $moon = $client->Moon->load({ 'id' => 'moon_id', 'planet_id' => 'planet_id' });
```

#### Example: List

```perl
# an arrayref of entities, one per record; data_get reads each record
my $moons = $client->Moon->list({ 'planet_id' => 'example' });
print $_->data_get->{id}, "\n" for @$moons;
```

#### Example: Create

```perl
my $moon = $client->Moon->create({
    'planet_id' => 'example_planet_id',  # string
    'diameter' => 1,  # number
    'id' => 'example_id',  # string
    'kind' => 'example_kind',  # string
    'name' => 'example_name',  # string
});
```


### Planet

Create an instance: `my $planet = $client->Planet;`

#### Operations

| Method | Description |
| --- | --- |
| `list()` | List entities, optionally matching the given criteria. |
| `load($match)` | Load a single entity by match criteria. |
| `create($data)` | Create a new entity with the given data. |
| `update($data)` | Update an existing entity. |
| `remove($match)` | Remove the matching entity. |

#### Fields

| Field | Type | Description |
| --- | --- | --- |
| `diameter` | `number` |  |
| `forbidReason` | `string` | Why the planet is forbidden, carried from the forbid action's `why`. |
| `forbidState` | `string` | Set by the forbid action, and absent until it first runs. |
| `id` | `string` |  |
| `kind` | `string` |  |
| `name` | `string` |  |
| `terraformState` | `string` | Set by the terraform action, and absent until it first runs. |

#### Example: Load

```perl
my $planet = $client->Planet->load({ 'id' => 'planet_id' });
```

#### Example: List

```perl
# an arrayref of entities, one per record; data_get reads each record
my $planets = $client->Planet->list;
print $_->data_get->{id}, "\n" for @$planets;
```

#### Example: Create

```perl
my $planet = $client->Planet->create({
    'diameter' => 1,  # number
    'id' => 'example_id',  # string
    'kind' => 'example_kind',  # string
    'name' => 'example_name',  # string
});
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

Features are the extension mechanism. A feature is a Perl class
with hook methods named after pipeline stages (e.g. `PrePoint`,
`PreSpec`). Each method receives the context.

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

### Data as hashrefs

The Perl SDK uses plain hashrefs and arrayrefs throughout rather than typed
objects. This mirrors the dynamic nature of the API and keeps the SDK
flexible — no code generation is needed when the API schema changes.

Use `VoxgigSolardemoHelpers::to_map()` to safely validate that a value
is a hashref.

### Module structure

```
perl/
├── lib/VoxgigSolardemoSDK.pm    -- Main SDK module (package VoxgigSolardemoSDK)
├── config.pm                    -- Configuration
├── schema.pm                    -- Generated option + entity specs
├── features.pm                  -- Feature factory
├── core/                        -- Core types and context
├── entity/                      -- Entity implementations
├── feature/                     -- Feature implementations
├── utility/                     -- Utility functions
├── lib/Voxgig/Struct.pm         -- Vendored struct library
└── t/                           -- Test suites
```

Load the main module with `use lib 'lib'; use VoxgigSolardemoSDK;` — it
pulls in the config, features, and core modules for you. Require entity or
utility modules directly only when needed.

### Entity state

Entity instances are stateful. After a successful `list`, the entity
stores the returned data and match criteria internally.

```perl
my $planet = $client->Planet;
$planet->list();

# $planet->data_get now returns the planet data from the last list
# $planet->match_get returns the last match criteria
```

Call `make` to create a fresh instance with the same configuration
but no stored state.

### Direct vs entity access

The entity interface handles URL construction, parameter placement,
and response parsing automatically. Use it for the operations each
entity declares.

`direct` gives full control over the HTTP request. Use it for
non-standard endpoints, bulk operations, or any path not modelled as
an entity. `prepare` builds the request without sending it — useful
for debugging or custom transport.


## Full Reference

See [REFERENCE.md](REFERENCE.md) for complete API reference
documentation including all method signatures, entity field schemas,
and detailed usage examples.
