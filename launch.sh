#!/bin/bash

source src/config.sh
source ./src/lib.sh

starttime=$(get_time_millisec)
launchpath=$(pwd)

while getopts "a:f:c:hsqt" option; do
    case $option in
        a|s) 
            sysinfo_flag=1
            ;;&
        a|f) 
            filesinfo_flag=1 && path="${OPTARG}"
            ;;&
        a|c) 
            color_flag=1 && colorcodes="${OPTARG}"
            ;;&
        a|t)
            time_flag=1
            ;;&
        a|q) 
            question_flag=1
            ;;&
        h) 
            display_usage && echo "" && display_help && exit 0
            ;;
    esac
done

if (( $OPTIND == 1 )); then display_usage && exit 0; fi

if [ $filesinfo_flag -eq 1 ]; then
    lastchar=${path: -1}
    if [[ "$lastchar" != "/" ]]; then display_error_message 2 && filesinfo_flag=0; fi
fi

if [ $filesinfo_flag -eq 0 ] && [ $sysinfo_flag -eq 0 ]; then
    if [ $question_flag -eq 1 ]; then display_error_message 1 && question_flag=0; fi;
fi

set_printf_locale
update_colors $colorcodes           # TODO check for repeats  ## getopts
init_color_arrays

source ./src/filesinfo_module.sh
cd ~ && cd ../.. && cd $launchpath
source ./src/sysinfo_module.sh

if [ $color_flag -eq 1 ]; then echo "~~~~~~~~" && print_color_settings; fi

endtime=$(get_time_millisec)
v_exectime=$(get_exectime $endtime $starttime)

if [ $time_flag -eq 1 ]; then echo "~~~~~~~~" && print_exectime; fi
if [ $question_flag -eq 1 ]; then echo "~~~~~~~~" && source ./src/status_module.sh; fi

echo "~~~~~~~~" && echo "end~"