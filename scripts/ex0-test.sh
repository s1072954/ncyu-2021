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
PROJECT_BRANCH=ex0
DIR_PROJECT=$GITHUB_PROJECT-$PROJECT_BRANCH

set +e
GIT_NAME=`git config -l --show-scope | grep local | grep user.name`

if [ "$GIT_NAME" == "" ]; then
	GIT_NAME=`git config -l --show-scope | grep global | grep user.name`
fi

if [ "$GIT_NAME" != "" ]; then
	GIT_NAME=`echo $GIT_NAME | cut -d '=' -f 2`
else
	echo "[ERROR] Can not find user.name in git config"
	exit 1
fi

GIT_EMAIL=`git config -l --show-scope | grep local | grep user.email`

if [ "$GIT_EMAIL" == "" ]; then
	GIT_EMAIL=`git config -l --show-scope | grep global | grep user.email`
fi

if [ "$GIT_EMAIL" != "" ]; then
	GIT_EMAIL=`echo $GIT_EMAIL | cut -d '=' -f 2`
else
	echo "[ERROR] Can not find user.email in git config"
	exit 1
fi
set -e

COMMIT_MSG="[Example 0] $GIT_NAME"

if ! [ -d $DIR_PROJECT ]; then
	git clone $PROJECT_URL -b $PROJECT_BRANCH $DIR_PROJECT
fi

cd $DIR_PROJECT

if [ `git remote -v | grep official | wc -l` -ne 0 ]; then
	git remote rm official
fi

git remote add official https://github.com/jrjang/$GITHUB_PROJECT
git fetch -q official $PROJECT_BRANCH
echo "[STATUS] Example 0: Fetch upstream repository done"

set +e
git stash
echo "[STATUS] Example 0: Stash modified and tracked files"
set -e

git checkout --detach official/$PROJECT_BRANCH
echo "$GIT_NAME,$GIT_EMAIL" | base64 >> ex0.txt
git add ex0.txt
echo "[STATUS] Example 0: Add ex0.txt done"

git commit -s -m "$COMMIT_MSG"
echo "[STATUS] Example 0: Commit Git message done"

git push -f -q origin HEAD:refs/heads/$PROJECT_BRANCH
echo "[STATUS] Example 0: Git push done"

echo "[STATUS] Example 0: Remeber doing pull request"
