# AGENTS.md — VoxgigSolardemo test/reference server

A standalone REST server implementing the VoxgigSolardemo API. Use it as a local
target when developing or validating the SDKs.

It is **independent of the SDKs** and not required to use them — the SDK
clients have no knowledge of this server.

## Run

Prerequisites: Node.js >= 24.

```bash
cd app
npm install
npm run build
npm start          # serves http://localhost:8901 by default
```

See [`README.md`](README.md) for the full endpoint list, data model and test
commands.

## Using it with an SDK (local end-to-end)

Point an SDK client's `base` option at this server, e.g.
`http://localhost:8901`, to exercise the SDK against a real implementation.
