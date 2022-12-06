#!/bin/bash

source src/config.sh
source ./src/lib.sh

argc=$#
argv=$@

set_printf_locale

entries=$(($RANDOM % 900 + 100))
q='"'

codes=(200 201 400 401 403 404 500 501 502 503)
methods=("GET" "POST" "PUT" "PATCH" "DELETE")
resources=("/stuff.html" "/some/ramdom/file.gif" "/whatever/aboba.jpg")
protocols=("HTTP/1.0" "HTTP/1.1" "HTTP/2" "HTTP/3")
urls=("https://www.example.com/start.html" "https://whateverrrr.org/docs/idk.html")
agents=("Mozilla" "Google Chrome" "Opera" "Safari" "Internet Explorer"
        "Microsoft Edge" "Crawler and bot" "Library and net tool")


if [ $argc -ne 0 ]; then echo "./launch_logsgen.sh: error: 1: unknown option" && display_usage_logsgen
else
    echo "log generator launched, please wait..."
    for ((i=1; i<6; i++)); do
        if ! [ -d "logs" ]; then mkdir "logs"; fi

        for ((j=0; j<$entries; j++)); do
            ip=$(generate_ip)
            timestamp="[$(date "+%d/%b/%Y:%H:%M:%S %z")]"
            method=${methods[$(shuf -n1 -i 0-$((${#methods[@]} - 1)))]}
            method+=" ${resources[$(shuf -n1 -i 0-$((${#resources[@]} - 1)))]} "
            method+=${protocols[$(shuf -n1 -i 0-$((${#protocols[@]} - 1)))]}
            code=${codes[$(shuf -n1 -i 0-$((${#codes[@]} - 1)))]}
            bytes=$(($RANDOM % 2000 + 100))
            url=${urls[$(shuf -n1 -i 0-$((${#urls[@]} - 1)))]}
            agent=${agents[$(shuf -n1 -i 0-$((${#agents[@]} - 1)))]}

            echo "$ip - - $timestamp $q$method$q $code $bytes $q$url$q $q$agent$q" >> logs/s21_nginx_$i.log
        done

        print_colored_text $entries $color_red_font
        echo -ne " entries were added to "
        print_colored_text "$(pwd)/logs/s21_nginx_$i.log" $color_cyan_font
        echo " file"

        entries=$(($RANDOM % 900 + 100))
    done
fi

echo "done"
