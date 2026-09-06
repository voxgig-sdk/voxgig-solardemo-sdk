# Solardemo Dart SDK Reference

Complete API reference for the Solardemo Dart SDK.

## SolardemoSDK

### Constructor

```dart
import 'package:solardemo_sdk/SolardemoSDK.dart';

final client = SolardemoSDK(options);
```

Create a new SDK client instance.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `options` | `Map` | SDK configuration options. |
| `options['base']` | `String` | Base URL for API requests. |
| `options['prefix']` | `String` | URL prefix appended after base. |
| `options['suffix']` | `String` | URL suffix appended after path. |
| `options['headers']` | `Map` | Custom headers for all requests. |
| `options['feature']` | `Map` | Feature configuration. |
| `options['system']` | `Map` | System overrides (e.g. custom fetch). |


### Static Methods

#### `SolardemoSDK.test([testopts, sdkopts])`

Create a test client with mock features active. Both arguments may be `null`.

```dart
final client = SolardemoSDK.test();
```


### Instance Methods

#### `Moon([entopts])`

Create a new `MoonEntity` instance. Pass no argument for no initial data.

#### `Planet([entopts])`

Create a new `PlanetEntity` instance. Pass no argument for no initial data.

#### `options() -> Map`

Return a deep copy of the current SDK options.

#### `utility() -> Utility`

Return the SDK utility object.

#### `direct([fetchargs]) -> Future<Map>`

Make a direct HTTP request to any API endpoint. Returns a result `Map` with `ok`, `status`, `headers`, and `data` (or `err` on failure). This escape hatch never throws — branch on `result['ok']`.

**Parameters:**

| Name | Type | Description |
| --- | --- | --- |
| `fetchargs['path']` | `String` | URL path with optional `{param}` placeholders. |
| `fetchargs['method']` | `String` | HTTP method (default: `'GET'`). |
| `fetchargs['params']` | `Map` | Path parameter values. |
| `fetchargs['query']` | `Map` | Query string parameters. |
| `fetchargs['headers']` | `Map` | Request headers (merged with defaults). |
| `fetchargs['body']` | `dynamic` | Request body (maps are JSON-serialized). |

**Returns:** `Future<Map>`

#### `prepare([fetchargs]) -> Future`

Prepare a fetch definition without sending. Returns the `fetchdef` (or an error value on failure).


---

## MoonEntity

```dart
final moon = client.Moon();
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `num` | Yes |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `planet_id` | `String` | Yes |  |

### Operations

#### `create(reqdata, [ctrl]) -> Future<dynamic>`

Create a new entity with the given data. Returns the created entity data and throws on error.

```dart
final result = await client.Moon().create({
  'planet_id': 'example_planet_id',  // String
  'diameter': 1,  // num
  'id': 'example_id',  // String
  'kind': 'example_kind',  // String
  'name': 'example_name',  // String
});
```

#### `list([reqmatch, ctrl]) -> Future<List>`

List entities matching the given criteria. The match is optional — call `list()` with no argument to list all records. Returns a list of entity instances and throws on error.

```dart
final results = await client.Moon().list({ planet_id: "example" });
for (final moon in results) {
  print(moon.data());
}
```

#### `load(reqmatch, [ctrl]) -> Future<dynamic>`

Load a single entity matching the given criteria. Returns the entity data and throws on error.

```dart
final result = await client.Moon().load({'id': 'moon_id', 'planet_id': 'planet_id'});
```

#### `remove(reqmatch, [ctrl]) -> Future<dynamic>`

Remove the entity matching the given criteria. Throws on error.

```dart
final result = await client.Moon().remove({'id': 'moon_id', 'planet_id': 'planet_id'});
```

#### `update(reqdata, [ctrl]) -> Future<dynamic>`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and throws on error.

```dart
final result = await client.Moon().update({
  'id': 'moon_id',
  'planet_id': 'planet_id',
  // Fields to update
});
```

### Common Methods

#### `data([d]) -> Map`

Get the entity data, or set it when passed an argument.

#### `match([m]) -> Map`

Get the entity match criteria, or set it when passed an argument.

#### `make() -> Entity`

Create a new `MoonEntity` instance with the same options.

#### `entopts() -> Map`

Return the entity options.


---

## PlanetEntity

```dart
final planet = client.Planet();
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `num` | Yes |  |
| `forbid` | `bool` | No |  |
| `id` | `String` | Yes |  |
| `kind` | `String` | Yes |  |
| `name` | `String` | Yes |  |
| `ok` | `bool` | No |  |
| `start` | `bool` | No |  |
| `state` | `String` | No |  |
| `stop` | `bool` | No |  |
| `why` | `String` | No |  |

### Operations

#### `create(reqdata, [ctrl]) -> Future<dynamic>`

Create a new entity with the given data. Returns the created entity data and throws on error.

```dart
final result = await client.Planet().create({
  'diameter': 1,  // num
  'id': 'example_id',  // String
  'kind': 'example_kind',  // String
  'name': 'example_name',  // String
});
```

#### `list([reqmatch, ctrl]) -> Future<List>`

List entities matching the given criteria. The match is optional — call `list()` with no argument to list all records. Returns a list of entity instances and throws on error.

```dart
final results = await client.Planet().list();
for (final planet in results) {
  print(planet.data());
}
```

#### `load(reqmatch, [ctrl]) -> Future<dynamic>`

Load a single entity matching the given criteria. Returns the entity data and throws on error.

```dart
final result = await client.Planet().load({'id': 'planet_id'});
```

#### `remove(reqmatch, [ctrl]) -> Future<dynamic>`

Remove the entity matching the given criteria. Throws on error.

```dart
final result = await client.Planet().remove({'id': 'planet_id'});
```

#### `update(reqdata, [ctrl]) -> Future<dynamic>`

Update an existing entity. The data must include the entity `id`. Returns the updated entity data and throws on error.

```dart
final result = await client.Planet().update({
  'id': 'planet_id',
  // Fields to update
});
```

### Common Methods

#### `data([d]) -> Map`

Get the entity data, or set it when passed an argument.

#### `match([m]) -> Map`

Get the entity match criteria, or set it when passed an argument.

#### `make() -> Entity`

Create a new `PlanetEntity` instance with the same options.

#### `entopts() -> Map`

Return the entity options.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `secrets` | 0.1.0 | Secret access: resolve the API credential through a provider chain, and exchange a refresh token for short-lived access tokens |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```dart
final client = SolardemoSDK({
  'feature': {
    'secrets': {'active': true},
    'test': {'active': true},
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

