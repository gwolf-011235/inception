#!/bin/bash
set -eo pipefail

# logging functions
nginx_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

nginx_note() {
	nginx_log Note "$@"
}

nginx_note "Running nginx docker-entrypoint"

nginx_note "Executing command '$@'"
exec "$@"

