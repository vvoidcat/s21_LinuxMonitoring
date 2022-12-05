#!/bin/bash

source src/config.sh
source ./src/lib.sh

starttime=$(get_time_millisec)
launchpath=$(pwd)

argc=$#
argv=$@
source ./src/parsing_module.sh "$argv" $argc

if [ $exit_flag -eq 0 ]; then
    set_printf_locale
    update_colors $colorcodes
    init_color_arrays

    source ./src/filesinfo_module.sh
    cd ~ && cd ../.. && cd $launchpath
    source ./src/sysinfo_module.sh

    if [ $color_flag -eq 1 ]; then echo "~~~~~~~~" && print_color_settings; fi

    if [ $time_flag -eq 1 ]; then
        endtime=$(get_time_millisec)
        v_exectime=$(get_exectime $endtime $starttime)
        echo "~~~~~~~~" && print_exectime
    fi

    if [ $question_flag -eq 1 ]; then echo "~~~~~~~~" && source ./src/status_module.sh; fi

    echo "~~~~~~~~" && echo "end~"
fi
