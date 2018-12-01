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

if [[ $# -gt 0 ]] 
then
	if [[ $1 == "--help" ]]
	then
		__print_content "__error"  "no help\n"
		exit 0
	else
		__print_content "__error" "invalid options\n"
		exit 1
	fi
fi

echo "查找当前目录下所有的git库中..."

while read found
do
	current_branch=$(git --work-tree=$found/.. --git-dir=$found branch | grep \* | cut -d ' ' -f 2)
	current_remote=$(git --work-tree=$found/.. --git-dir=$found remote | cut -d ' ' -f 2)
	current_git_addr=$(git --work-tree=$found/.. --git-dir=$found remote -v | grep fetch | cut -d ' ' -f 1 | cut -d$'\t' -f 2)
	
	echo ""
	
	__print_content "__verbose" "正在从 "
	__print_content "__success" "$current_git_addr"
	__print_content "__verbose" " 拉取 "
	__print_content "__warning" "$current_remote/$current_branch"
	__print_content "__verbose" " 分支\n"
	git --work-tree=$found/.. --git-dir=$found pull "$current_remote" "$current_branch"
done < <(find ./ -name .git -type d)
