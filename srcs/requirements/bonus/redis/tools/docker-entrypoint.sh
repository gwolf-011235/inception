#!/bin/bash
set -eo pipefail

# logging functions
redis_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

redis_note() {
	redis_log Note "$@"
}

redis_note "Running redis docker-entrypoint"

redis_note "Executing command '$@'"
exec "$@"

