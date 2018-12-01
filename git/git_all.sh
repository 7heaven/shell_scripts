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

# store current dir
CUR_DIR="."

if [[ $# -eq 0 ]]; then
	echo "requires git subcommand or arguments"
else
	
	while read git_repo
	do
		current_git_addr=$(git --work-tree="$git_repo/.." --git-dir="$git_repo" remote -v | grep fetch | cut -d ' ' -f 1 | cut -d$'\t' -f 2)

		__print_content "__verbose" "\n正在对 "
		__print_content "__success" "$current_git_addr"
		__print_content "__verbose" " 执行 "
		__print_content "__success" "git $*"
		__print_content "__verbose" " 命令\n\n"
		git --git-dir="$git_repo" --work-tree="$git_repo/.." "$@"
	done < <(find $CUR_DIR/ -name .git -type d)
fi
