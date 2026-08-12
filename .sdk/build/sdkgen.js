
const { SdkGen } = require('@voxgig/sdkgen')

const config = {
  root: __dirname+'/../dist/Root.js',
  folder: __dirname+'/../..',
  meta: {
    name: 'solardemo'
  },
  model: {
    folder: __dirname+'/../model',
  },
  // OVERWRITE, not 3-way merge. Merge diffs against a base kept under
  // .jostraca/, which is gitignored and goes stale: it retains superseded
  // generated files (so a newer template silently does not apply), writes
  // literal <<<<<<< markers into any file that diverged (it produced an
  // invalid ts/package.json here), and skips genuine template changes via its
  // stale-base fast path. Generated output is 100% model-derived and is never
  // hand-edited, so there is nothing to preserve — values a project owns
  // belong in the model, not in output. See @voxgig/sdkgen
  // docs/explanation/regeneration-overwrite.md.
  existing: { txt: { write: true, merge: false } },
}

module.exports = SdkGen.makeBuild(config)
