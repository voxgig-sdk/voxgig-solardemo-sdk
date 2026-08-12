// Root README.md.
//
// This used to hand-roll a 9-line stub: a title, an "API Entities" heading and
// a mermaid flowchart that always rendered EMPTY, because it read
// `entity.ancestors` while the model carries the hierarchy at
// `entity.relations.ancestors` (an array of ancestor PATHS, not a flat list).
// Everything the root README is supposed to say — packages, quickstart per
// language, entities, how-to guides, upstream API, security — was simply
// missing, and `go/test/readme_examples_test.go` failed with "no go code
// blocks in root README".
//
// sdkgen provides `ReadmeTop`, which assembles all of that from the model and
// dispatches to the per-target `ReadmeTopQuick_<ext>` / `ReadmeTopHowto_<ext>` /
// `ReadmeTopTest_<ext>` components this project already vendors. Delegating to
// it is strictly better than the stub, and keeps the root README in step with
// the per-target READMEs.
//
// NOTE: ReadmeTop does not emit an entity mermaid diagram. The old one never
// rendered, so nothing working was lost — but if the diagram is wanted back it
// belongs in ReadmeTop upstream, and it must read `relations.ancestors`.
// Tracked as E2 in design/REPORT-bugs-and-issues.md.

import { cmp, ReadmeTop } from '@voxgig/sdkgen'


const Top = cmp(function Top(props: any) {
  ReadmeTop({})
})


export {
  Top
}
