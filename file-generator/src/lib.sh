#!/bin/bash


#### print && errors

function display_usage_filegen() {
    echo "usage:    ./filegen.sh [ 1-2 ] <params>"
    display_help_filegen_local
    display_help_filegen_global
}

function display_usage_cleaner() {
    echo "usage:    ./cleaner.sh [ 1 </absolute/path/to/*_files.log> ]"
    echo "                    [ 2 <YYYY-MM-DD_HH:MM--YYYY-MM-DD_HH:MM> ]"
    echo "                    [ 3 <abc_YYMMDD> ]"
}

function display_help_filegen_local() {
    echo ""
    echo "options for [1] (local generation):"
    echo "   Parameter 2 - absolute path."
    echo "   Parameter 3 - number of subfolders (more than 0)."
    echo "   Parameter 4 - a list of English alphabet letters used in folder names (no more than 7 characters)."
    echo "   Parameter 5 - number of files in each created folder (more than 0)."
    echo "   Parameter 6 - a list of English alphabet letters used in the file name and extension"
    echo "               (no more than 7 characters for the name, no more than 3 characters for the extension)."
    echo "   Parameter 7 - file size (in kilobytes, more than 0 but not more than 100)."
}

function display_help_filegen_global() {
    echo ""
    echo "options for [2] (global randomized generation):"
    echo "   Parameter 2 - a list of English alphabet letters used in folder names (no more than 7 characters)."
    echo "   Parameter 3 - the list of English alphabet letters used in the file name and extension"
    echo "               (no more than 7 characters for the name, no more than 3 characters for the extension)."
    echo "   Parameter 4 - file size (in megabytes, more than 0 but not more than 100)."
}

function display_error_message() {
    if [ $1 -eq 1 ]; then echo "./$2: error: 1: wrong number of parameters"
    elif [ $1 -eq 2 ]; then echo "./$2: error: 2: the entered parameter doesn't meet the requirements: $4"
    elif [ $1 -eq 3 ]; then echo "./$2: error: 3: the specified path doesn't exist"
    elif [ $1 -eq 4 ]; then echo "./$2: error: 4: a directory with this path/name already exists: $4"
    elif [ $1 -eq 5 ]; then echo "./$2: error: 5: a file with this path/name already exists: $4"
    elif [ $1 -eq 6 ]; then echo "./$2: error: 6: the disk has less than 1GB of free space; quitting"
    elif [ $1 -eq 7 ]; then echo "./$2: error: 7: exhausted possibilities for naming directories; quitting"
    elif [ $1 -eq 8 ]; then echo "./$2: error: 8: exhausted possibilities for naming files; proceeding to the next directory"
    elif [ $1 -eq 9 ]; then echo "./$2: error: 9: incorrect path/name/type of the file specified / such file doesn't exist"
    elif [ $1 -eq 10 ]; then echo "./$2: error: 10: incorrect date format"
    elif [ $1 -eq 11 ]; then echo "./$2: error: 11: incorrect name mask format"
    elif [ $1 -eq 12 ]; then echo "./$2: error: 12: the .log file was already removed from the disk: $4"
    elif [ $1 -eq 13 ]; then echo "./$2: error: 13: the script execution was interrupted; rerun"
    elif [ $1 -eq 14 ]; then echo "./$2: error: 14: nothing to remove"
    fi
    
    if [ $3 -eq 1 ]; then display_separator; fi
}

function display_separator() {
    echo "~~~~~~~~"
}

function print_results() {
    print_colored_text $dircount $color_red_font
    printf " directories and "
    print_colored_text $filecount $color_blue_font
    printf " files total with the size of "
    print_colored_text "$filesize$filesize_type" $color_cyan_font
    printf " each were created at: "
    print_colored_text $path $color_purple_font && printf "\n"
    printf "log file created at: "
    print_colored_text $log $color_purple_font && printf "\n"
    printf "remaining disk space: "
    print_colored_text $(get_space_root_free) $color_white_font $color_red_bg && printf "\n"
}

function print_results_cleaner() {
    print_colored_text $dircount $color_red_font
    printf " directories and "
    print_colored_text $filecount $color_blue_font
    printf " files total were removed from the disk\n"
    printf "remaining disk space (GB): "
    print_colored_text $(get_space_root_free) $color_white_font $color_red_bg && printf "\n"
}

function print_exectime() {
    printf "Script execution start time: " 
    print_colored_text "$start_time" $color_blue_font && printf "\n"
    printf "Script execution end time: "
    print_colored_text "$end_time" $color_blue_font && printf "\n"
    printf "Script execution time (in seconds): "
    print_colored_text "$exec_time" $color_blue_font && printf "\n"
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

function print_percentage() {
    fill="#"
    bar=$fill
    current="$1"
    max="$2"

    perc=$(echo "$current * 100 / $(($max - 1))" | bc)
    for ((i=0; i<$perc; i++)); do
        bar+=$fill
    done
    printf "%3d%% %s\r" $perc $bar
}


#### checkers

function check_var_exists() {
    result=$1
    if [ -z "$result" ]; then result="n/a"; fi
    echo $result
}

function check_str_contains() {
    str=$1
    pattern=$2
    result=$(echo "$str" | grep -c "$pattern")
    echo $result
}

function check_path_type() {
    if [[ "$1" = /* ]]; then echo "absolute"
    else echo "relative"; fi
}

function check_param_filegen_mode() {
    flag=0
    if [[ $1 =~ $numre ]]; then
        if [ $1 -eq 1 ]; then flag=1
        elif [ $1 -eq 2 ]; then flag=2; fi
    fi
    echo $flag
}

function check_param_num() {
    flag=0
    if [[ $1 =~ $numre ]]; then
        if [ $1 -gt 0 ]; then flag=1; fi
    fi
    echo $flag
}

function check_param_filename() {
    str=$1
    flag=0

    if [[ "$mask_filename" =~ $engre ]] && [ ${#mask_filename} -lt 8 ]; then
        if [ ${#mask_fileext} -eq 0 ]; then flag=1; fi
        if ! [ -z "$mask_fileext" ]; then
            if ! [[ "$mask_fileext" =~ $engre ]]; then flag=0; fi
            if [[ "$mask_fileext" =~ $engre ]] && [ ${#mask_fileext} -lt 4 ]; then flag=1; fi
        fi
    fi
    echo $flag
}

function check_param_filesize() {
    str=$1
    size_expected=$2
    flag=0
    
    if [[ "$filesize" =~ $numre ]] && [[ $size_expected = $filesize_type ]]; then
        if [ $filesize -lt 101 ] && [ $filesize -gt 0 ]; then flag=1; fi
    fi
    echo $flag
}

function check_param_cleaner() {
    flag=0
    if [ $cleaner_mode -eq 1 ]; then flag=$(check_param_cleaner_log)
    elif [ $cleaner_mode -eq 2 ]; then flag=$(check_param_cleaner_date)
    elif [ $cleaner_mode -eq 3 ]; then flag=$(check_param_cleaner_nmask)
    fi
    echo $flag
}

function check_param_cleaner_log() {
    flag=9
    cd ~ && cd ../..
    if [ -f "$cleaner_param" ]; then flag=1; fi
    echo $flag
}

function check_param_cleaner_date() {
    flag=10
    n="[0-9][0-9]"
    matchstr="${n}${n}-${n}-${n}_${n}:${n}--${n}${n}-${n}-${n}_${n}:${n}"
    matchcount=$(echo $cleaner_param | grep -E ${matchstr} | wc -l)

    if [ ${#cleaner_param} -eq 34 ] && [ $matchcount -eq 1 ]; then flag=1; fi
    echo $flag
}

function check_param_cleaner_nmask() {
    flag=11
    n="[0-9][0-9][0-9][0-9][0-9][0-9]"
    matchstr="_${n}"

    process_param_filename $cleaner_param
    nmask_end=$((${#cleaner_param} - 7))

    if ! [ -z "$mask_fileext" ]; then nmask_end=$(($nmask_end - ${#mask_fileext} - 1)); fi

    if [[ "${cleaner_param: 0: $nmask_end}" =~ $engre ]]; then
        if [ $(echo ${cleaner_param: $nmask_end: 7} | grep -E ${matchstr} | wc -l) -eq 1 ]; then
            flag=1
        fi
        if ! [ -z "$mask_fileext" ]; then flag=11; fi
    fi

    echo $flag
}

function check_partition_size() {
    psize=$(get_space_root_free)
    gb="1.00"
    flag=0
    if (( $(echo "$psize > $gb" | bc -l) )); then flag=1; fi
    echo $flag
}


#### getters

function get_space_root_free() {
    result=$(df /root | grep -v "Filesystem" | awk '{printf "%.2f", $4/1024/1024}')
    echo $result
}

function get_dirpath() {
    file=$1
    end=${#file}
    count=0
    
    for ((i=$end; i>=0; i--)); do
        if [ "${file: i: 1}" = "/" ]; then break
        else count=$(($count + 1)); fi
    done

    end=$(($end - $count))

    echo ${file: 0: $end}
}

function get_fileinfo() {
    file=$1
    size=$(ls -la $file | awk '{printf $5}')
    date=$(get_lastmod "$file")
    echo "$file $size $date"
}

function get_lastmod() {
    file=$1
    echo $(stat -c '%y' $file | awk '{printf "%s_%.5s", $1, $2}')
}

function get_timedate() {
    result=$(date +"%Y-%m-%d_%H:%M")
    if ! [ -z "$1" ]; then result=$result$(date +":%S"); fi
    echo $result
}

function get_time_millisec() {
    min=$(date +"%M")
    sec=$(date +"%S.%3N")
    mininsec=$(echo "$min * 60" | bc)
    result=$(echo "$mininsec + $sec" | bc) && echo $result
}

function get_exectime() {
    subvalue=$(echo "$1-$2" | bc)
    printf "%.1fs" $subvalue
}


#### other

function set_printf_locale() {
    en="en_US.UTF-8"
    if [ -z "$LC_NUMERIC" ] || [[ "$LC_NUMERIC" != "$en" ]]; then export LC_NUMERIC=$en; fi
}

function follow_path() {
    flag=0
    cd ~
    if [ -d "$1" ]; then cd $1 && flag=1
    else flag=2; fi
    echo $flag
}

function find_random_path() {
    cd ~
    count=1

    while (($count != 0)); do
        count=$(ls 2>/dev/null -d */ | wc -l)
        if [ $count -eq 0 ]; then break; fi

        rand=$(($RANDOM % $count))
        if [ $rand -eq 0 ]; then rand=1; fi

        newdir=$(ls 2>/dev/null -d */ | sed -n "$rand"p)
        cd "$newdir"
        path=$(pwd)

        rand=$(($RANDOM % 10))
        if [[ "$rand" =~ ^[1-4]$ ]]; then break; fi
    done

    cd ~ && cd ../..
}

function process_param_path() {
    lastchar=${1: -1}
    if [[ "$lastchar" != "/" ]]; then path=$1"/"
    else path=$1; fi
}

function process_param_filename() {
    str=$1
    count=0
    ext_index=${#str}
    flag_dot=0

    if ! [ -z "$str" ]; then
        for ((i=0; i<${#str}; i++)); do
            count=$i
            if [[ "${str: $i: 1}" = "." ]]; then ext_index=$(($i + 1)) && flag_dot=1 && break; fi 
        done
        if [ $flag_dot -eq 0 ]; then count=$(($count + 1)); fi
        mask_filename=$(echo ${str: 0: $count}) && mask_fileext=$(echo ${str: $ext_index})
    fi
}

function process_param_filesize() {
    if ! [ -z "$1" ]; then
        filesize=$(echo "$1" | rev | cut -c3- | rev)
        filesize_type=${1: -2}
    fi
}

function convert_to_bytes() {
    result=0
    if [[ "$2" = "kb" ]]; then result=$(echo "$1 * 1024" | bc -l)
    elif [[ "$2" = "Mb" ]]; then result=$(echo "$1 * 1024 * 1024" | bc -l); fi
    echo $result
}

function generate_name_from_pattern() {
    pattern=$1
    charnum=$(($2 + 3))
    char=${pattern: $3: 1}

    if ! [ -z "$char" ]; then
        insert=$(printf %"$charnum"s | tr " " $char)
        printf "%s%s%s" ${pattern: 0: $3} $insert ${pattern: $3}
    else echo $char; fi
}

function generate_dirname() {
    echo "$path""$1"_$(date +%d%m%y)
}

function generate_filename() {
    result="$1""/""$2"_$(date +%d%m%y)
    if ! [ -z "$mask_fileext" ]; then result=$result"."$mask_fileext; fi
    echo $result
}

function generate_logname() {
    echo $(pwd)/logs/$(get_timedate "withseconds")"_files.log"
}

function write_loginfo_fin() {
    echo "TIME: ""start: $start_time" "end: $end_time" "exec: $exec_time" >> $log
    echo "DIRS_TOTAL" $dircount "FILES_TOTAL" $filecount >> $log
}
