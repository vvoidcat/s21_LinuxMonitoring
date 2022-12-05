#!/bin/bash

#### print && errors

function display_usage_logsgen() {
    echo "usage:    ./launch_logsgen.sh"
}

function display_usage_logsorter() {
    echo "usage:    ./launch_logsorter.sh [ 1-4 ]"
    display_help_logsorter
}

function display_usage_loganalyzer() {
    echo "usage:    ./launch_loganalyzer.sh"
}

function display_help_logsorter() {
    echo ""
    echo "options:"
    echo "  [1]  - displays all entries sorted by response code"
    echo "  [2]  - displays all unique IPs found in the entries"
    echo "  [3]  - displays all requests with errors (response code - 4xx or 5xxx)"
    echo "  [4]  - displays all unique IPs found among the erroneous requests"
}

function print_colored_text() {
    text="$1"
    color_font="$2"
    color_bg="$3"

    tput bold
    printf "%b" "$color_font"
    printf "%b" "$color_bg";
    printf "%s" "$text"
    printf "%b" "$reset"
}

#### other

function set_printf_locale() {
    en="en_US.UTF-8"
    if [ -z "$LC_NUMERIC" ] || [[ "$LC_NUMERIC" != "$en" ]]; then export LC_NUMERIC=$en; fi
}

function generate_ip() {
    gen=""
    for ((i=0; i<4; i++)); do
        gen+=$(echo -ne "$(shuf -n1 -i 1-255).")
    done
    echo "$(echo "$gen" | rev | cut -c2- | rev)"
}

function build_templog() {
    if [ -f "$templog" ]; then rm -rf $templog; fi

    logs_list=$(find . -name "s21_nginx*.log")
    if [ -z "$logs_list" ]; then
        echo "./launch_loganalyzer.sh: error: 3: no s21_nginx*.log files found in the $(pwd)/logs/ folder"
        exit 0
    fi

    linecount=$(echo "$logs_list" | wc -l) && linecount=$(($linecount + 1))
    for ((i=1; i<$linecount; i++)); do
        log=$(echo "$logs_list" | sed -n "$i"p)
        cat "$log" >> $templog
    done
}
