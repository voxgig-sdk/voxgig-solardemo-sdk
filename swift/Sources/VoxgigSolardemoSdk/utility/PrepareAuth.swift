// VoxgigSolardemo SDK utility: prepareAuth - place the API credential.
//
// GENERATED, not templated: WHERE the credential goes - header, query or
// cookie, and under what name - is a fact about THIS API, and tm/ can only
// hold one answer. Extracted from utility/Prepare.swift, which keeps the
// seven prepare* functions that do not depend on the model. Bound by
// utility/Register.swift (`u.prepareAuth = prepareAuthUtil`) exactly as
// before: same module, same internal symbol, no import needed.
//
// See cmp/swift/PrepareAuth_swift.ts.

import Foundation

// This SDK is configured with authentication OFF, so there is no
// credential to place. The function stays in the pipeline because Register
// binds it unconditionally and makeSpec calls it on every request.
func prepareAuthUtil(_ ctx: Context) throws -> Spec {
  guard let spec = ctx.spec else {
    throw ctx.makeError("auth_no_spec", "Expected context spec property to be defined.")
  }

  return spec
}
