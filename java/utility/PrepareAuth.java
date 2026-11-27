package voxgig.voxgigsolardemosdk.utility;

import voxgig.voxgigsolardemosdk.core.Context;
import voxgig.voxgigsolardemosdk.core.Spec;

// This SDK is configured with authentication off, so there is no credential
// to place. The class stays in the pipeline because Register wires
// prepareAuth unconditionally and MakeSpec calls it on every request.
final class PrepareAuth {

  private PrepareAuth() {}

  static Spec prepareAuth(Context ctx) {
    Spec spec = ctx.spec;
    if (spec == null) {
      throw ctx.makeError("auth_no_spec",
          "Expected context spec property to be defined.");
    }

    return spec;
  }
}
