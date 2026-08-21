# Publishing

Two artifacts release independently, on separate version numbers and
separate tag namespaces.

| Artifact | Version source | Tag | Mechanism |
| --- | --- | --- | --- |
| `@voxgig-sdk/voxgig-solardemo` | `ts/package.json` | `ts/vX.Y.Z` | npm, OIDC trusted publishing |
| `github.com/voxgig-sdk/voxgig-solardemo-sdk/go` | `go/VERSION` | `go/vX.Y.Z` | Go module proxy — tag only, no upload |

Both versions are declared in the **model**, not hand-edited into the
generated manifests — `main: kit: target: {ts,go}: publish: version` in
`.sdk/model/sdk-base.aontu`. A version edited into `ts/package.json` or
`go/VERSION` directly is lost on the next `npm run generate`.

The Go side is a little different, and it is the difference that caused the
drift below. `go/VERSION` is produced from `tm/go/VERSION`, and the scaffold
ships that as the placeholder `PROJECTVERSION`, which **`target add`**
substitutes when it copies the template — not `generate`. So the project's
template carries a resolved literal, frozen at whatever the model said when
`target add go` last ran. Put the placeholder back by hand and the literal
string `PROJECTVERSION` ships in the released VERSION file.

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

## The two versions agreed again (was M9)

`ts/package.json` and `go/VERSION` are both at **0.1.0**.

They had drifted — TS reached 0.1.0 while Go still said 0.0.1 — because the
Go version was not declared in the model at all, so `tm/go/VERSION` stayed
frozen at the default resolved by an old `target add go` while every TS
release moved on. `main: kit: target: go: publish: version` now declares it,
which is what makes the next `target add go` resolve to the right number.

A shared number is deliberate: both artifacts are generated from one model, so
claiming one revision is honest. They are still **released independently** —
separate tags, separate cadence — so nothing forces them to stay equal.

`publish-go.yml` now runs on a `go/v*` tag. It cannot publish, because Go has
no upload — by the time it runs the tag is already public — but it asserts the
tag matches `go/VERSION`, builds, and runs the tests offline, which is what
the TS side gets for free by publishing from CI. `go/Makefile`'s publish target
is deliberately not gated on `go test`, so before this there was nothing
checking a Go release at all.

A failure there means the tag is **already** serving a broken or mislabelled
module. Fix forward with a new tag: a Go module version, once fetched by the
proxy, is immutable.
