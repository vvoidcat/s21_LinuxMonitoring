#!/bin/bash

source src/config.sh
source ./src/lib.sh

starttime=$(get_time_millisec)

while getopts ":a:f:chs" option; do
    case $option in
        a)      #all
            ;;
        s)      #system
            ;;
        f) #filesystem
            ;;
        c)      #color
            ;;
        h)  #help
            ;;
    esac
done


path=$1

echo "~~~~~~~~"
lastchar=${path: -1}
if [ "$#" -ne 1 ]; then echo ":: error 1: usage: ./main.sh path/to/directory/ ::"
elif [[ "$lastchar" != "/" ]]; then echo ":: error 2: the path parameter should end with '/' ::"
else params_flag=1; fi
#error path doesnt exist


set_printf_locale
update_colors 524
init_color_arrays

source ./src/sysinfo_module.sh
source ./src/filesinfo_module.sh

echo "~~~~~~~~" && print_color_settings

endtime=$(get_time_millisec)
v_exectime=$(get_exectime $endtime $starttime)
echo "~~~~~~~~" && print_exectime

echo "~~~~~~~~" && source ./src/status_module.sh

echo "~~~~~~~~" && echo "end~"