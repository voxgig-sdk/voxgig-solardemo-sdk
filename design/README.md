# Design & Report Index

Design notes, proposals and status reports for this repository. **This folder is
hand-maintained** — nothing here is generated, and nothing here is read by the
generator.

Everything else at the repo root is either generated (`README.md`, `AGENTS.md`)
or a short operational note (`DEV.md`).

Last verified against the working tree: **2026-08-12**, after the
`@voxgig/sdkgen` 1.3.17 → 2.0.2 upgrade.

| Document | Kind | Status |
| --- | --- | --- |
| [REPORT-build-and-test-status.md](REPORT-build-and-test-status.md) | Status | Current — both SDKs green, 0 generation warnings |
| [REPORT-bugs-and-issues.md](REPORT-bugs-and-issues.md) | Issue register | Current — 25 fixed, 14 open |
| [PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md) | Upstream work item | Ready to hand to an agent in the sdkgen repo |
| [REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md) | Upstream bug | Open upstream — sdkgen ships unmodelled feature source |
| [REPORT-sdkgen-docs-comparison.md](REPORT-sdkgen-docs-comparison.md) | Report | Historical — the doc defects it tracked are now fixed |
| [REPORT-agent-docs-generation.md](REPORT-agent-docs-generation.md) | Report | Historical — `AGENTS.md` generation, still working |
| [DESIGN-entity-types.md](DESIGN-entity-types.md) | Proposal | Superseded — delivered upstream in sdkgen 2.0.2 |

## Where the open items live

`REPORT-bugs-and-issues.md` is the single register. The other reports keep their
narrative but defer to it for status, so an item is never marked "open" in two
places with two different answers.

## Read this before running `voxgig-sdkgen target add`

`.sdk/src/cmp/**` now matches the sdkgen 2.0.2 scaffold exactly — **there are no
forked components**. But three repairs to `.sdk/tm/**` are still undone by a
resync, because `target add` overwrites the template masters:

1. **Feature templates** — the 16 unmodelled feature templates come back
   (B0, and [REPORT-sdkgen-feature-copy-bug.md](REPORT-sdkgen-feature-copy-bug.md)).
   Delete everything under `tm/go/feature/` and `tm/ts/src/feature/` except
   `base`, `test` and `feature_options.go`.
2. **`tm/go/test/feature_test.go`** — restored to the full version, which then
   fails to compile without those features (E10). Truncate it to the harness
   (everything above the first `// --- <feature>` block) and prune the now-unused
   imports.
3. **Stale files** — `tm/go/utility/make_target.go`,
   `tm/go/utility/struct/go.mod`, `tm/go/test/exists_test.go` and a substituted
   `src/cmp/ts/fragment/Config.fragment.ts` reappear or linger (E1). Remove them.

After any `target add`, re-apply all three, then `npm run build && npm run
generate` and check both SDKs still build.

All three exist because sdkgen hardcodes decisions that belong in the model.
[PROMPT-sdkgen-model-driven-customisation.md](PROMPT-sdkgen-model-driven-customisation.md)
specifies the upstream work that would remove the need for every one of them.

## Verification commands

```bash
cd .sdk && npm install && npm run build && npm run generate   # 0 warnings
cd ts   && npm install && npm run build && npm test           # 186 tests
cd go   && go build ./... && go test ./...                    # 17 tests
cd app  && npm audit                                          # 0 vulnerabilities
```
