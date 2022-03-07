#!/usr/bin/env bash
#
# See https://github.com/davetang/getting_started_with_git#renaming-a-branch
#

set -euo pipefail

usage() {
   >&2 echo "Usage: $0 [ -d dir ]"
   exit 1
}

num_param=1
required_param=$(bc -l<<<${num_param}*2+1)

while getopts ":d:" options; do
  case "${options}" in
    d)
      my_dir=${OPTARG}
      ;;
    :)
      echo "Error: -${OPTARG} requires an argument."
      exit 1
      ;;
    *)
      usage ;;
  esac
done

if [[ ${OPTIND} -ne ${required_param} ]]; then
   usage
fi

if [[ ! -d ${my_dir} ]]; then
   >&2 echo ${my_dir} does not exist
   exit 1
fi

check_depend (){
   tool=$1
   if [[ ! -x $(command -v ${tool}) ]]; then
     >&2 echo Could not find ${tool}
     exit 1
   fi
}

dependencies=(git)
for tool in ${dependencies[@]}; do
   check_depend ${tool}
done

cd ${my_dir}

# find git directory, which is usually .git
git_dir=$(git rev-parse --git-dir)

git rev-parse --quiet --verify master || >&2 echo master branch does not exist

>&2 echo Renaming master to main
git branch -m master main

git_remote=$(git remote)
if [[ -z ${git_remote} ]]; then
   >&2 echo Done
   exit 0
fi

>&2 echo Remote branch detected: pushing main to remote
git checkout main
git push ${git_remote} main

>&2 echo Please change default branch to main on remote repository before continuing
git remote show ${git_remote}

read -p "Continue: y/n? " my_prompt

if [[ ${my_prompt} =~ [y] ]]; then
   git push ${git_remote} --delete master
   >&2 echo Creating new tracking connection
   git fetch
   git branch -u ${git_remote}/main
   >&2 echo Done
else
   >&2 echo Exiting...
fi

exit 0

