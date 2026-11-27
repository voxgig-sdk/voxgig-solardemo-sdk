package voxgig.voxgigsolardemosdk.utility

import voxgig.voxgigsolardemosdk.core.Context
import voxgig.voxgigsolardemosdk.core.Spec

// This SDK is built with authentication off, so there is no credential
// to place. The function stays in the pipeline because Register
// binds it unconditionally and MakeSpecUrl calls it on every request, and a
// missing spec is still the same error it always was.
fun prepareAuth(ctx: Context): Spec {
  return ctx.spec
    ?: throw ctx.makeError("auth_no_spec", "Expected context spec property to be defined.")
}
