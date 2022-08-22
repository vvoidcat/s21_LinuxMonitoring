#!/bin/bash

#### other

function display_usage() {
    echo "usage: ./launch.sh [ -a <(/)path/to/a/folder/> ] [ -c <1-6> ] [ -f <(/)path/to/a/folder/> ] [ - t ] [ -h ] [ -q ] [ -s ]"
    echo "~~~~~~~~" && echo "end~"
}

function display_help() {
    echo "help..."
}

function display_error_message() {
    if [ $1 -eq 1 ]; then echo "./launch.sh: error: no information to write in a file; rerun the program with [-a], [f] or [-s]"
    elif [ $1 -eq 2 ]; then echo "./launch.sh: error: the path string should end with '/'"
    elif [ $1 -eq 4 ]; then echo "./launch.sh: error: the specified path doesn't exist"
    fi
}

function check_var_exists() {
    result=$1
    if [ -z "$result" ]; then result="n/a"; fi
    echo $result
}

function check_path() {
    if [[ "$1" = /* ]]; then path_type="absolute"
    else path_type="relative"; fi
}

function follow_path() {
    if [[ "$1" = "absolute" ]]; then cd ~; fi
    newpath=$(echo "$2" | rev | cut -c2- | rev)
    if [ -d "$newpath" ]; then cd $newpath && path_flag=1
    else path="n/a"; fi
}

function set_printf_locale() {
    en="en_US.UTF-8"
    if [ -z "$LC_NUMERIC" ] || [[ "$LC_NUMERIC" != "$en" ]]; then export LC_NUMERIC=$en; fi
}

function create_file() {
    if [ $1 -eq 1 ]; then
        filename=$(echo "$2")$(date +"%d_%m_%Y_%H_%M_%S.status")
        touch $status_folder/$filename

        if [ -f "$status_folder/$filename" ]; then
            if [[ "$2" = "sysinfo_" ]]; then print_sysinfo $plain > $status_folder/$filename; fi
            if [[ "$2" = "filesinfo_" ]]; then print_filesinfo $plain > $status_folder/$filename; fi
            echo "a new .status file (""$3"") created at:" $(pwd)"/"$status_folder"/"$filename
        else
            echo ".status file (""$3"") creation failure"
        fi
    fi
}

function correct_str() {
    str=$1
    echo "$str" | sed s/" , "/", "/g
}

function update_colors() {
    colorstr=$1
    color_bg1_user=${colorstr: 0: 1}
    color_font1_user=${colorstr: 1: 1}
    color_font2_user=${colorstr: 2: 1}

    if [ -z "$color_bg1_user" ] || [[ ! $color_bg1_user =~ $colorre ]]; then color_bg1_user=$color_bg1_default; fi
    if [ -z "$color_font1_user" ] || [[ ! $color_font1_user =~ $colorre ]]; then color_font1_user=$color_font1_default; fi
    if [ -z "$color_font2_user" ] || [[ ! $color_font2_user =~ $colorre ]]; then color_font2_user=$color_font2_default; fi
}

function init_color_arrays() {
    colors_txt=($color_white_txt $color_red_txt $color_cyan_txt 
                $color_blue_txt $color_purple_txt $color_black_txt $color_none_txt)

    colors_font=($color_white_font $color_red_font $color_cyan_font
                 $color_blue_font $color_purple_font $color_black_font $color_none)

    colors_bg=($color_white_bg $color_red_bg $color_cyan_bg
               $color_blue_bg $color_purple_bg $color_black_bg $color_none)
    
    colors_default=($color_bg1_default $color_font1_default $color_font2_default)
}


#### print

function print_size() {
    if ! [[ $1 = "n/a" ]]; then echo "$2"; fi
}

function print_sysinfo() {
    for ((i=0; i<${#headers[@]}; i++)); do
        printf "%s = " "${headers[$i]}"
        print_colored_text "$1" "${vars[$i]}" "$color_font1_user" "$color_bg1_user"
    done
}

function print_filesinfo() {
    color=$color_font2_user

    printf "Path = " && print_colored_text $1 "$path" "$color" 6
    printf "Total number of folders (including all nested ones) = " && print_colored_text $1 "$v_folders_total" "$color" 6
    printf "Total number of files = " && print_colored_text $1 "$v_files_all_total" "$color" 6
    printf "Configuration (.conf) files = " && print_colored_text $1 "$v_files_conf_total" "$color" 6
    printf "Text (.txt) files = " && print_colored_text $1 "$v_files_txt_total" "$color" 6
    printf "Executable files = " && print_colored_text $1 "$v_files_exec_total" "$color" 6
    printf "Log (.log) files = " && print_colored_text $1 "$v_files_log_total" "$color" 6
    printf "Archive files = " && print_colored_text $1 "$v_archives_total" "$color" 6
    printf "Symbolic links = " && print_colored_text $1 "$v_symlinks_total" "$color" 6

    printf "TOP 5 folders of maximum size arranged in descending order (path and size):\n"
    print_colored_text $1 "$v_folders_list_maxsize" "$color" 6
    printf "TOP 10 files of maximum size arranged in descending order (path, size and type):\n"
    print_colored_text $1 "$(correct_str "$v_files_list_maxsize")" "$color" 6
    printf "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):\n"
    print_colored_text $1 "$v_files_list_exec_maxsize" "$color" 6
}

function print_colored_text() {
    flag_color="$1"
    text="$2"
    font="$3"
    bg="$4"

    if [[ "$flag_color" = "1" ]]; then
        tput bold
        printf "%b" "${colors_font[$font]}"
        printf "%b" "${colors_bg[$bg]}";
    fi
    printf "%s" "$text"
    if [[ "$flag_color" = "1" ]]; then printf "%b" "$reset"; fi
    printf "\n"
}

function print_color_settings() {
    printf "sysinfo background color   = " && print_color_code $color_bg1_user $color_bg1_default
    print_colored_text $colored "${colors_txt[$color_bg1_user]}" "$color_bg1_user" 6
    printf "sysinfo font color\t   = " && print_color_code $color_font1_user $color_font1_default
    print_colored_text $colored "${colors_txt[$color_font1_user]}" "$color_font1_user" 6
    printf "filesinfo font color\t   = " && print_color_code $color_font2_user $color_font2_default
    print_colored_text $colored "${colors_txt[$color_font2_user]}" "$color_font2_user" 6
}

function print_color_code() {
    if [ $1 -eq $2 ]; then printf "default"
    else printf "%s" $1; fi
    printf " "
}

function print_exectime() {
    color=$color_font1_user
    bg=$color_bg1_user
    printf "Script execution time (in seconds) = " && print_colored_text $colored "$v_exectime" "$color" "$bg"
}


#### getters

function get_hostname() {
    result=$(hostname)
    echo $(check_var_exists "$result")
}

function get_timezone() {
    search="Time zone: "
    result=$(timedatectl | grep -e "$search")
    if [ -z "$result" ]; then echo "n/a"; else echo $result | cut -c$((${#search}+1))-; fi
}

function get_user() {
    result=$(whoami)
    echo $(check_var_exists "$result")
}

function get_os() {
    search="PRETTY_NAME="
    cd ~ && cd ../..
    os=$(uname -o)
    version=$(cat etc/os-release | grep "$search" | cut -c$((${#search}+2))- | rev | cut -c2- | rev)
    echo $(check_var_exists "$os")", "$(check_var_exists "$version")
}

function get_date() {
    result=$(date +"%d %B %Y %H:%M:%S")
    echo $(check_var_exists "$result")
}

function get_uptime() {
    result=$(uptime -p)
    echo $(check_var_exists "$result")
}

function get_uptime_sec() {
    cd ~ && cd ../..
    result=$(cat proc/uptime | awk '{print $1}')
    echo $(check_var_exists "$result")
}

function get_adapter() {
    enp3="enp0s3"
    enp8="enp0s8"
    enp9="enp0s9"
    enp10="enp0s10"
    result="n/a"

    if [ $(ifconfig | grep "$enp3" -c) -eq 1 ]; then result=$enp3
    elif [ $(ifconfig | grep "$enp8" -c) -eq 1 ]; then result=$enp8
    elif [ $(ifconfig | grep "$enp9" -c) -eq 1 ]; then result=$enp9
    elif [ $(ifconfig | grep "$enp10" -c) -eq 1 ]; then result=$enp10
    fi

    echo "$result"
}

function get_ip() {
    result="n/a"
    if [[ $1 != "n/a" ]]; then result=$(ifconfig $1 | grep "netmask" | awk '{print $2}'); fi
    echo $result
}

function get_mask() {
    result="n/a"
    if [[ $1 != "n/a" ]]; then result=$(ifconfig $1 | grep "netmask" | awk '{print $4}'); fi
    echo $result
}

function get_gateway() {
    result="n/a"
    if [[ $1 != "n/a" ]]; then result=$(ip r | grep "default" | grep "$1" | awk '{print $3}'); fi
    echo $result
}

function get_ram_total() {
    cd ~ && cd ../..
    result=$(cat proc/meminfo | grep "MemTotal" | awk '{printf "%.3f", $2/1024/1024}')
    echo $(check_var_exists "$result")$(print_size $result " GB")
}

function get_ram_used() {
    cd ~ && cd ../..
    memtotal=$(cat proc/meminfo | grep "MemTotal" | awk '{printf $2}')
    memfree=$(cat proc/meminfo | grep "MemFree" | awk '{printf $2}')
    result=$(echo $(($memtotal - $memfree)) | awk '{printf "%.3f", $1/1024/1024}')
    echo $(check_var_exists "$result")$(print_size $result " GB")
}

function get_ram_free() {
    cd ~ && cd ../..
    result=$(cat proc/meminfo | grep "MemFree" | awk '{printf "%.3f", $2/1024/1024}')
    echo $(check_var_exists "$result")$(print_size $result " GB")
}

function get_space_root() {
    result=$(df /root | grep -v "Filesystem" | awk '{printf "%.2f", $2/1024}')
    echo $(check_var_exists "$result")$(print_size $result " MB")
}

function get_space_root_used() {
    result=$(df /root | grep -v "Filesystem" | awk '{printf "%.2f", $3/1024}')
    echo $(check_var_exists "$result")$(print_size $result " MB")
}

function get_space_root_free() {
    result=$(df /root | grep -v "Filesystem" | awk '{printf "%.2f", $4/1024}')
    echo $(check_var_exists "$result")$(print_size $result " MB")
}

function get_folders_total() {
    result=$(find . -mindepth 1 -type d | wc -l)
    echo "$(($result - 1))"
}

function get_folders_list_maxsize() {
    result=$(find . -type d -exec du -h {} + | sort -rh | head -6)
    count=$(echo "$result" | wc -l)

    if [ ! -z "$result" ] && [ $count -gt 1 ]; then
        result2=$(echo "$result" | awk '{printf "\t_szffldrr_ - %s/, %s\n", $2, $1}' | grep -v " ./, ")
        awk '{for(x=1;x<=NF;x++)if($x~/_szffldrr_/){sub(/_szffldrr_/,++i)}}1' <<< "$result2"
    else printf "\tn/a"; fi
}

function get_files_all_total() {
    find . -type f | wc -l
}

function get_files_conf_total() {
    find . -type f -name '*.conf' | wc -l
}

function get_files_txt_total() {
    find . -type f -name '*.txt' | wc -l
}

function get_files_exec_total() {
    find . -type f -executable | wc -l
}

function get_files_log_total() {
    find . -type f -name '*.log' | wc -l
}

function get_archives_total() {
    find . -type f \( -name '*.zip' -o -name '*.rar' -o -name '*.tar.xz' -o -name '*.7z' \) | wc -l
}

function get_symlinks_total() {
    result=$(find -L . -xtype l | wc -l)
    check_var_exists "$result"
}

function get_files_list_maxsize() {
    result=$(find . -type f -exec du -h {} + | sort -rh | head -10)

    if [ ! -z "$result" ]; then
        result2=$(echo "$result" | awk '{printf "\t_szffldrr_ - %s, %s\n", $2, $1}')
        awk '{for(x=1;x<=NF;x++)if($x~/_szffldrr_/){sub(/_szffldrr_/,++i)}}1' <<< "$result2"
    else printf "\tn/a"; fi
}

function get_files_exec_list_maxsize() {
    result=$(find . -type f -executable -exec du -h {} + | sort -rh | head -10)

    if [ ! -z "$result" ]; then
        result2=$(echo "$result" | awk '{printf "\t_szffldrr_ - %s, %s,\n", $2, $1}')
        awk '{for(x=1;x<=NF;x++)if($x~/_szffldrr_/){sub(/_szffldrr_/,++i)}}1' <<< "$result2"
    else printf "\tn/a"; fi
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

function get_extensions() {
    str=$(echo "$(get_files_list_maxsize)" | awk '{printf "%s\n", $3}')
    flag=0

    for ((i=0; i<${#str}; i++)); do
        next=$(($i + 1))
        chr=${str: $i: 1}
        if [[ "$chr" = "," ]] && [ $flag -eq 0 ]; then printf "\n"; fi
        nextchr=${str: $next: 1}
        if [[ "$chr" = "." ]]; then
            flag=1
            if [[ "$nextchr" = "/" ]] || [[ "$nextchr" = "." ]]; then flag=0 && continue; fi
            j=$i
            k=0

            for ((j; j<${#str}; j++)); do
                chr=${str: $j: 1}
                k=$(($k + 1))
                if [[ "$chr" = "," ]] || [[ "$chr" = " " ]] || [[ "$chr" = "\n" ]]; then flag=1 && k=$((k - 2)) && break; fi
                if [[ "$chr" = "/" ]]; then flag=0 && k=0 && break; fi
                if [[ "$chr" = "." ]] && [ $j -ne $i ]; then flag=0 && k=0 && break; fi
            done

            if [ $flag -eq 1 ]; then printf ", " && flag=0; fi
            printf "%s" ${str: $(($i + 1)): $k}
        fi
    done
}

function get_hashes() {
    str=$(echo "$(get_files_exec_list_maxsize)" | awk '{printf "%s", $3}')
    filename="empty"

    for ((i=0; i<${#str}; i++)); do
        chr=${str: $i: 1}
        if [[ "$chr" = "." ]] && [[ "$filename" = "empty" ]]; then
            j=$i
            k=0
            for ((j; j<${#str}; j++)); do
                chr=${str: $j: 1}
                k=$(($k + 1))
                if [[ "$chr" = "," ]]; then
                    k=$((k - 1))
                    filename="${str: $i: $k}"
                    filename=$(echo "$filename" | cut -c3- | rev | cut -c1- | rev)
                    dir=$(echo "$(pwd)" | cut -c1- | rev | cut -c1- | rev)
                    filename=$(printf "%s/%s" "$dir" "$filename")
                    i=$(($j + 1)) && k=0
                    sum="$(md5sum "$filename" | awk '{printf $1}')" && echo "$sum"
                    filename="empty"
                fi
            done
        fi
    done
}
