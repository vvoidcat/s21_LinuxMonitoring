#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

set_printf_locale

html="logsreport.html"
templog=$(date "+temp_%d-%b-%Y:%H:%M:%S.log")

if [ $argc -ne 0 ]; then echo "./log_analyzer.sh: error: 1: unknown option" && display_usage_loganalyzer
else
    if [ -f "$html" ]; then rm -rf $html; fi
    
    check=$(dpkg -s goaccess 2>/dev/null | grep -c "ok installed")
    if [ $check -ne 1 ]; then
        source ./src/input_module.sh "there's no goaccess package found on your machine. would you like to install it? y/n"
        install_flag=$outflag

        if [ $install_flag -eq 1 ]; then
            sudo apt-get update
            sudo apt-get install goaccess
            check=$(dpkg -s goaccess 2>/dev/null | grep -c "ok installed")
            if [ $check -ne 1 ]; then install_flag=0; fi
        fi

        if [ $install_flag -ne 1 ]; then
            echo "./log_analyzer.sh: error: 2: goaccess package not found; exit"
            exit 0
        fi
    fi

    build_templog
    goaccess $templog -o $html --log-format=COMBINED
    open $html
    rm -rf temp*
fi
