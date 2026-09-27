# VoxgigSolardemo SDK: the secrets feature build.
#
# GENERATED because the model activates `secrets` for this target
# (plugin groups: none - the built-in kinds alone).
# An SDK whose model does not has no such file, and its Makefile's optional
# include of it is a no-op: nothing of the feature is compiled. Do not
# hand-edit - change the model's plugin groups and regenerate.
#
# MODULE ORDER IS THE DEPENDENCY ORDER: the voxgig/plugin host, the sekreto
# core, the shared helpers the selected kinds open, the kinds, the feature.

FEATURE_INC = -I +unix -I feature -I feature/secrets/plugin \
  -I feature/secrets/sekreto -I feature/secrets/plugins
FEATURE_LIB = unix.cma

SECRETS_PLUGIN = feature/secrets/plugin/value.ml \
  feature/secrets/plugin/types.ml \
  feature/secrets/plugin/ref.ml \
  feature/secrets/plugin/version.ml \
  feature/secrets/plugin/capability.ml \
  feature/secrets/plugin/resolve.ml \
  feature/secrets/plugin/env.ml \
  feature/secrets/plugin/config.ml \
  feature/secrets/plugin/graph.ml \
  feature/secrets/plugin/order.ml \
  feature/secrets/plugin/export.ml \
  feature/secrets/plugin/depend.ml \
  feature/secrets/plugin/point.ml \
  feature/secrets/plugin/defs.ml \
  feature/secrets/plugin/catalog.ml \
  feature/secrets/plugin/host.ml

SECRETS_CORE = feature/secrets/sekreto/json.ml \
  feature/secrets/sekreto/secret.ml \
  feature/secrets/sekreto/provider.ml \
  feature/secrets/sekreto/sekreto.ml

SECRETS_HELPERS =

SECRETS_KINDS =

FEATURE_SRC = $(SECRETS_PLUGIN) $(SECRETS_CORE) $(SECRETS_HELPERS) $(SECRETS_KINDS) \
  feature/secrets_feature.ml

FEATURE_TESTS = test/feature/secrets/t_secrets.ml

# No active plugin group needs a transport or a C stub, so nothing is
# compiled and nothing is linked beyond the OCaml distribution.
FEATURE_OBJ =
FEATURE_LINK =
