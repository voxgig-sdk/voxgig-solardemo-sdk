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

// THE EXCHANGE TRANSPORT OF LAST RESORT, when no plugin group is active:
// there is none. The c core ships no HTTP client, and libcurl is bundled
// with the plugin groups only (see tm/c/Makefile), so a token purchase
// needs options.system.fetch - the seam every live c request already uses.
// Reached only by an exchange whose caller supplied no transport; a chain
// that resolves a static credential never comes here.
voxgig_value* secrets_rawfetch(Context* ctx, const char* url,
                               voxgig_value* fetchdef, PNError** err) {
  (void)url; (void)fetchdef;
  *err = context_make_error(ctx, "secrets_no_transport",
    "secrets: the token exchange has no HTTP transport: this SDK selected no "
    "secrets plugin group, so libcurl is not linked; supply "
    "options.system.fetch or activate a plugin group");
  return NULL;
}
