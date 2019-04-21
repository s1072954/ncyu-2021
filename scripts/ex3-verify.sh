#!/bin/bash
set -e

if ! [[ "`cat stash.txt`" =~ "stash@{0}: WIP on ex3-2:" ]]; then
	echo "Your stash operation is incorrect!"
	exit 1
fi

if ! [[ "`cat stash.txt`" =~ "Example 3-2" ]]; then
	echo "Your stash operation is incorrect!"
	exit 1
fi

exit 0
