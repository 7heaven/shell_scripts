#!/bin/bash

use_color_print=0
if [[ -f "color_echo.sh" ]]
then
	source color_echo.sh
	use_color_print=1
fi

function __print_content {
	if [[ $use_color_print -eq 1 ]]
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

while read found
do
	remote_raw=$(git --work-tree="$found/.." --git-dir="$found" remote -v)
	current_git_addr=$(echo "$remote_raw" | grep fetch | cut -d ' ' -f 1 | cut -d$'\t' -f 2)
	remote_name=$(echo "$remote_raw" | grep fetch | cut -d$'\t' -f 1) 
	branch=$(git --work-tree="$found/.." --git-dir="$found" branch -a --sort=-committerdate)
	latest_branch=""

	while IFS= read -r line
	do
		if [[ "$line" != *"(HEAD"* ]]
		then
			latest_branch=$(echo "$line" | sed -e "s/remotes\/$remote_name\///g" | xargs | cut -d$'\t' -f 2 | cut -d ' ' -f 2)
			echo -e "\033[033;0m$latest_branch\033[0m"
			break
		fi
	done <<<"$branch"
	
	echo ""
	__print_content "__verbose" "正在把 "
	__print_content "__success" "$current_git_addr"
	__print_content "__verbose" " 切换到 "
	__print_content "__warning" "$latest_branch"
	__print_content "__verbose" " 分支\n"
	echo ""

	git --work-tree=$found/.. --git-dir=$found checkout $latest_branch

done < <(find . -name .git -type d)
