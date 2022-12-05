#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

set_printf_locale

if [ $argc -ne 2 ]; then display_error_message 1 1 && display_usage && exit 0
else
    cleaner_mode=$1
    cleaner_param=$2
    cleaner_param_flag=$(check_param_cleaner)

    if ! [[ "$cleaner_mode" =~ $cleanre ]]; then display_error_message 2 1 "$1" && exit_flag=1
    elif [ $cleaner_param_flag -ne 1 ]; then display_error_message $cleaner_param_flag 1 && exit_flag=1
    fi
fi

if [ $exit_flag -eq 1 ]; then display_usage && exit 0; fi

source ./src/cleaner_module.sh

display_separator && echo "end"
