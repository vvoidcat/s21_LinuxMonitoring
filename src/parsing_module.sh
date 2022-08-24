#!/bin/bash

argv=$1
argc=$2
flags=0
need_param_filesinfo=0
need_param_color=0
newindex=0

echo "$argc" "$argv"

# while getopts "a:f:c:hsqt" option; do

function read_flags() {
    arg=$1
    #echo $arg
    for ((i=1; i<${#arg}; i++)); do
        option=${argv: $i: 1}
        #if [[ "$option" = " " ]] || [[ "$option" = "\"" ]]; then newindex=$i && break #######
        #else
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
        #fi
    done
}

function read_param() {
    #echo "readingg"
    if [ $need_param_filesinfo -eq 1 ]; then
        path=$1 && need_param_filesinfo=0
    elif [ $need_param_color -eq 1 ]; then
        colorcodes=$1 && need_param_color=0
    else
        echo "wtffff"
    fi

    echo "colorcodes = "$colorcodes
}

function process_arg() {
    #echo "processinggg"
    #echo $arg


    arg=$1
    firstchr=${arg: 0: 1}

    if [[ "$firstchr" = "-" ]]; then read_flags "$arg"
    else 
        read_param "$arg"
    fi
}




if [ -z "$argv" ] || [ -z "$argc" ]; then echo "aaaaaaaaaa"
else
    # parse
    for ((i=0; i<${#argv}; i++)); do
        count=0
        newindex=$i
        nextindex=$(($i + 1))
        chr=${argv: $i: 1}
        quote_flag=0 && if [[ "$chr" = "\"" ]]; then quote_flag=1 && chr=${argv: $nextindex: 1}; fi

        #echo $chr

        if [ $exit_flag -eq 1 ]; then break; fi

        #nextindex=$(($i + 1))

        for ((j=$i; j<${#argv}; j++)); do
            if [[ "$chr" = " " ]] && [ $quote_flag -ne 1 ]; then break; fi
            if [[ "$chr" != "\"" ]] && [ $quote_flag -eq 1 ]; then break; fi
            count=$(($count + 1))
        done

        echo "arg = ""${argv: $i: $count}"" | count = " $count
        #echo "count = " $count
        if [ $count -gt 0 ]; then process_arg "${argv: $i: $count}"; fi
        i=$(($count))
        #i=$newindex
    done
fi


if [ $exit_flag -eq 0 ]; then
    if [ $flags -eq 0 ]; then display_usage && exit_flag=1; fi

    if [ $filesinfo_flag -eq 1 ]; then
        lastchar=${path: -1}
        if [[ "$lastchar" != "/" ]]; then display_error_message 2 && filesinfo_flag=0; fi
    fi

    if [ $filesinfo_flag -eq 0 ] && [ $sysinfo_flag -eq 0 ]; then
        if [ $question_flag -eq 1 ]; then display_error_message 1 && question_flag=0; fi;
    fi
fi

echo $flags
echo $filesinfo_flag $sysinfo_flag $color_flag $time_flag $question_flag
echo "path = "$path