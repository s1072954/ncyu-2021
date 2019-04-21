#!/bin/bash
set -e

if [ `diff ex5-graph.txt data/ex5-graph.txt | wc -l` -ne 0 ]; then
	echo "Your reset operation is incorrect!"
	exit 1
fi

if [ `diff ex5-diff.txt data/ex5-diff.txt | wc -l` -ne 0 ]; then
	echo "Your clean operation is incorrect!"
	exit 1
fi

exit 0
