# Solardemo Perl SDK Reference

Complete API reference for the Solardemo Perl SDK.


## SolardemoSDK

### Constructor

```perl
use lib 'lib';
use SolardemoSDK;

my $client = SolardemoSDK->new($options);
```

Create a new SDK client instance.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `$options` | `hashref` | SDK configuration options. |
| `$options->{base}` | `string` | Base URL for API requests. |
| `$options->{prefix}` | `string` | URL prefix appended after base. |
| `$options->{suffix}` | `string` | URL suffix appended after path. |
| `$options->{headers}` | `hashref` | Custom headers for all requests. |
| `$options->{feature}` | `hashref` | Feature configuration. |
| `$options->{system}` | `hashref` | System overrides (e.g. custom fetch). |


### Static Methods

#### `SolardemoSDK->test($testopts, $sdkopts)`

Create a test client with mock features active. Both arguments may be `undef`.

```perl
my $client = SolardemoSDK->test();
```


### Instance Methods

#### `Moon($data)`

Create a new `Moon` entity instance. Pass `undef` for no initial data.

#### `Planet($data)`

Create a new `Planet` entity instance. Pass `undef` for no initial data.

#### `options_map() -> hashref`

Return a deep copy of the current SDK options.

#### `get_utility() -> utility`

Return a copy of the SDK utility object.

#### `direct($fetchargs) -> hashref`

Make a direct HTTP request to any API endpoint. Returns a result `hashref` with `ok`, `status`, `headers`, and `data` (or `err` on failure). This escape hatch never dies — branch on `$result->{ok}`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `$fetchargs->{path}` | `string` | URL path with optional `{param}` placeholders. |
| `$fetchargs->{method}` | `string` | HTTP method (default: `'GET'`). |
| `$fetchargs->{params}` | `hashref` | Path parameter values. |
| `$fetchargs->{query}` | `hashref` | Query string parameters. |
| `$fetchargs->{headers}` | `hashref` | Request headers (merged with defaults). |
| `$fetchargs->{body}` | `any` | Request body (hashrefs are JSON-serialized). |

**Returns:** `hashref`

#### `prepare($fetchargs) -> hashref`

Prepare a fetch definition without sending. Returns the `fetchdef` and dies on error.


---

## Moon entity

```perl
my $moon = $client->Moon;
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `number` | Yes |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `planet_id` | `string` | Yes |  |

### Operations

#### `create($reqdata, $ctrl) -> hashref`

Create a new entity with the given data. Returns the created entity data and dies on error.

```perl
my $result = $client->Moon->create({
    'planet_id' => 'example_planet_id',  # string
    'diameter' => 1,  # number
    'id' => 'example_id',  # string
    'kind' => 'example_kind',  # string
    'name' => 'example_name',  # string
});
```

#### `list($reqmatch, $ctrl) -> arrayref`

List entities matching the given criteria. The match is optional — call `list` with no argument to list all records. Returns an arrayref and dies on error.

```perl
my $results = $client->Moon->list;
for my $moon (@$results) {
    print "$moon->{id}\n";
}
```

#### `load($reqmatch, $ctrl) -> hashref`

Load a single entity matching the given criteria. Returns the entity data and dies on error.

```perl
my $result = $client->Moon->load({ 'id' => 'moon_id', 'planet_id' => 'planet_id' });
```

#### `remove($reqmatch, $ctrl) -> hashref`

Remove the entity matching the given criteria. Dies on error.

```perl
my $result = $client->Moon->remove({ 'id' => 'moon_id', 'planet_id' => 'planet_id' });
```

#### `update($reqdata, $ctrl) -> hashref`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and dies on error.

```perl
my $result = $client->Moon->update({
    'id' => 'moon_id',
    'planet_id' => 'planet_id',
    # Fields to update
});
```

### Common Methods

#### `data_get() -> hashref`

Get the entity data.

#### `data_set($data)`

Set the entity data.

#### `match_get() -> hashref`

Get the entity match criteria.

#### `match_set($match)`

Set the entity match criteria.

#### `make() -> entity`

Create a new `Moon` entity instance with the same options.

#### `get_name() -> string`

Return the entity name.


---

## Planet entity

```perl
my $planet = $client->Planet;
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `number` | Yes |  |
| `forbid` | `boolean` | No |  |
| `id` | `string` | Yes |  |
| `kind` | `string` | Yes |  |
| `name` | `string` | Yes |  |
| `ok` | `boolean` | No |  |
| `start` | `boolean` | No |  |
| `state` | `string` | No |  |
| `stop` | `boolean` | No |  |
| `why` | `string` | No |  |

### Operations

#### `create($reqdata, $ctrl) -> hashref`

Create a new entity with the given data. Returns the created entity data and dies on error.

```perl
my $result = $client->Planet->create({
    'diameter' => 1,  # number
    'id' => 'example_id',  # string
    'kind' => 'example_kind',  # string
    'name' => 'example_name',  # string
});
```

#### `list($reqmatch, $ctrl) -> arrayref`

List entities matching the given criteria. The match is optional — call `list` with no argument to list all records. Returns an arrayref and dies on error.

```perl
my $results = $client->Planet->list;
for my $planet (@$results) {
    print "$planet->{id}\n";
}
```

#### `load($reqmatch, $ctrl) -> hashref`

Load a single entity matching the given criteria. Returns the entity data and dies on error.

```perl
my $result = $client->Planet->load({ 'id' => 'planet_id' });
```

#### `remove($reqmatch, $ctrl) -> hashref`

Remove the entity matching the given criteria. Dies on error.

```perl
my $result = $client->Planet->remove({ 'id' => 'planet_id' });
```

#### `update($reqdata, $ctrl) -> hashref`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and dies on error.

```perl
my $result = $client->Planet->update({
    'id' => 'planet_id',
    # Fields to update
});
```

### Common Methods

#### `data_get() -> hashref`

Get the entity data.

#### `data_set($data)`

Set the entity data.

#### `match_get() -> hashref`

Get the entity match criteria.

#### `match_set($match)`

Set the entity match criteria.

#### `make() -> entity`

Create a new `Planet` entity instance with the same options.

#### `get_name() -> string`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```perl
my $client = SolardemoSDK->new({
    'feature' => {
        'test' => { 'active' => 1 },
    },
});
```


### Configuring features

Each feature is inactive until switched on, and an SDK with no feature
configured does no feature work at all. Every option below keeps its default
unless you name it.

The array form of \`feature\` is significant: several features wrap the
transport, and the order you list them in is the order they nest.

#### `test`

In-memory mock transport for testing without a live server.

**Configuration**

| Option | Default |
|---|---|
| `active` | `false` |

Options above are those the model carries a default for. A feature may
also accept callback options — a `sink` to receive each record, for
instance — which have no default and are covered in the full feature
reference.

**Usage**

Set `feature.test.active` to true in the client options, and override any option above in the same entry. Every option keeps
its default unless you name it.

**Considerations**

- Attaches to pipeline hooks, not the transport, so activation order does
  not change what it observes.
- Installs the BASE transport that the wrapping features wrap, so it must be
  activated before them.
- Inactive by default: leaving it out costs nothing at runtime.

