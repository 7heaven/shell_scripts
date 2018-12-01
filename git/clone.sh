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

if [[ $# -eq 0 ]]; then
	__print_content "__error" "require path from android.googlesource.com\n"
else
	mkdir -p $1
	git clone https://android.googlesource.com/$1 $1
fi
