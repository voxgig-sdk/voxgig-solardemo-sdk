package voxgig.voxgigsolardemosdk.utility

import voxgig.voxgigsolardemosdk.core.{Context, Spec}

// This SDK is configured with authentication off, so there is no credential
// to place. The object stays in the pipeline because Register binds
// prepareAuth unconditionally and MakeSpec calls it on every request.
object PrepareAuth {

  def prepareAuth(ctx: Context): Spec = {
    val spec = ctx.spec
    if (spec == null) throw ctx.makeError("auth_no_spec", "Expected context spec property to be defined.")

    spec
  }
}
