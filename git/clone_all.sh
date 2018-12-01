#!/bin/bash

function __print_usage {
	echo "Usage: ./clone_all.sh [file_name]"
	echo  ""
	echo "file name is optional. if not present, the default file name \"repos.manifest\" will be use."
	echo "a valid file must contains git repos address line by line"
}

if [[ "$#" -lt 1 ]]
then
	INPUT="repos.manifest"
else
	INPUT="$1"
fi

if [ "$1" = "--help" ] || [ "$1" = "-h" ]
then
	__print_usage	
	exit 0
fi

if [[ -f "$INPUT" ]]
then
	while IFS= read -r var
	do
		echo "clone from $var"
		git clone "$var"
	done < "$INPUT"
else
	echo "file not found"
fi
