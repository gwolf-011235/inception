#!/bin/bash
set -eo pipefail

mariadb --skip-column-names -e 'select @@skip_networking'
