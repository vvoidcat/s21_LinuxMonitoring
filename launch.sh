#!/bin/bash

source src/config.sh
source ./src/lib.sh

starttime=$(get_time_millisec)

while getopts "a:f:c:hsqt" option; do
    case $option in
        s) 
            sysinfo_flag=1
            ;;
        f) 
            filesinfo_flag=1 && path="${OPTARG}"
            ;;
        c) 
            color_flag=1 && colorcodes="${OPTARG}"
            ;;
        t)
            time_flag=1
            ;;
        q) 
            if [ $filesinfo_flag -eq 1 ] || [ $sysinfo_flag -eq 1 ]; then question_flag=1
            else display_error_message 1; fi
            ;;
        h) 
            display_usage && echo "" && display_help && exit 0
            ;;
        a) 
            filesinfo_flag=1 && sysinfo_flag=1 && path="${OPTARG}"
            color_flag=1 && time_flag=1 && question_flag=1
            ;;
    esac
done

if (( $OPTIND == 1 )); then display_usage && exit 0; fi

if [ $filesinfo_flag -eq 1 ]; then
    lastchar=${path: -1}
    if [[ "$lastchar" != "/" ]]; then display_error_message 2 && filesinfo_flag=0; fi
fi

set_printf_locale
update_colors $colorcodes           # TODO check for repeats  ## getopts
init_color_arrays

source ./src/filesinfo_module.sh
source ./src/sysinfo_module.sh

if [ $color_flag -eq 1 ]; then echo "~~~~~~~~" && print_color_settings; fi

endtime=$(get_time_millisec)
v_exectime=$(get_exectime $endtime $starttime)

if [ $time_flag -eq 1 ]; then echo "~~~~~~~~" && print_exectime; fi
if [ $question_flag -eq 1 ]; then echo "~~~~~~~~" && source ./src/status_module.sh; fi

echo "~~~~~~~~" && echo "end~"