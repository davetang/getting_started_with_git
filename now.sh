#!/usr/bin/env bash

set -euo pipefail

now(){
   date '+%Y/%m/%d %H:%M:%S'
}

# seconds to sleep
s=2

>&2 printf "[ %s %s ] Start\n" $(now)
>&2 echo Sleeping for ${s} seconds
sleep ${s}
>&2 printf "[ %s %s ] End\n" $(now)

exit 0

