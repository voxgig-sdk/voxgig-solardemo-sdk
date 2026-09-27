# Generated beside kinds.c: what the `secrets` feature needs from the
# build, read by the Makefile through `-include $(wildcard feature/*/kinds.mk)`.
# Without this file none of the feature's vendored payload is compiled or
# linked. Do not hand-edit - change the model and regenerate.

# The vendored cores every chain needs (sekreto and the voxgig/plugin host it
# is built on), and the feature's gated suite.
FEATURE_SRCS += $(wildcard feature/secrets/sekreto/*.c feature/secrets/plugin/*.c)
FEATURE_TEST_SRCS += $(wildcard tests/feature/secrets/*.c)

# No plugin group is active: the plugin layer (the kinds, the socket HTTP
# client and its OpenSSL binding, the encoders, the clock and the
# child-process launcher) is on disk but NOT compiled, and nothing beyond
# libc is linked. A chain of built-ins needs none of it.
