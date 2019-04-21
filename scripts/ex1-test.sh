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
PROJECT_BRANCH=ex1
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
set -e

COMMIT_MSG="[Example 1] $GIT_NAME"

if ! [ -d .git ]; then
	echo "[ERROR] Initialize the new Git repository first."
	exit 1
fi

if [ `git remote -v | grep origin | wc -l` -ne 0 ]; then
	git remote rm origin
fi

if [ `git remote -v | grep official | wc -l` -ne 0 ]; then
	git remote rm official
fi

# update local and remote code base
git remote add origin $PROJECT_URL
git remote add official https://github.com/jrjang/$GITHUB_PROJECT
git fetch -q official $PROJECT_BRANCH
echo "[STATUS] Example 1: Git fetch done"

if [ `git log --oneline | wc -l ` -ne 1 ]; then
	echo "[ERROR] Your commit number is more than 1"
	exit 1
fi

COMMIT_ID=`git rev-parse HEAD`

git checkout -d official/$PROJECT_BRANCH
git cherry-pick $COMMIT_ID

flag=

if [[ "`git show HEAD`" =~ "Signed-off-by:" ]]; then
	flag=-s
fi

git commit $flag -q --amend -m "$COMMIT_MSG"
echo "[STATUS] Example 1: Git commit amend done"

git push -f -q origin HEAD:refs/heads/$PROJECT_BRANCH
echo "[STATUS] Example 1: Git push done"

echo "[STATUS] Example 1: done"
