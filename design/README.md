# Design & Report Index

Design notes, proposals and status reports for this repository. **This folder is
hand-maintained** — nothing here is generated, and nothing here is read by the
generator.

Everything else at the repo root is either generated (`README.md`, `AGENTS.md`)
or a short operational note (`DEV.md`).

Last verified against the working tree: **2026-09-16**, `main` at `5ba7623`
(`@voxgig/sdkgen` ≥4.8.1, 26 targets, secrets feature, PR #32 OpenAPI align).

| Document | Kind | Status |
| --- | --- | --- |
| [REPORT-codebase-review-2026-09-16.md](REPORT-codebase-review-2026-09-16.md) | Review | **Current register** — sdk-base orphaned, identity split, live tests/CI, fleet docs |
| [REPORT-codebase-review-2026-08-20.md](REPORT-codebase-review-2026-08-20.md) | Review | Historical — August findings; most app-side items still hold, generator pins did not survive the `.aon` migration |
| [REPORT-build-and-test-status.md](REPORT-build-and-test-status.md) | Status | Stale numbers (sdkgen 2.0.2, 2026-08-12) — see the 2026-08-20 review |
| [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) | Issue register | Historical — superseded by the 2026-08-20 review; §6 of that review maps old IDs |
| [PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md) | Upstream work item | Ready to hand to an agent in the sdkgen repo |
| [REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md) | Upstream bug | Open upstream — sdkgen ships unmodelled feature source |
| [REPORT-sdkgen-docs-comparison.md](REPORT-sdkgen-docs-comparison.md) | Report | Historical — the doc defects it tracked are now fixed |
| [REPORT-agent-docs-generation.md](REPORT-agent-docs-generation.md) | Report | Historical — `AGENTS.md` generation, still working |
| [DESIGN-entity-types.md](DESIGN-entity-types.md) | Proposal | Superseded — delivered upstream in sdkgen 2.0.2 |
| [PUBLISHING.md](PUBLISHING.md) | Ops | Current process, **stale identity** — names `@voxgig-sdk/voxgig-solardemo` / `voxgig-solardemo-sdk`; generated manifests derive `solardemo` (R1) |
| [REPORT-vendoring-prototype.md](REPORT-vendoring-prototype.md) | Report | Secrets feature landed; `ext/` retired. Struct/omni vendoring notes may still refer to unmerged work |

## Where the open items live

`REPORT-codebase-review-2026-09-16.md` is the current register.
`REPORT-codebase-review-2026-08-20.md` is the August record (what was found
and fixed then). `REPORT-bugs-and-issues.md` is older history. Do not mark
an item open in two places with two different answers.

## Read this before running `voxgig-sdkgen target add`

sdkgen 3.3.1 mitigates TS feature restore via `srcFeatureExcludes`, and Go
via `feature.trim`. `target add` can still overwrite template masters and
local forks. Project-local files that a resync must not clobber:

- `.sdk/src/AgentInfo.ts`, `Agents.ts`, `cmp/{ts,go}/Agents_*.ts`
- `.sdk/src/cmp/ts/fragment/Config.fragment.ts` (named-literal fork)
- `.sdk/src/Root.ts`, `Top.ts`, `BuildSDK.ts`
- Go feature harness trim (`tm/go/test/feature_harness_test.go`)
- `tm/{ts,go}/LICENSE` — a LITERAL copyright year, not the stock
  `$$const.year$$`. This one is load-bearing: sdkgen sets `const.year` from
  `new Date().getFullYear()` and does so UNCONDITIONALLY (it replaces
  `model.const` wholesale first, so the model cannot pin it). A clock-derived
  value inside a drift-gated generated file is a time bomb — on 1 January the
  CI generate emits the new year, the committed LICENSE still says the old
  one, and `Generate and check for drift` fails with nothing changed.

  The year here is a RANGE — `2025-2026` — which a clock-derived value cannot
  produce at all, so restoring stock now changes the output immediately and
  the drift gate catches it in the same PR. That is a happy accident, not the
  reason: before M7 aligned the three LICENSE files, the fork read `2026` and
  stock produced exactly the same bytes for the rest of the year, so restoring
  it looked harmless and stayed harmless right up to the rollover.

- `src/cmp/ts/Package_ts.ts` — ONE line: the published package name is pinned
  under the model's `npm` registry key rather than derived from the target
  name. The trailing-newline fix that also lived here went upstream in sdkgen
  3.7.1 and is gone from this copy now that the pin is raised.

  `src/cmp/{ts,go}/ReadmeIntro_{ts,go}.ts` and `tm/ts/test/exists.test.ts` were
  forks until 3.7.2; they are byte-identical to stock again (modulo the
  `ProjectName` placeholder) and need no entry here.

  `voxgig-sdkgen doctor` reports the current fork/edit counts and is the
  fastest way to see where this list has gone stale.

After any `target add`, diff those paths, restore pins in `model/project.aon`
(the overlay `sdk.aon` actually includes — **not** `sdk-base.aontu`, which
is currently unwired; see R0 in the 2026-09-16 review), then
`npm run build && npm run generate` and check both SDKs still build.

[PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md)
is the upstream work that would remove most of this checklist. See also
C2 / M3 in the 2026-08-20 review: some of these forks are themselves bugs.

## Verification commands

```bash
cd .sdk && npm install && npm run build && npm run generate
cd ts   && npm install && npm run build && npm test
cd go   && go build ./... && go test ./...
cd app  && npm test && npm audit
```

`npm run generate` writes every active target **including in-tree
`seneca-provider/`**. `model/provider.aontu` still documents a sibling-repo
`generate-provider` flow; that npm script does not exist, and `sdk-base.aontu`
is not included by `sdk.aon`. See R0 / H3 in the 2026-09-16 review.

CI runs generate with a drift gate, the `app` suites, and a per-language
matrix (blocking + advisory). It does **not** run live SDK tests against
the companion server.

### `.sdk/src/DocStaticRoot.ts` is inert, and left that way (L8)

It looks abandoned — 45 lines whose entire body is commented out — but it is
the create-sdkgen scaffold's `@voxgig/docgen` root, shipped **byte-identical**.
This repo generates no doc site, and three separate things say so: the `docgen`
action is commented out in `model/.model-config/model-config.aontu`,
`@voxgig/docgen` is not a devDependency, and there is no `doc/` folder. Its
only reference is `.sdk/build/docgen.js`, which only that commented-out action
would load, so nothing on the `npm run generate` path touches it.

Deliberately NOT deleted and NOT annotated in place. Deleting it means the next
resync restores it; adding a comment makes it a fork this list would then have
to carry. It costs nothing where it is, so the cheapest correct move is to say
so here.
