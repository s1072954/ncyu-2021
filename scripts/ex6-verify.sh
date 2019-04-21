#!/bin/bash
set -e

if [ `cat ex6.txt | wc -l` -ne 0 ]; then
	echo "Your push operation is incorrect!"
	exit 1
fi

#if [ `diff ex6-branch.txt data/ex6-branch.txt | wc -l` -ne 0 ]; then
#	echo "Your adding remote operation is incorrect!"
#	exit 1
#fi

exit 0
