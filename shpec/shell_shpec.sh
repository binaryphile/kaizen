#!/usr/bin/env bash

library=../lib/shell.sh
source "${BASH_SOURCE%/*}/$library" 2>/dev/null || source "$library"
