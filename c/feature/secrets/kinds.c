// Generated: the plugin definitions the model selected for the `secrets`
// feature's provider chain (the c peer of go's core.FeaturePlugins), read
// back by core/config.c's feature_plugins("secrets", &n).
//
// GENERATED beside kinds.mk, the build wiring tm/c/Makefile includes. Do
// not hand-edit - change the model's plugin groups and regenerate.

#include "sdk.h"

#include "sekreto.h"

#include <stddef.h>
#include <stdlib.h>
#include <string.h>

// One prototype per selected kind: the `Definition *(void)` constructor
// its vendored file defines (plugins/sekretoplugins.h declares all ten;
// naming only these keeps the link line the boundary upstream intends).

// No plugin group is active: the chain can name the four built-in kinds
// (env, memory, dotenv, file) and a custom provider, and nothing else.
void** secrets_plugins(size_t* n) {
  *n = 0;
  return NULL;
}

// THE EXCHANGE TRANSPORT OF LAST RESORT, when no plugin group is active: the
// SDK's own client (utility/http.c), called directly rather than through
// the transport this feature wraps, which the token request must never pass
// back through. Reached only by an exchange whose caller supplied no
// system.fetch; a chain that resolves a static credential never comes here.
voxgig_value* secrets_rawfetch(Context* ctx, const char* url,
                               voxgig_value* fetchdef, PNError** err) {
  return http_fetch(ctx, url, fetchdef, err);
}
