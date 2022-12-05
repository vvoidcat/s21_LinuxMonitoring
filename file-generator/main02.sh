#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

#getopts for help and program modes

set_printf_locale
start_time=$(get_timedate)
start_time_mil=$(get_time_millisec)

if [ $argc -ne 3 ]; then display_error_message 1 1 && display_usage && exit 0
else
    let_subdirs=$1
    process_param_filename "$2"
    process_param_filesize "$3"

    num2=$((${#let_filenames} * 10))
    num_subdirs=$(($RANDOM % 29 + 70))
    num_files=$((($RANDOM % 30 + 100) + $num2))
fi

if ! [[ $1 =~ $engre ]] || [ ${#1} -gt 7 ]; then display_error_message 2 1 "$1" && exit_flag=1
elif [ $(check_param_filename "$2") -ne 1 ]; then display_error_message 2 1 "$2" && exit_flag=1
elif [ $(check_param_filesize "$3" "Mb") -ne 1 ]; then display_error_message 2 1 "$3" && exit_flag=1
fi

if [ $exit_flag -eq 1 ]; then display_usage && exit 0; fi

source ./src/filegen_module.sh

end_time=$(get_timedate)
end_time_mil=$(get_time_millisec)
exec_time=$(get_exectime $end_time_mil $start_time_mil)

print_results
display_separator && print_exectime
write_loginfo_fin

display_separator && echo "end"