# Report: sdkgen copies feature source that the model never activates

Found 2026-08-12 while upgrading this repo to `@voxgig/sdkgen` 2.0.2.
Reviewed against `~/Projects/voxgig/sdkgen` at `6bc54f0` (v2.0.2).

**Severity: Medium.** Not a build break in the default scaffold — which is
exactly why it has gone unnoticed. It ships unreachable code to consumers of
any SDK whose model activates a subset of features.

---

## Symptom

This repo's model activates exactly one feature. `.sdk/model/feature/` contains
only `test.aontu`, and `feature-index.aontu` includes only that. Generation
confirms it:

```
INFO: model/jostraca  generate-feature  target:go, feature: test
INFO: model/jostraca  generate-feature  target:ts, feature: test
```

Yet `npm run generate` emitted **16 feature implementations** into the Go SDK
and 3 into the TypeScript SDK:

```
go/feature/{audit,cache,clienttrack,debug,idempotency,log,metrics,netsim,
            paging,proxy,ratelimit,rbac,retry,streaming,telemetry,timeout}_feature.go
ts/src/feature/log/LogFeature.ts
```

None of them is reachable. `go/solardemo.go` registers only `BaseFeature` and
`TestFeature`; the TypeScript client builds its feature list from the model
config, which lists only `test`. `grep -rl LogFeature ts/src go` matched
nothing but the implementation files themselves.

The cost is not only dead code. Before removal, `ts/package.json` carried
`pino` and `pino-pretty` as **production dependencies** — every consumer of the
TypeScript SDK pulled a logging framework for a feature they could not switch
on.

---

## Cause

Two components copy feature source, and only one of them respects the model.

**`ts/src/cmp/Feature.ts` is correct.** It is invoked once per active feature
and copies just that feature's directory:

```ts
Folder({ name: 'src/feature/' + feature.name }, () => {
  Copy({ from: 'tm/' + target.name + '/src/feature/' + feature.name, ... })
})
```

**`Main_<lang>.ts` defeats it** by bulk-copying the whole template tree.

`ts/project/.sdk/src/cmp/go/Main_go.ts`:

```ts
Copy({
  from: 'tm/' + target.name,
  exclude: [/src\//, /utility\/struct\/go\.mod$/],
  ...
})
```

Go's feature templates live at `tm/go/feature/`, **not** under `src/`, so
`/src\//` does not exclude them. Every file in `tm/go/feature/` is copied.

`ts/project/.sdk/src/cmp/ts/Main_ts.ts` is worse — it has no `exclude` at all:

```ts
Copy({
  from: 'tm/' + target.name,
  replace: { ...props.ctx$.stdrep },
})
```

so `tm/ts/src/feature/*` is copied wholesale. The comment already in
`Feature.ts` acknowledges the overlap:

> This worked by accident everywhere it worked: `Main_<lang>` copies the whole
> `tm/<lang>` tree (feature dirs included) with stdrep afterwards, so the
> substituted version overwrote this one.

## Why it was not caught

The default scaffold model activates **all 17 features**
(`project/.sdk/model/feature/feature-index.aontu` includes `test`, `log`, and
15 enterprise features). With every feature active, "copy everything" and "copy
what the model asked for" produce identical output. The bug is only visible in
a project like this one that activates a subset.

## Scope across targets

Three targets already have the right guard, which shows the intent:

| Target | `exclude` | Feature templates at | Leaks? |
| --- | --- | --- | --- |
| clojure, haskell, lean | `/src\/feature\//` | `src/feature/` | no |
| py, py-data | `/src\//, /pkg\//` | `src/feature/`, `pkg/feature/` | no |
| ts, js, go-cli, go-mcp | *(none)* | `src/feature/` | **yes** |
| go | `/src\//, …` | `feature/` | **yes** |
| java, kotlin, php, perl, rust, lua, scala, zig | `/src\//` | `feature/` **and** `src/feature/` | **yes** (the non-`src` copy) |

So the majority of targets leak, in two distinct ways: no exclude at all, or an
exclude that only covers `src/`.

## Suggested fix

Exclude feature source from the bulk copy in every `Main_<lang>.ts`, and let
`Feature.ts` place the active ones — matching what clojure/haskell/lean already
do. The pattern has to cover both layouts:

```ts
exclude: [ /(^|\/)feature\//, ... ]
```

Two things must keep shipping regardless of the model, so they need care:

- `feature/base_feature.go` and `ts/src/feature/base/` — `BaseFeature` is
  always registered.
- `feature/feature_options.go` — shared infrastructure, not a feature.

Either allowlist those, or move them out of the `feature/` template directory
into the core/utility tree where they belong.

## Related: the Go feature test has the same assumption

`tm/go/test/feature_test.go` guards at **runtime**:

```go
func fhSkipWithout(t *testing.T, names ...string) { ... t.Skip(...) }
```

but its blocks reference feature constructors at **compile time**:

```go
rf := feat.NewRetryFeature()
```

So an SDK generated without those features cannot compile its own test package
— the runtime skip never gets a chance to run. Fixing the copy bug without also
fixing this would turn a silent dead-code problem into a hard build break for
every subset-feature project.

Suggested: split the `fh*` harness into its own file (`pipeline_test.go` and
`netsim_test.go` already depend on it), and emit each per-feature block only
when the model activates that feature.

**Workaround applied here:** the template is truncated to the harness, and the
15 per-feature test blocks are dropped. Tracked as E10 in
[REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md).

## Related: package identity ignores repo naming

Not the same bug, but found alongside it. `helpers/packageMeta.ts` derives both
the Go module path and the repo URLs from `<model.name>-sdk`:

```ts
const repo = `${slug}-sdk`
case 'go': return `github.com/${origin}/${slug}-sdk/go`
```

There is no override. A repo not named `<name>-sdk` — this one is
`voxgig-solardemo-sdk` — gets a module path that 404s on `go get`, plus
`homepage`/`repository`/`bugs` URLs pointing at a repo that does not exist.
Worked around locally with `.sdk/src/PkgPath.ts` across 12 vendored components
(E9), which `target add` then clobbers. A `module.path` / repo override read
from the model would remove the need.
