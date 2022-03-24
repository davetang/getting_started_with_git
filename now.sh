#!/usr/bin/env bash

set -euo pipefail

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

>&2 printf "[ %s %s ] Start\n" $(now)
sleep 2
>&2 printf "[ %s %s ] End\n" $(now)

exit 0

