#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

#getopts for help and program modes

set_printf_locale

if [ $argc -ne 6 ]; then display_error_message 1 1 && display_usage && exit 0
else
    process_param_path "$1"
    num_subdirs=$2
    let_subdirs=$3
    num_files=$4
    process_param_filename "$5"
    process_param_filesize "$6"
fi

if [[ $(check_path_type "$1") = "relative" ]]; then display_error_message 2 1 "$1" && exit_flag=1
elif [ $(follow_path "$1") -ne 1 ]; then display_error_message 3 0 && exit 0
elif [ $(check_param_num "$2") -ne 1 ]; then display_error_message 2 1 "$2" && exit_flag=1
elif ! [[ $3 =~ $engre ]] || [ ${#3} -gt 7 ]; then display_error_message 2 1 "$3" && exit_flag=1
elif [ $(check_param_num "$4") -ne 1 ]; then display_error_message 2 1 "$4" && exit_flag=1
elif [ $(check_param_filename "$5") -ne 1 ]; then display_error_message 2 1 "$5" && exit_flag=1
elif [ $(check_param_filesize "$6" "kb") -ne 1 ]; then display_error_message 2 1 "$6" && exit_flag=1
fi

if [ $exit_flag -eq 1 ]; then display_usage && exit 0; fi

source ./src/filegen_module.sh

display_separator && echo "end"