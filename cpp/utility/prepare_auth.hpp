// prepare_auth utility — WHERE THE CREDENTIAL GOES.
//
// GENERATED, not templated: header, query or cookie, and under what name,
// is a fact about THIS API, and tm/ can only hold one answer. Extracted
// from utility/pipeline.hpp, which includes this header and still binds
// `u.prepareAuth = util::prepareAuth` in register_all — the symbol, the
// namespace and every call site are unchanged. See PrepareAuth_cpp.
//
// Do not hand-edit: change the model's security scheme (or
// main.kit.config.auth) and regenerate.

#ifndef SDK_UTILITY_PREPARE_AUTH_HPP
#define SDK_UTILITY_PREPARE_AUTH_HPP

#include <algorithm>
#include <string>

#include "../core/types.hpp"

namespace sdk {
namespace util {

// This SDK is configured with authentication off, so there is no credential
// to place.
// The function stays in the pipeline because makeSpec calls it
// unconditionally and uses the Spec it returns.
inline SpecPtr prepareAuth(CtxPtr ctx) {
  SpecPtr spec = ctx->spec;
  if (!spec) throw ctx->makeError("auth_no_spec", "Expected context spec property to be defined.");

  return spec;
}

} // namespace util
} // namespace sdk

#endif // SDK_UTILITY_PREPARE_AUTH_HPP
