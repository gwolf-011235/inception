#!/bin/bash
set -eo pipefail

# logging functions
cadvisor_log() {
	local type="$1"; shift
	printf '%s [%s] [Entrypoint]: %s\n' "$(date --rfc-3339=seconds)" "$type" "$*"
}

cadvisor_note() {
	cadvisor_log Note "$@"
}

cadvisor_note "Running cadvisor docker-entrypoint"

cadvisor_note "Executing command '$@'"
exec "$@"
