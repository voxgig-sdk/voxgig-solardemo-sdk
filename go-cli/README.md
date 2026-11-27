# voxgig-solardemo-cli

boru-driven command-line client **and** interactive REPL for the VoxgigSolardemo
SDK. Each command line is parsed as a single [boru](https://github.com/boru-lang/boru)
expression and evaluated against the live API; run it with no arguments to drop
into a REPL. Built on `github.com/boru-lang/boru/eng/go` and
the sibling Go SDK at `../go`.

## Examples

```sh
# 1. Build a native binary (-> dist/<os>-<arch>/voxgig-solardemo-cli)
make build

# 2. See usage (words, entities, env vars)
./voxgig-solardemo-cli --help

# 3. Each command line is ONE boru expression, run against the API:
./voxgig-solardemo-cli list '{planet_id:"example"}' moon
./voxgig-solardemo-cli load '{id:"example_id",planet_id:"example"}' moon
./voxgig-solardemo-cli update '{id:"example",planet_id:"example",diameter:1}' moon
./voxgig-solardemo-cli list planet

# 4. Override the API base URL for a single call
VOXGIG_SOLARDEMO_BASE=https://api.example.com ./voxgig-solardemo-cli list '{planet_id:"example"}' moon

# 5. No arguments -> interactive REPL
./voxgig-solardemo-cli
voxgig-solardemo> list {planet_id:"example"} moon
voxgig-solardemo> /quit
```

> The rest of this guide follows the [Diátaxis](https://diataxis.fr) framework:
> a hands-on **Tutorial**, task-focused **How-to guides**, a factual
> **Reference**, and background **Explanation**.

## Tutorial: your first query in under a minute

1. **Build the binary.** From this `go-cli/` directory:

   ```sh
   make build          # -> dist/<os>-<arch>/voxgig-solardemo-cli
   ```

2. **Run a query.** Evaluate an boru expression against the API (or run with no
   arguments to open the REPL):

   ```sh
   ./dist/*/voxgig-solardemo-cli list '{planet_id:"example"}' moon
   ```

3. **Go interactive.** Run the binary with no arguments to open the REPL, then
   type `/help` for the word and entity lists and `/quit` to leave.

That is the whole loop: *build → evaluate boru expressions*.

## How-to guides

### List the records of an entity

```sh
./voxgig-solardemo-cli list '{planet_id:"example"}' moon
```

`list <query> <entity>` returns the first page of records under the parent the query names. `<entity>` is a bareword —
it is auto-quoted as an boru atom, so no quotes are needed.

### Load a single record

```sh
./voxgig-solardemo-cli load '{id:"example_id",planet_id:"example"}' moon
```

The query is a **match map** naming the record (`{id:"example_id",planet_id:"example"}`). Quote the map so your shell passes it through intact.

### Update a record

```sh
./voxgig-solardemo-cli update '{id:"example",planet_id:"example",diameter:1}' moon
```

The match map carries both the selector and the new field values; the updated
record is printed back.

### Choose an environment

Configuration is read from the environment — nothing is written to disk:

```sh
export VOXGIG_SOLARDEMO_BASE=https://api.example.com  # optional: override the API base URL
./voxgig-solardemo-cli list '{planet_id:"example"}' moon
```

It is injectable by a secrets vault.

### Explore interactively with the REPL

Run with no arguments to open a REPL (prompt `voxgig-solardemo>`). Each line is
evaluated as its own boru expression:

```text
$ ./voxgig-solardemo-cli
voxgig-solardemo> list {planet_id:"example"} moon
voxgig-solardemo> /help
voxgig-solardemo> /quit
```

### Cross-compile release binaries

```sh
make build       # native binary for this machine
make build-all   # linux/darwin/windows x amd64/arm64, under dist/<os>-<arch>/
```

### Discover the available entities

`/help` in the REPL lists the entities a word runs on, as [Entities](#entities)
below does — this SDK exposes 2 entities.

## Reference

### Words

The CLI registers these boru words, each bound to the SDK:

| Word     | Signatures                                    | Returns                        |
|----------|-----------------------------------------------|--------------------------------|
| `list`   | `list <entity>` · `list <query> <entity>`     | First page of records          |
| `load`   | `load <entity>` · `load <query> <entity>`     | A single record                |
| `update` | `update <query> <entity>`                     | Update a record, return it     |

- `<entity>` is a bareword, auto-quoted as an boru atom (e.g. `moon`).
- `<query>` is either a **Map** naming the record, or a **Scalar**, which is
  always wrapped as `{id:<value>}`.

### Environment variables

| Variable | Purpose |
|----------|---------|
| `VOXGIG_SOLARDEMO_BASE` | Optional override of the API base URL. |

Unset variables fall back to the SDK's built-in defaults.

### CLI flags

- `--help` / `-h` — print usage (words, entities, env vars) and exit.

### REPL commands

Meta-commands use the `/` prefix (everything else on a line is evaluated as boru):

- `/quit` / `/q` / `/exit` — exit the REPL
- `/help` / `/h` / `/?`     — show the word list, entity list and meta commands

### Exit codes

| Code | Meaning |
|------|---------|
| `0` | Success (also the normal REPL exit). |
| `1` | Parse error, word-registration error, or an API/evaluation error. |

### Build targets

| Target | Result |
|--------|--------|
| `make build` | Native binary at `dist/<os>-<arch>/voxgig-solardemo-cli`. |
| `make build-all` | linux/darwin/windows x amd64/arm64, each under its own `dist/<os>-<arch>/`. |
| `make clean` | Remove `dist/` and any stray binaries. |

### Entities

The entities a word runs on, each with its words:

| Entity | Words |
|--------|-------|
| `moon` | `list`, `load`, `update` |
| `planet` | `list`, `load`, `update` |

## Explanation

### Why boru?

The whole command line is one [boru](https://github.com/boru-lang/boru) expression,
not a fixed `verb --flag` grammar. That means the same binary works one-shot
(`./voxgig-solardemo-cli <expr>`) and interactively (the REPL), and expressions compose the
same way in both. `list` / `load` / `update` are ordinary boru *words* bound to
the SDK — adding SDK operations is adding words, not re-parsing flags.

### How it is wired

`main.go` builds the SDK client (configured from the environment), creates an
boru registry, and `words.go` registers `list` / `load` / `update` as native
words that dispatch on the entity atom and call the sibling Go SDK at `../go`.
Results are unwrapped from their `Entity` wrappers to plain data before being
printed.

### Output format

Each result value is printed as its boru string form (a JSON-like rendering of
the record or list of records). One-shot mode prints to stdout; errors go to
stderr with a non-zero exit code.

## Generated by

sdkgen `go-cli` target. See the target source under `.sdk/src/cmp/go-cli/` in
this repo, or upstream at
`github.com/voxgig/sdkgen/project/.sdk/src/cmp/go-cli/`.
