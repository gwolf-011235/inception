#!/bin/bash
set -eo pipefail

# logging functions
adminer_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

adminer_note() {
	adminer_log Note "$@"
}

adminer_note "Running adminer docker-entrypoint"

adminer_note "Executing command '$@'"
exec "$@"

