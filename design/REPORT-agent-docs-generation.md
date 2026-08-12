# Report: Generating AI-Agent Docs from the `.sdk` Templates

Date: 2026-06-08. **Re-verified 2026-08-12** (commit `fa9b672`).
Scope: work extending the `.sdk` generator to emit `AGENTS.md` files for AI
coding agents, plus a record of developer-experience (DX) considerations and
limitations discovered along the way.

> **Status: delivered, and survived the sdkgen 2.0.2 upgrade.** All four
> components and all four generated files are present, and `npm run generate`
> reproduces them without touching any other output.
>
> Most of the limitations recorded in sections 2 and 3 have since been fixed —
> the Go module is now `go get`-able (2.1), and the README defects in 3.1
> are resolved by 2.0.2's `packageMeta` helper and corrected `entity.fields`
> reads. Live status is in
> [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md); one diagnosis (2.3)
> was wrong and is corrected in place below.
>
> Note this report's own observation in 3.2 — no hook to register a custom
> per-target component — is now the second half of a bigger problem: the manual
> `Root.ts` dispatch it describes is one of three hand-repairs that
> `voxgig-sdkgen target add` silently clobbers. See E9/E10 in the register.

---

## 1. What was built

New generator components (in `.sdk`, the source of truth):

| File | Role |
| --- | --- |
| `.sdk/src/AgentInfo.ts` | Shared helpers: consumer-facing SDK names (npm/go), normalised entity view (fields + operations with HTTP method/path), example-entity selection. |
| `.sdk/src/Agents.ts` | Top-level component → emits root `AGENTS.md` and the test server's `app/AGENTS.md`. |
| `.sdk/src/cmp/ts/Agents_ts.ts` | Emits `ts/AGENTS.md` (TypeScript SDK usage). |
| `.sdk/src/cmp/go/Agents_go.ts` | Emits `go/AGENTS.md` (Go SDK usage). |
| `.sdk/src/Root.ts` | Wiring: calls `Agents` at project level and the per-target `Agents{Ts,Go}` inside each target folder. |

Generated output (run `cd .sdk && npm run build && npm run generate`):

| File | Audience | Purpose |
| --- | --- | --- |
| `AGENTS.md` | Agent working **on** this repo | (a) How to use `.sdk` to build the SDKs: layout, golden rule, build/regenerate commands, entity overview, pointer to the separate server. |
| `ts/AGENTS.md` | Agent **using** the TS SDK | (b) Install, client creation, minimal example, result shape, options, per-entity field + operation tables, contributor build steps. |
| `go/AGENTS.md` | Agent **using** the Go SDK | (b) Same, in Go idiom (incl. the `replace`-directive consumption note). |
| `app/AGENTS.md` | Agent running the test server | The separate REST server's run instructions, in its own folder. |

Generation is **idempotent** and does not disturb the existing SDK code
output (verified: `ts`/`go` still build after regeneration).

### Request coverage

- **(a) Build the SDKs via `.sdk`** — covered by root `AGENTS.md`.
- **(b) Use each SDK** — covered by `ts/AGENTS.md` and `go/AGENTS.md`, written
  **server-agnostically**: they describe pointing the client at any compatible
  endpoint via the `base` option and never mention the test server.
- **Separate test server** — mentioned at the top level and given its own
  `app/AGENTS.md`; the SDK docs contain no knowledge that a "test" server exists.

---

## 2. Limitations — files/content that could not be generated cleanly

### 2.1 Go module is not `go get`-able  (severity: high, consumer-facing)

> **Fixed 2026-08-12.** `go/go.mod` now declares
> `github.com/voxgig-sdk/voxgig-solardemo-sdk/go` and the inlined `struct`
> package needs no external dependency. See D1/E9 in the register.


`go/go.mod` declares module path `voxgigsolardemosdk` (no remote host) and uses
a local `replace github.com/voxgig/struct => ./utility/struct`. Consequently:

- The existing generated `go/README.md` instruction `go get voxgigsolardemosdk`
  **does not work** for an external consumer.
- A downstream project can only consume the module via a `replace` directive
  pointing at the SDK source — which is what `go/AGENTS.md` now documents
  honestly, rather than printing a broken `go get`.

Recommendation: make the module path a real, fetchable path (e.g.
`github.com/voxgig-sdk/voxgig-solardemo-sdk/go`) and publish/vendor the `struct`
dependency, so the Go SDK is consumable like a normal module.

### 2.2 `app/AGENTS.md` is generated into a non-modelled, hand-written folder  (severity: medium)

The test server in `app/` is hand-written and **not a generation target**. To
satisfy "instructions in its own folder", `Agents.ts` emits `app/AGENTS.md` by
opening a `Folder({ name: 'app' })` at the project root. This works, but:

- The generator now "owns" one file inside an otherwise hand-written directory.
- App specifics (Node 24, port 8901, `npm start`) are **hardcoded in the
  generator** because the app is not in the model — so they can drift from the
  real server.

The generated `app/AGENTS.md` is therefore deliberately thin and defers to
`app/README.md` for specifics. Recommendation: either model the app as an
auxiliary target (so its facts come from the model) or hand-maintain
`app/AGENTS.md` and have the generator skip it.

### 2.3 Entity hierarchy is not available in the model  (severity: medium)

> **Corrected 2026-08-12.** The hierarchy *is* in the model — under
> `entity.relations.ancestors`, not `entity.ancestors`. `.sdk/model/sdk.json`
> has `main.kit.entity.moon.relations.ancestors = [["planet"]]`. The real defect
> is that `Top.ts` reads the wrong key, so this is a small generator fix rather
> than a model gap. Tracked as **E2**. The rest of this section stands: the
> path-based heuristic used in the agent docs still works and still picks
> `Planet` correctly.

Moon is nested under Planet (paths `/api/planet/{planet_id}/moon/...`), but
`entity.ancestors` is empty in the model. Effects:

- The top-level `README.md` mermaid diagram (in `Top.ts`) renders **empty** —
  no parent→child edges.
- "Nested under …" hints cannot be derived from `ancestors`.

Worked around in the agent docs by selecting the example entity via a
path-based heuristic (`rootEntity`: an entity whose `list` path has no `{param}`),
which correctly picks `Planet`. Proper nesting metadata (populating `ancestors`,
or deriving parent from path parts in apidef) would let docs and the mermaid show
real relationships and let nested examples include the parent id automatically.

---

## 3. Developer-experience considerations discovered

### 3.1 Pre-existing doc bugs in the generated README (worth fixing)

> **All three fixed 2026-08-12** by sdkgen 2.0.2 — `helpers/packageMeta.ts` is
> now the single source of truth for the published package name, and the Readme
> components read `entity.fields` and per-operation points correctly. See
> C1–C4 in the register.


While building model-driven tables I found the existing README generator is
producing inaccurate docs:

1. **Wrong install/import name.** `ts/README.md` prints `npm install solardemo`
   and `import { SolardemoSDK } from 'solardemo'`, but the real package (per
   `Package_ts.ts`) is `@voxgig-sdk/solardemo`. The README components
   (`ReadmeInstall_ts.ts`, `ReadmeQuick_ts.ts`) use `target.module.name`
   (`solardemo`) instead of the computed package name. The new `AgentInfo.sdkNames`
   computes the correct name; the README components should do the same.
2. **Empty field tables / empty API paths.** The README "Entities" section shows
   empty field tables and `` API path: `` ``. The data exists in the model
   (`entity.fields`, `entity.op[].points[].orig`); the README generator reads the
   wrong keys (`entity.field` singular). `AgentInfo.entityInfo` reads `entity.fields`
   (plural) and per-operation points and produces fully populated tables — the
   same fix should be applied to the README generator.
3. **Empty create examples.** `client.X().create({ })` shows no fields, again
   because field data isn't pulled in.

### 3.2 No project-level hook to register a new per-target component  (generator DX)

sdkgen's built-ins (`Main`, `Readme`, `Test`, `Entity`) auto-dispatch to
`cmp/<target>/X_<ext>.ts` by convention, but there is no documented way for a
project to register a **new** per-target component into that mechanism. I wired
the per-target `Agents` dispatch manually in `Root.ts`:

```ts
if ('ts' === target.name) { AgentsTs({ target }) }
else if ('go' === target.name) { AgentsGo({ target }) }
```

This works and is explicit, but it duplicates the dispatch sdkgen already does
internally and does not scale to many targets. A registration API (e.g.
`registerComponent('Agents')` that resolves `cmp/<target>/Agents_<ext>.ts`) would
be cleaner.

### 3.3 Authoring markdown via TS template literals is fiddly  (generator DX)

Doc content is built with TypeScript template strings, which forces escaping of
backticks and `${...}` inside fenced code blocks. It works, but a markdown-aware
emit helper, or `.md.tm` template-master files with `$$PLACEHOLDER$$`
substitution (as already used for code in `tm/`), would be far more ergonomic for
documentation authors and reduce escaping mistakes.

### 3.4 No stale-output pruning  (generator robustness)

Generation merges/adds files but never deletes outputs whose source template was
removed or renamed. This previously produced a duplicate, casing-only
`FeatureHookUtility.ts`. The new doc files are additive and safe, but renaming or
removing a doc component later would leave an orphaned `AGENTS.md`-style file
behind. A "clean the target dir before generate" option would prevent this class
of bug.

### 3.5 Things that worked well  (positive DX)

- The `cmp` / `File` / `Folder` / `Content` primitives made it simple to create
  files and place them precisely (repo root, per-target folder, `app/`).
- Model access through `getModelPath` / `KIT` / `nom` gave clean, typed-enough
  access to entities, fields and operations.
- Extending `Root.ts` by importing components directly (as `Top`/`BuildSDK`
  already are) is explicit and easy to follow.
- Idempotent generation made iterating on templates safe and reviewable.

---

## 4. How to regenerate

```bash
cd .sdk
npm install
npm run build      # compile the generator (includes the Agents components)
npm run generate   # (re)writes AGENTS.md, ts/AGENTS.md, go/AGENTS.md, app/AGENTS.md
```

---

## 5. Suggested follow-ups (priority order)

Re-checked 2026-08-12; none has been done. IDs refer to
[REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md).

1. Make the Go module consumable — real module path + published/vendored
   `struct` (**D1**).
2. Fix the README generator to use the real package name (**C1**) and read
   `entity.fields` / operation points (**C2**, **C3**) — eliminates the broken
   install line and the empty tables.
3. ~~Populate entity `ancestors`~~ — instead, fix `Top.ts` to read
   `entity.relations.ancestors`, which already exists, so the hierarchy renders
   in the mermaid diagram and nested examples are correct (**E2**).
4. Decide the ownership model for `app/` docs — model it, or hand-maintain
   (**E4**).
5. Add a generator affordance for registering custom per-target components
   (**E3**) and, optionally, markdown template-master files (**E5**).
