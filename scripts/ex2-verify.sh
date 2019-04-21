#!/bin/bash
set -e

if ! [[ "`git show HEAD`" =~ "`cat data/0001-ex2.patch`" ]]; then
	echo "It is different between the requirement with your modification!"
	exit 1
fi

exit 0
