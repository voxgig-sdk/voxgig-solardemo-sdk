# Publishing

Two artifacts release independently, on separate version numbers and
separate tag namespaces.

| Artifact | Version source | Tag | Mechanism |
| --- | --- | --- | --- |
| `@voxgig-sdk/voxgig-solardemo` | `ts/package.json` | `ts/vX.Y.Z` | npm, OIDC trusted publishing |
| `github.com/voxgig-sdk/voxgig-solardemo-sdk/go` | `go/VERSION` | `go/vX.Y.Z` | Go module proxy — tag only, no upload |

Both versions are declared in the **model**, not hand-edited into the
generated manifests: `main: kit: target: ts: publish: version` in
`.sdk/model/sdk-base.aontu`. A version edited into `ts/package.json` directly
is lost on the next `npm run generate`.

## TypeScript → npm

Either route works; they publish the same thing.

**From a tag (CI).** Push `ts/vX.Y.Z` and
`.github/workflows/publish-ts.yml` does the rest. The workflow asserts
the tag matches `package.json` and refuses to publish if they disagree:

```
TAG="${GITHUB_REF#refs/tags/ts/v}"
[ "$TAG" = "$PKG" ] || exit 1
```

**From a workstation.** `cd ts && make publish`, run under the boru key
vault so no token touches disk or argv:

```sh
boru vault exec --for=npm=<alias> --for=github=<alias> -- make publish
```

It runs the tests first, refuses to proceed if the tag already exists,
and tags *after* a successful publish — so a failed publish never leaves
a tag behind. `boru --dry-run` injects a filler token the Makefile
detects, rehearsing the build without publishing or tagging.

### Trusted publishing

There is **no `NPM_TOKEN` secret**. The workflow requests `id-token:
write` and npm exchanges the GitHub OIDC token for a short-lived
credential, attaching provenance automatically.

The trust relationship is registered against **this workflow's
filename**:

```sh
npm trust --repository voxgig-sdk/voxgig-solardemo-sdk \
          --file publish-ts.yml \
          --allow-publish
```

**Renaming `publish-ts.yml` breaks publishing** until `npm trust` is
re-run against the new name.

npm also requires the package to **already exist on the registry** before
a trusted publisher can be configured, so the very first publish of a new
package name has to be done manually with a token. That is already done
here — `@voxgig-sdk/voxgig-solardemo` is live — so this only matters if
the package is ever renamed. The published name is pinned in
`.sdk/model/sdk-base.aontu` precisely because a published name cannot change
without orphaning its versions.

## Go → module proxy

Go has no registry upload. Publishing a version *is* pushing the tag:

```sh
cd go && boru vault exec --for=github=<alias> -- make publish
```

The module lives in the `go/` subdirectory, so Go's submodule-tag
convention applies and the tag is `go/vX.Y.Z`. `pkg.go.dev` and the
module proxy pick it up on first fetch.

Note that `go/Makefile`'s `publish` target is **deliberately not gated on
`go test`** — the comment there explains why. Quality is gated by CI, not
by the tag push.

## Known gap: the two versions have drifted

`ts/package.json` is at **0.1.0**; `go/VERSION` is still at **0.0.1**.

This is finding **M9** in
[`REPORT-codebase-review-2026-08-20.md`](REPORT-codebase-review-2026-08-20.md)
and is open. There is no Go release workflow — the TS side publishes from
CI on a tag, while Go tags are pushed from a workstation — so the Go
module has not tracked the TS line. Either automate the Go tag or stop
advertising `go get …@latest` until the versions agree.

Until then: do not assume the two artifacts describe the same SDK
revision. The `go/vX.Y.Z` tags that exist are what the proxy serves.
