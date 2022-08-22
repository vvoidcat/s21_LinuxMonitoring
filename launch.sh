#!/bin/bash

source src/config.sh
source ./src/lib.sh

starttime=$(get_time_millisec)

while getopts ":a:f:c:hsq" option; do
    case $option in
        a) 
            filesinfo_flag=1 && sysinfo_flag=1 && path="${OPTARG}"
            ;;
        s) 
            sysinfo_flag=1
            ;;
        f) 
            filesinfo_flag=1 && path="${OPTARG}"
            ;;
        c) 
            color_flag=1 && colorcodes="${OPTARG}"
            ;;
        q) 
            if [ $filesinfo_flag -eq 1 ] || [ $sysinfo_flag -eq 1 ]; then question_flag=1
            else display_error_message 1; fi
            ;;
        h) 
            dispay_usage && echo "" && display_help && exit 0
            ;;
    esac
done

if [ $filesinfo_flag -eq 1 ]; then
    lastchar=${path: -1}
    if [[ "$lastchar" != "/" ]]; then display_error_message 2 && filesinfo_flag=0; fi
fi

set_printf_locale
update_colors $colorcodes
init_color_arrays

source ./src/sysinfo_module.sh
source ./src/filesinfo_module.sh

if [ $color_flag -eq 1 ]; then echo "~~~~~~~~" && print_color_settings; fi

endtime=$(get_time_millisec)
v_exectime=$(get_exectime $endtime $starttime)
echo "~~~~~~~~" && print_exectime

if [ $question_flag -eq 1 ]; then echo "~~~~~~~~" && source ./src/status_module.sh; fi

echo "~~~~~~~~" && echo "end~"