# Generated beside kinds.cpp: what the `secrets` feature needs from the
# build, read by the Makefile through `-include $(wildcard feature/*/kinds.mk)`.
# Without this file none of the feature's vendored payload is compiled or
# linked. Do not hand-edit - change the model and regenerate.

# The wiring translation unit, the vendored cores every chain needs (sekreto
# and the voxgig/plugin host it is built on), and the feature's gated suite.
FEATURE_SRCS += feature/secrets/kinds.cpp \
  $(wildcard feature/secrets/sekreto/*.cpp feature/secrets/plugin/*.cpp)
FEATURE_TEST_SRCS += $(wildcard test/feature/secrets/*.cpp)

# No plugin group is active: the plugin layer (the kinds, the socket HTTPS
# client and its OpenSSL binding, the digests and the child-process
# launcher) is on disk but NOT compiled - plugins/Tls.cpp hard-includes
# <openssl/ssl.h> - and nothing beyond libstdc++ is linked. A chain of
# built-ins needs none of it.
