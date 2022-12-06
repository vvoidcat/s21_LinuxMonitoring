#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

set_printf_locale
start_time=$(get_timedate)
start_time_mil=$(get_time_millisec)

if [ $argc -gt 0 ]; then
    if [ $(check_param_filegen_mode "$1") -eq 1 ]; then
        filegen_mode=1

        if [ $argc -ne 7 ]; then display_error_message 1 "filegen.sh" 1 && display_usage_filegen && exit 0
        else
            process_param_path "$2"
            num_subdirs=$3
            mask_dirname=$4
            num_files=$5
            process_param_filename "$6"
            process_param_filesize "$7"
        fi

        if [[ $(check_path_type "$2") = "relative" ]]; then display_error_message 2 "filegen.sh" 1 "$2" && exit_flag=1
        elif [ $(follow_path "$2") -ne 1 ]; then display_error_message 3 "filegen.sh" 0 && exit 0
        elif [ $(check_param_num "$3") -ne 1 ]; then display_error_message 2 "filegen.sh" 1 "$3" && exit_flag=1
        elif ! [[ $4 =~ $engre ]] || [ ${#4} -gt 7 ]; then display_error_message 2 "filegen.sh" 1 "$4" && exit_flag=1
        elif [ $(check_param_num "$5") -ne 1 ]; then display_error_message 2 "filegen.sh" 1 "$5" && exit_flag=1
        elif [ $(check_param_filename "$6") -ne 1 ]; then display_error_message 2 "filegen.sh" 1 "$6" && exit_flag=1
        elif [ $(check_param_filesize "$7" "kb") -ne 1 ]; then display_error_message 2 "filegen.sh" 1 "$7" && exit_flag=1
        fi

    elif [ $(check_param_filegen_mode "$1") -eq 2 ]; then
        filegen_mode=2

        if [ $argc -ne 4 ]; then display_error_message 1 "filegen.sh" 1 && display_usage_filegen && exit 0
        else
            let_subdirs=$2
            process_param_filename "$3"
            process_param_filesize "$4"

            num2=$((${#let_filenames} * 10))
            num_subdirs=$(($RANDOM % 29 + 70))
            num_files=$((($RANDOM % 30 + 100) + $num2))
        fi

        if ! [[ $2 =~ $engre ]] || [ ${#2} -gt 7 ]; then display_error_message 2 "filegen.sh" 1 "$2" && exit_flag=1
        elif [ $(check_param_filename "$3") -ne 1 ]; then display_error_message 2 "filegen.sh" 1 "$3" && exit_flag=1
        elif [ $(check_param_filesize "$4" "Mb") -ne 1 ]; then display_error_message 2 "filegen.sh" 1 "$4" && exit_flag=1
        fi

    else display_error_message 1 "filegen.sh" 1 && display_usage_filegen && exit 0
    fi
else exit_flag=1
fi

if [ $exit_flag -eq 1 ]; then display_usage_filegen && exit 0; fi

source ./src/filegen_module.sh $1

end_time=$(get_timedate)
end_time_mil=$(get_time_millisec)
exec_time=$(get_exectime $end_time_mil $start_time_mil)

print_results
display_separator && print_exectime
write_loginfo_fin

display_separator && echo "end"