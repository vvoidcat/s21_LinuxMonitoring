#!/bin/bash

argv=$1
argc=$2
flags=0
need_param_filesinfo=0
need_param_color=0
newindex=0

# while getopts "a:f:c:hsqt" option; do

function process_arg() {
    arg=$1
    firstchr=${arg: 0: 1}

    if [[ "$firstchr" = "-" ]]; then read_flags "$arg"
    else 
        read_params "$arg"
    fi
}

function read_flags() {
    arg=$1

    for ((k=1; k<${#arg}; k++)); do
        option=${arg: $k: 1}
        case $option in
            a|s) 
                sysinfo_flag=1 && flags=$(($flags + 1))
                ;;&
            a|f) 
                filesinfo_flag=1 && need_param_filesinfo=1 && flags=$(($flags + 1))
                ;;&
            a|c)
                color_flag=1 && need_param_color=1 && flags=$(($flags + 1))
                ;;&
            a|t)
                time_flag=1 && flags=$(($flags + 1))
                ;;&
            a|q) 
                question_flag=1 && flags=$(($flags + 1))
                ;;&
            h) 
                flags=$(($flags + 1)) && display_usage && display_help && exit_flag=1 && break
                ;;
        esac
    done
}

function read_params() {
    if [ $need_param_filesinfo -eq 1 ]; then
        path=$1 && need_param_filesinfo=0
    elif [ $need_param_color -eq 1 ]; then
        colorcodes=$1 && need_param_color=0
    else
        echo "wtffff2"      ## error message
    fi
}


#### main

if [ ! -z "$argv" ] || [ ! -z "$argc" ]; then
    for ((i=0; i<${#argv}; i++)); do
        count=0
        #nextindex=$(($i + 1))
        chr=${argv: $i: 1}
        #quote_flag=0 && if [[ "$chr" = "\"" ]]; then quote_flag=1 && chr=${argv: $nextindex: 1}; fi

        if [ $exit_flag -eq 1 ]; then break; fi

        for ((j=$i; j<${#argv}; j++)); do
            chr=${argv: $j: 1}
            if [[ "$chr" = " " ]]; then break; fi
            #if [[ "$chr" = " " ]] && [ $quote_flag -ne 1 ]; then break; fi
            #if [[ "$chr" != "\"" ]] && [ $quote_flag -eq 1 ]; then break; fi
            count=$(($count + 1))
        done

        if [ $count -gt 0 ]; then process_arg "${argv: $i: $count}"; fi
        i=$(($i + $count))
    done
fi


if [ $exit_flag -eq 0 ]; then
    if [ $flags -eq 0 ]; then display_usage && exit_flag=1; fi

    if [ $filesinfo_flag -eq 0 ] && [ $sysinfo_flag -eq 0 ]; then
        if [ $question_flag -eq 1 ]; then display_error_message 1 && question_flag=0; fi;
    fi
fi
