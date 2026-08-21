# Design & Report Index

Design notes, proposals and status reports for this repository. **This folder is
hand-maintained** — nothing here is generated, and nothing here is read by the
generator.

Everything else at the repo root is either generated (`README.md`, `AGENTS.md`)
or a short operational note (`DEV.md`).

Last verified against the working tree: **2026-08-20**, after the
`@voxgig/sdkgen` 3.3.1 line (entity-returning ops, Seneca provider,
publication pins).

| Document | Kind | Status |
| --- | --- | --- |
| [REPORT-codebase-review-2026-08-20.md](REPORT-codebase-review-2026-08-20.md) | Review | **Current register** — contract splits, Agents identity, CI gaps |
| [REPORT-build-and-test-status.md](REPORT-build-and-test-status.md) | Status | Stale numbers (sdkgen 2.0.2, 2026-08-12) — see the 2026-08-20 review |
| [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) | Issue register | Historical — superseded by the 2026-08-20 review; §6 of that review maps old IDs |
| [PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md) | Upstream work item | Ready to hand to an agent in the sdkgen repo |
| [REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md) | Upstream bug | Open upstream — sdkgen ships unmodelled feature source |
| [REPORT-sdkgen-docs-comparison.md](REPORT-sdkgen-docs-comparison.md) | Report | Historical — the doc defects it tracked are now fixed |
| [REPORT-agent-docs-generation.md](REPORT-agent-docs-generation.md) | Report | Historical — `AGENTS.md` generation, still working |
| [DESIGN-entity-types.md](DESIGN-entity-types.md) | Proposal | Superseded — delivered upstream in sdkgen 2.0.2 |

## Where the open items live

`REPORT-codebase-review-2026-08-20.md` is the current register.
`REPORT-bugs-and-issues.md` is kept for history; do not mark an item open in
both places with two different answers.

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

- `src/cmp/ts/Package_ts.ts`, `src/cmp/{ts,go}/ReadmeIntro_{ts,go}.ts`,
  `tm/ts/test/exists.test.ts` — forked here first, then carried upstream into
  sdkgen 3.7.2. They stop being forks the moment `.sdk/package.json`'s
  `@voxgig/sdkgen` pin is raised to that release; until then `target add`
  reverts them. `voxgig-sdkgen doctor` reports the current fork/edit counts
  and is the fastest way to see where this list has gone stale.

After any `target add`, diff those paths, restore pins in `model/sdk-base.aontu`
(they live there *because* `target add` overwrites target files), then
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

`npm run generate` is portable — it no longer needs a sibling
`../../seneca/solardemo-provider` checkout. The seneca-provider target is
`active: false` in `model/sdk.aontu`; generating it is the separate, deliberate
`npm run generate-provider`, which reads `model/provider.aontu` and DOES need
that checkout (H3).

CI runs generate with a drift gate, the `app` suites, ts on two Node versions,
go, and a live-SDK job against the companion server (H2).

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
