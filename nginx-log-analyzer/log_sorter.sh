#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

set_printf_locale

templog=$(date "+temp_%d-%b-%Y:%H:%M:%S.log")

if [ $argc -ne 1 ]; then echo "./log_sorter.sh: error: 1: wrong number of parameters" && display_usage_logsorter
elif ! [[ $1 =~ ^[1-4]$ ]]; then echo "./log_sorter.sh: error: 2: unknown parameter option" && display_usage_logsorter
else
    build_templog

    if [ $1 -eq 1 ]; then
        sort -t" " -nk9 $templog
        echo "" && echo "done sorting logs/s21_nginx*.log files entries by response codes"
    elif [ $1 -eq 2 ]; then
        awk -F " " '{print $1 | "sort -u"}' $templog
        echo "" && echo "done sorting logs/s21_nginx*.log files entries by unique ips"
    elif [ $1 -eq 3 ]; then
        awk '$9 ~ /[45][0-9][0-9]/' $templog
        echo "" && echo "done sorting logs/s21_nginx*.log files entries by erroneous requests (response codes 4xx, 5xx)"
    elif [ $1 -eq 4 ]; then
        awk '$9 ~ /[45][0-9][0-9]/' $templog | awk -F " " '{print $1 | "sort -u"}'
        echo "" && echo "done sorting logs/s21_nginx*.log files entries by unique ips and erroneous requests"
    fi

    rm -rf temp*
fi
