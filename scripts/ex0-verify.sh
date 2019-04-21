#!/bin/bash
set -e

MAPPING_FILE=data/ex0-mapping.txt
INPUT_FILE=ex0.txt

while read -r line; do
	if [ "${line::1}" == "#" ]; then
		continue
	fi

	count=`cat $MAPPING_FILE | grep $line | grep -v grep | wc -l`

	if [ $count -eq 1 ]; then
		exit 0
	fi
done < "$INPUT_FILE"

echo "Student id and email do not match!"
exit 1
