// Generated: the plugin definitions the model selected for the `secrets`
// feature's provider chain (the cpp peer of go's core.FeaturePlugins),
// read back by core/config.hpp's featurePlugins("secrets") and by the
// feature itself through secrets_plugins().
//
// GENERATED beside kinds.mk, the build wiring tm/cpp/Makefile includes. Do
// not hand-edit - change the model's plugin groups and regenerate.
//
// The one non-header translation unit this SDK generates: it includes the
// header-only SDK (for the declarations feature/secrets.hpp makes) and the
// vendored kind headers, which core/config.hpp must never name.

#include "../../core/sdk.hpp"

#include <memory>
#include <string>
#include <utility>
#include <vector>


namespace sdk {

// No plugin group is active: the chain can name the four built-in kinds
// (env, memory, dotenv, file) and a custom provider, and nothing else.
std::vector<std::shared_ptr<void>> secrets_plugins() {
  return {};
}

// THE EXCHANGE TRANSPORT OF LAST RESORT, when no plugin group is active:
// there is none. The cpp core ships no HTTP client, and the vendored HTTPS
// client (plugins/Httpjson.cpp, OpenSSL) is compiled with the plugin
// groups only (see kinds.mk beside this file), so a token purchase needs
// options.system.fetch - the seam every live cpp request already uses.
// Reached only by an exchange whose caller supplied no transport; a chain
// that resolves a static credential never comes here.
SecretsRawResponse secrets_rawfetch(
    const std::string& method, const std::string& url,
    const std::vector<std::pair<std::string, std::string>>& headers,
    const std::string& body) {
  (void)method; (void)headers; (void)body;
  SecretsRawResponse out;
  out.ok = false;
  out.err = "secrets: the token exchange has no HTTP transport: this SDK selected "
    "no secrets plugin group, so the vendored HTTPS client is not compiled; "
    "supply options.system.fetch or activate a plugin group (URL was: \"" +
    url + "\")";
  return out;
}

} // namespace sdk
