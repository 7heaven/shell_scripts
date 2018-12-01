#!/bin/bash

use_color_print=false
if [[ -f "color_echo.sh" ]]
then
	source color_echo.sh
	use_color_print=true
fi

function __print_content {
	if [[ use_color_print -eq true ]]
	then
		function_name="$1"
		${function_name} "$2"
	else
		if [[ $# -eq 2 ]]
		then
			echo -ne "$2"
		else
			echo -ne "$1"
		fi
	fi
}

function __print_usage {
	__print_content "__verbose" "Usage: ./find_branch.sh <--exclude|--include> <branch_name>\n"
}

if [[ $# -lt 2 ]]
then
	__print_content "__error" "require arguments!\n"
	__print_usage
	exit 1
fi

type=0

if [[ "$1" == "--exclude" ]] || [[ "$1" == "-e" ]] 
then
	type=1
elif [[ "$1" == "--include" ]] || [[ "$1" == "-i" ]]
then
	type=2
else
	__print_content "__error" "invalid options!\n"
	__print_usage
	exit 1
fi


echo "搜索当前目录下所有git库"

while read found
do
	current_branch=$(git --work-tree=$found/.. --git-dir=$found branch | grep \* | cut -d ' ' -f 2)
	current_remote=$(git --work-tree=$found/.. --git-dir=$found remote | cut -d ' ' -f 2)
	current_git_addr=$(git --work-tree=$found/.. --git-dir=$found remote -v | grep fetch | cut -d ' ' -f 1 | cut -d$'\t' -f 2)
		
	if [[ $type -eq 1 ]]
	then
		if [[ "$current_branch" != "$2" ]]
		then
			__print_content "__success" "$current_git_addr"
			__print_content "__normal" " 当前分支是 "
			__print_content "__warning" "$current_branch\n"
		fi
	else
		if [[ "$current_branch" == "$2" ]]
		then
			__print_content "__success" "$current_git_addr"
			__print_content "__normal" " 当前分支是 "
			__print_content "__warning" "$current_branch\n"
		fi
	fi
done < <(find . -name .git -type d)
