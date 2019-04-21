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
PROJECT_BRANCH=ex4
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

if [ `git merge-base HEAD origin/ex4-2 | wc -l` -eq 0 ]; then
	echo "[ERROR] You are not on the ex4-2 branch"
	exit 1
fi

COMMIT_MSG="[Example 4] $GIT_NAME"

count=`git cat-file -p HEAD | grep parent | wc -l`
if [ $count -eq 0 ] || [ $count -eq 1 ]; then
	echo "[ERROR] HEAD is not the merge commit"
	exit 1
fi

git commit -s --amend -m "Example 4: merge"

if [ `git branch | grep tmp-$PROJECT_BRANCH-2 | wc -l` -ne 0 ]; then
	git branch -D tmp-$PROJECT_BRANCH-2
fi

git checkout -b tmp-$PROJECT_BRANCH-2
echo "[STATUS] Example 4: Git checkout done"

git fetch -q official $PROJECT_BRANCH
git checkout -t official/$PROJECT_BRANCH -b $PROJECT_BRANCH
git log --graph --abbrev-commit --decorate --format=format:'%C(white)%s%C(reset) %C(dim white)' tmp-$PROJECT_BRANCH-2 > ex4-graph.txt
git add ex4-graph.txt
git checkout tmp-$PROJECT_BRANCH-2 -- ex4.txt
git commit -s -q -m "$COMMIT_MSG"
git push -f -q origin HEAD:refs/heads/$PROJECT_BRANCH
git checkout --detach
git branch -D tmp-$PROJECT_BRANCH-2
git branch -D $PROJECT_BRANCH

echo "[STATUS] Example 4: done"
