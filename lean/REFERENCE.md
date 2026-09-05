# Solardemo Lean SDK Reference

Complete API reference for the Solardemo Lean SDK.


## Modules

| Module | Purpose |
| --- | --- |
| `SdkClient` | `Sdk.newSdk` / `Sdk.testSdk` and the per-entity op namespaces |
| `SdkConfig` | the embedded API model (JSON) |
| `SdkRuntime` | the config-driven operation pipeline and curl transport |
| `SdkUtility` | request-shaping utilities (spec, url, params, transforms, result) |
| `SdkJson` | JSON text to struct `Value` |
| `VoxgigStruct` | the vendored voxgig struct value model |


## Features


### Configuring features

Each feature is inactive until switched on, and an SDK with no feature
configured does no feature work at all. Every option below keeps its default
unless you name it.

This SDK takes \`feature\` as a map and composes the transport-wrapping
features in a fixed catalog order, so activation order does not change
nesting here.

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

