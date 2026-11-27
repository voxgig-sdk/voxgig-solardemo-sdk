// prepare_auth utility (mirrors utility/prepare_auth.rs).
//
// GENERATED, not templated - see PrepareAuth_c.
//
// This SDK is configured with authentication off, so there is no credential
// to place. The function stays in the pipeline because make_spec calls it
// unconditionally.

#include "sdk.h"

Spec* prepare_auth_util(Context* ctx, PNError** err) {
  *err = NULL;
  Spec* spec = ctx->spec;
  if (!spec) {
    *err = context_make_error(ctx, "auth_no_spec", "Expected context spec property to be defined.");
    return NULL;
  }

  return spec;
}
