#!/usr/bin/env bash
#
# Build, start the server, wait until it actually answers, run validate, and
# always stop the server again.
#
# Replaces:
#
#   npm run build && (npm start & echo $! > .server.pid) && sleep 3 && \
#     npm run validate; EXIT_CODE=$?; kill $(cat .server.pid) ...
#
# which had two independent defects:
#
#   1. `sleep 3` is a guess. On a loaded machine the server is not listening
#      yet and every validate check fails with ECONNREFUSED; the rest of the
#      time it is three seconds of nothing.
#
#   2. `$!` was the PID of the `npm start` WRAPPER, not of the `node` process
#      npm spawns. Killing the wrapper can leave the server holding the port,
#      so the next run dies with EADDRINUSE — the symptom the review recorded.
#      Starting node directly makes `$!` the process that owns the port.
#
# Readiness is polled against /api/planet, an endpoint that is already in the
# OpenAPI definition and already exercised by validate.ts. Deliberately NOT a
# new /health route: an endpoint the spec does not describe is exactly the
# drift this repo already carries for /debug.

set -uo pipefail

cd "$(dirname "$0")/.."

PORT="${PORT:-8901}"
HOST="${HOST:-localhost}"
READY_URL="http://${HOST}:${PORT}/api/planet"
TIMEOUT_SECS="${VALIDATE_TIMEOUT_SECS:-30}"

npm run build || exit $?

node dist/src/server.js &
SERVER_PID=$!

# Always stop the server, whatever happens next — including Ctrl-C.
cleanup() {
  if kill -0 "$SERVER_PID" 2>/dev/null; then
    kill "$SERVER_PID" 2>/dev/null || true
    wait "$SERVER_PID" 2>/dev/null || true
  fi
}
trap cleanup EXIT INT TERM

deadline=$(( SECONDS + TIMEOUT_SECS ))
# --max-time matters: a process can hold the port and accept connections
# without ever replying, and an untimed curl then waits forever — the probe
# hangs instead of reporting "not ready". Found by occupying the port with a
# bare TCP listener and watching this loop never come back.
until curl -fsS --connect-timeout 2 --max-time 2 -o /dev/null "$READY_URL" 2>/dev/null; do
  if ! kill -0 "$SERVER_PID" 2>/dev/null; then
    echo "server exited before it began listening" >&2
    exit 1
  fi
  if (( SECONDS >= deadline )); then
    echo "server did not answer ${READY_URL} within ${TIMEOUT_SECS}s" >&2
    exit 1
  fi
  sleep 0.1
done

npm run validate
