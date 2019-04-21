#!/bin/bash
set -e

INPUT_FILE=ex1.txt

if ! [ -f $INPUT_FILE ]; then
	echo "Could not find $INPUT_FILE!"
	exit 1
fi

if ! [[ "`cat $INPUT_FILE | tr -d '\n' | awk '{$1=$1;print}'`" =~ "Example 1" ]]; then
	echo "$INPUT_FILE content is incorrect!"
	exit 1
fi

if ! [[ "`git show HEAD`" =~ "Signed-off-by:" ]]; then
	echo "The commit is not signed!"
	exit 1
fi

exit 0
