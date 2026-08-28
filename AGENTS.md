# AGENTS.md — Solardemo SDK workspace

This repository holds **generated** client SDKs for the Solardemo API in
multiple target languages. All SDKs are produced from a single model by the
generator in `.sdk/` (built on [@voxgig/sdkgen](https://github.com/voxgig/sdkgen)).

> This file orients an AI coding agent. Start here.

## Repository layout

| Path | What it is | Edit here? |
| --- | --- | --- |
| `.sdk/` | The generator: model, templates and components. **Source of truth.** | ✅ Yes |
| `ts/` | Generated TypeScript SDK. | ⛔ Generated |
| `go/` | Generated Go SDK. | ⛔ Generated |
| `app/` | Standalone REST server, separate from the SDKs (see below). | Independent |

## Golden rule

`ts/` and `go/` are **generated output**. Do not hand-edit them — changes are
overwritten on the next `generate`. To change an SDK, edit the model or
templates under `.sdk/` and regenerate.

## Build the SDKs (regenerate `ts/` and `go/`)

Prerequisites: Node.js >= 24, Go >= 1.23.

```bash
cd .sdk
npm install
npm run build      # compile the generator (src/ -> dist/)
npm run generate   # regenerate ts/ and go/ from the model
```

Generation is **idempotent**: running it on an unchanged model produces no diff.

## Where things live in `.sdk/`

| Path | Purpose |
| --- | --- |
| `model/sdk-base.aon` | Everything the project declares about itself — wires in entities, features, targets, config, and holds the pins. |
| `model/sdk.aon` | Entry point for `npm run generate`: the base, plus `seneca-provider` OFF. |
| `model/provider.aon` | Entry point for `npm run generate-provider`: the base, plus `seneca-provider` ON. Needs the sibling checkout. |
| `model/entity/*.aon` | Entity definitions: fields and operations. |
| `model/target/{ts,go}.aon` | Per-target settings and dependency versions. |
| `tm/` | Template master files copied verbatim into the output SDKs. |
| `src/cmp/{ts,go}/` | Programmatic generators (package.json, code, README, AGENTS). |
| `src/Root.ts` | Top-level generation entry; orchestrates every component. |

A typical change: edit `model/entity/<name>.aontu` (or a template under
`tm/`), then `npm run build && npm run generate`, then build/test each SDK.

## Build & test each SDK

- **TypeScript** — see [`ts/AGENTS.md`](ts/AGENTS.md).
- **Go** — see [`go/AGENTS.md`](go/AGENTS.md).

## API entities

- **Moon** (`moon`) — operations: create, list, load, remove, update
- **Planet** (`planet`) — operations: create, list, load, remove, update

Each entity exposes the listed operations on a typed handle obtained from the
client. See the per-SDK `AGENTS.md` for language-specific usage.

## Companion test server (separate)

`app/` is a **standalone REST server** that implements the Solardemo API. It
exists for local development and validation of the SDKs and is **not** part of
any SDK distribution. The SDKs are server-agnostic — point them at any
compatible endpoint via their `base` option. See [`app/AGENTS.md`](app/AGENTS.md).
