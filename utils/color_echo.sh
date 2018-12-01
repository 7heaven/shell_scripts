#!/bin/bash

function __color_echo {
	echo -ne "\033[$1m$2\033[0m"
}

function __warning {
	__color_echo "0;33" "$1"
}

function __error {
	__color_echo "0;31" "$1"
}

function __success {
	__color_echo "0;32" "$1"
}

function __verbose {
	__color_echo "0;37" "$1"
}

function __normal {
	__color_echo "0" "$1"
}
