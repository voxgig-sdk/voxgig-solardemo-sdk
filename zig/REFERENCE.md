# Solardemo Zig SDK Reference

Complete API reference for the Solardemo Zig SDK.


## SolardemoSDK

### Constructor

```zig
const sdk = @import("sdk");
const h = sdk.h;

const client = sdk.SolardemoSDK.new(options);
```

Create a new SDK client instance. `options` is a `Value` map
(`h.vnull()` for none).

**Parameters:**

| Key | Value type | Description |
| --- | --- | --- |
| `base` | `string` | Base URL for API requests. |
| `prefix` | `string` | URL prefix appended after base. |
| `suffix` | `string` | URL suffix appended after path. |
| `headers` | `map` | Custom headers for all requests. |
| `feature` | `map` | Feature configuration. |
| `system` | `map` | System overrides. |


### Static Functions

#### `test_sdk(testopts: Value, sdkopts: Value) *SolardemoSDK`

Create a test client with mock features active. Both arguments may be
`h.vnull()`.

```zig
const client = sdk.test_sdk(h.vnull(), h.vnull());
```


### Instance Methods

#### `moon(entopts: Value) *MoonEntity`

Create a new `MoonEntity` instance. Pass `h.vnull()` for no
initial options.

#### `planet(entopts: Value) *PlanetEntity`

Create a new `PlanetEntity` instance. Pass `h.vnull()` for no
initial options.

#### `options_map() Value`

Return a deep copy of the current SDK options.

#### `get_utility() *Utility`

Return a copy of the SDK utility object.

#### `direct(fetchargs: Value) Value`

Make a direct HTTP request to any API endpoint. Returns a result `Value`
map with `ok`, `status`, `headers`, and `data` (or `err` on failure).
This escape hatch returns a map even on a non-2xx response — branch on
`h.get_bool(result, "ok")`.

**Parameters (`fetchargs` map keys):**

| Key | Value type | Description |
| --- | --- | --- |
| `path` | `string` | URL path with optional `{param}` placeholders. |
| `method` | `string` | HTTP method (default: `"GET"`). |
| `params` | `map` | Path parameter values. |
| `query` | `map` | Query string parameters. |
| `headers` | `map` | Request headers (merged with defaults). |
| `body` | `any` | Request body (maps are JSON-serialized). |

#### `prepare(fetchargs: Value) E!Value`

Prepare a fetch definition without sending. Returns the fetchdef (use
`catch`/`try` to handle the error union).


---

## MoonEntity

```zig
const moon = client.moon(h.vnull());
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `f64` | Yes |  |
| `id` | `[]const u8` | Yes |  |
| `kind` | `[]const u8` | Yes |  |
| `name` | `[]const u8` | Yes |  |
| `planet_id` | `[]const u8` | Yes |  |

### Operations

#### `create(reqdata: Value, ctrl: Value) OpResult`

Create a new entity with the given data. `.ok` carries the created entity data.

```zig
switch (client.moon(h.vnull()).create(h.jo(&.{
    .{ "planet_id", h.vstr("example_planet_id") }, // []const u8
    .{ "diameter", h.vnum(1) }, // f64
    .{ "id", h.vstr("example_id") }, // []const u8
    .{ "kind", h.vstr("example_kind") }, // []const u8
    .{ "name", h.vstr("example_name") }, // []const u8
}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("create failed: {s}\n", .{e.msg}),
}
```

#### `list(reqmatch: Value, ctrl: Value) OpResult`

List entities matching the given criteria. The match is optional — pass `h.vnull()` to list all records. `.ok` is a `Value` array.

```zig
switch (client.moon(h.vnull()).list(h.vnull(), h.vnull())) {
    .ok => |results| std.debug.print("{s}\n", .{h.stringify(results)}),
    .err => |e| std.debug.print("list failed: {s}\n", .{e.msg}),
}
```

#### `load(reqmatch: Value, ctrl: Value) OpResult`

Load a single entity matching the given criteria. `.ok` carries the entity data, `.err` the branded error.

```zig
switch (client.moon(h.vnull()).load(h.jo(&.{.{ "id", h.vstr("moon_id") }, .{ "planet_id", h.vstr("planet_id") }}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("load failed: {s}\n", .{e.msg}),
}
```

#### `remove(reqmatch: Value, ctrl: Value) OpResult`

Remove the entity matching the given criteria. `.err` on failure.

```zig
switch (client.moon(h.vnull()).remove(h.jo(&.{.{ "id", h.vstr("moon_id") }, .{ "planet_id", h.vstr("planet_id") }}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("remove failed: {s}\n", .{e.msg}),
}
```

#### `update(reqdata: Value, ctrl: Value) OpResult`

Update an existing entity. The data must include the entity id. `.ok` carries the updated entity data.

```zig
switch (client.moon(h.vnull()).update(h.jo(&.{
    .{ "id", h.vstr("moon_id") },
    .{ "planet_id", h.vstr("planet_id") },
    // Fields to update
}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("update failed: {s}\n", .{e.msg}),
}
```

### Common Methods

#### `data(args: ?Value) Value`

Get the entity data. Pass a map to set it.

#### `matchv(args: ?Value) Value`

Get the entity match criteria. Pass a map to set it.

#### `stream(action: []const u8, args: Value, callopts: Value) []Value`

Run an operation through the pipeline and materialise its result items.

#### `get_name() []const u8`

Return the entity name.


---

## PlanetEntity

```zig
const planet = client.planet(h.vnull());
```

### Fields

| Field | Type | Required | Description |
| --- | --- | --- | --- |
| `diameter` | `f64` | Yes |  |
| `forbid` | `bool` | No |  |
| `id` | `[]const u8` | Yes |  |
| `kind` | `[]const u8` | Yes |  |
| `name` | `[]const u8` | Yes |  |
| `ok` | `bool` | No |  |
| `start` | `bool` | No |  |
| `state` | `[]const u8` | No |  |
| `stop` | `bool` | No |  |
| `why` | `[]const u8` | No |  |

### Operations

#### `create(reqdata: Value, ctrl: Value) OpResult`

Create a new entity with the given data. `.ok` carries the created entity data.

```zig
switch (client.planet(h.vnull()).create(h.jo(&.{
    .{ "diameter", h.vnum(1) }, // f64
    .{ "id", h.vstr("example_id") }, // []const u8
    .{ "kind", h.vstr("example_kind") }, // []const u8
    .{ "name", h.vstr("example_name") }, // []const u8
}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("create failed: {s}\n", .{e.msg}),
}
```

#### `list(reqmatch: Value, ctrl: Value) OpResult`

List entities matching the given criteria. The match is optional — pass `h.vnull()` to list all records. `.ok` is a `Value` array.

```zig
switch (client.planet(h.vnull()).list(h.vnull(), h.vnull())) {
    .ok => |results| std.debug.print("{s}\n", .{h.stringify(results)}),
    .err => |e| std.debug.print("list failed: {s}\n", .{e.msg}),
}
```

#### `load(reqmatch: Value, ctrl: Value) OpResult`

Load a single entity matching the given criteria. `.ok` carries the entity data, `.err` the branded error.

```zig
switch (client.planet(h.vnull()).load(h.jo(&.{.{ "id", h.vstr("planet_id") }}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("load failed: {s}\n", .{e.msg}),
}
```

#### `remove(reqmatch: Value, ctrl: Value) OpResult`

Remove the entity matching the given criteria. `.err` on failure.

```zig
switch (client.planet(h.vnull()).remove(h.jo(&.{.{ "id", h.vstr("planet_id") }}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("remove failed: {s}\n", .{e.msg}),
}
```

#### `update(reqdata: Value, ctrl: Value) OpResult`

Update an existing entity. The data must include the entity id. `.ok` carries the updated entity data.

```zig
switch (client.planet(h.vnull()).update(h.jo(&.{
    .{ "id", h.vstr("planet_id") },
    // Fields to update
}), h.vnull())) {
    .ok => |result| std.debug.print("{s}\n", .{h.stringify(result)}),
    .err => |e| std.debug.print("update failed: {s}\n", .{e.msg}),
}
```

### Common Methods

#### `data(args: ?Value) Value`

Get the entity data. Pass a map to set it.

#### `matchv(args: ?Value) Value`

Get the entity match criteria. Pass a map to set it.

#### `stream(action: []const u8, args: Value, callopts: Value) []Value`

Run an operation through the pipeline and materialise its result items.

#### `get_name() []const u8`

Return the entity name.


---

## Features

| Feature | Version | Description |
| --- | --- | --- |
| `test` | 0.0.1 | In-memory mock transport for testing without a live server |


Features are activated via the `feature` option:

```zig
const client = sdk.SolardemoSDK.new(h.jo(&.{
    .{ "feature", h.jo(&.{
        .{ "test", h.jo(&.{.{ "active", h.vbool(true) }}) },
    }) },
}));
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

