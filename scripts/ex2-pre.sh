#!/bin/bash
set -e
if ! [ -e $DEBUG ]; then
set -x
fi

GIT_SSH_COMMAND="ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no"
GITHUB_ACCOUNT=$1
GITHUB_PROJECT=ncyu-2021

for var in $@; do
	if [[ $var =~ "-h" ]]; then
		echo "Usage: $0 GITHUB_ACCOUNT"
		echo ""
		echo "Parameters:"
		echo "GITHUB_ACCOUNT   Github account"

		exit 0
	fi
done

if [ "$GITHUB_ACCOUNT" == "" ] || [ "$GITHUB_PROJECT" == "" ]; then
	echo "[ERROR] Incorrect parameters. Please run below command to see help."
	echo "  $0 -h"
	exit 1
fi

if ! [[ "`ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no -T git@github.com 2>&1`" =~ "successfully authenticated" ]]; then
	echo "[ERROR] Check your SSH public key on github.com"
	exit 1
fi

GITHUB_REPO=$GITHUB_ACCOUNT/$GITHUB_PROJECT
PROJECT_URL=git@github.com:$GITHUB_REPO
PROJECT_BRANCH=ex2
DIR_PROJECT=$GITHUB_PROJECT-$PROJECT_BRANCH

if ! [ -d $DIR_PROJECT ]; then
	git clone -q $PROJECT_URL -b ex0 $DIR_PROJECT
	echo "[STATUS] Example 2: Github clone done"
fi

pushd $DIR_PROJECT

if [ `git remote -v | grep official | wc -l` -ne 0 ]; then
	git remote rm official
fi

# update local and remote code base
git remote add official https://github.com/jrjang/$GITHUB_PROJECT
git fetch -q official $PROJECT_BRANCH
git push -q -f origin official/$PROJECT_BRANCH:refs/heads/$PROJECT_BRANCH
git checkout --detach official/$PROJECT_BRANCH
echo "[STATUS] Example 2: Github update done"
popd
