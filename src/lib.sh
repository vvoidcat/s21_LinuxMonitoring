#!/bin/bash

#### other

function init_arrays() {
    vars=("$v_hostname" "$v_timezone" "$v_user" "$v_os" "$v_date"
          "$v_uptime" "$v_uptime_sec" "$v_ip" "$v_mask" "$v_gateway"
          "$v_ram_total" "$v_ram_used" "$v_ram_free" "$v_space_root"
          "$v_space_root_used" "$v_space_root_free")

    colors_txt=($color_white_txt $color_red_txt $color_cyan_txt 
                $color_blue_txt $color_purple_txt $color_black_txt $color_none_txt)

    colors_font=($color_white_font $color_red_font $color_cyan_font
                 $color_blue_font $color_purple_font $color_black_font $color_none)

    colors_bg=($color_white_bg $color_red_bg $color_cyan_bg
               $color_blue_bg $color_purple_bg $color_black_bg $color_none)
    
    colors_default=($color_bg1_default $color_font1_default $color_font2_default)

    headers=("HOSTNAME" "TIMEZONE" "USER" "OS" "DATE"
             "UPTIME" "UPTIME_SEC" "IP" "MASK" "GATEWAY"
             "RAM_TOTAL" "RAM_USED" "RAM_FREE" "SPACE_ROOT"
             "SPACE_ROOT_USED" "SPACE_ROOT_FREE")
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
    if [ -d "$newpath" ]; then cd $newpath && path_flag=1; fi
}

function set_printf_locale() {
    en="en_US.UTF-8"
    if [ -z "$LC_NUMERIC" ] || [[ "$LC_NUMERIC" != "$en" ]]; then export LC_NUMERIC=$en; fi
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

    if [ -z "$color_bg1_user" ]; then color_bg1_user=$color_bg1_default; fi
    if [ -z "$color_font1_user" ]; then color_font1_user=$color_font1_default; fi
    if [ -z "$color_font2_user" ]; then color_font2_user=$color_font2_default; fi
}


#### print

function print_size() {
    if ! [[ $1 = "n/a" ]]; then echo "$2"; fi
}

function print_sysinfo() {
    for ((i=0; i<${#headers[@]}; i++)); do
        print_colored_text "$1" "${headers[$i]}" "$color_white_font" ""
        printf " = "
        print_colored_text "$1" "${vars[$i]}" "${colors_font[$color_font1_user]}" "${colors_bg[$color_bg1_user]}"
        printf "\n"
    done
}

function print_filesinfo() {
    color=$color_font2_user

    printf "Total number of folders (including all nested ones) = " && print_colored_text $1 "$v_folders_total" "$color" ""
    printf "TOP 5 folders of maximum size arranged in descending order (path and size):\n"
    print_colored_text $1 "$v_folders_list_maxsize" "$color" ""

    printf "Total number of files = " && print_colored_text $1 "$v_files_all_total" "$color" ""
    printf "Configuration (.conf) files = " && print_colored_text $1 "$v_files_conf_total" "$color" ""
    printf "Text files = " && print_colored_text $1 "$v_files_txt_total" "$color" ""
    printf "Executable files = " && print_colored_text $1 "$v_files_exec_total" "$color" ""
    printf "Log (.log) files = " && print_colored_text $1 "$v_files_log_total" "$color" ""
    printf "Archive files = " && print_colored_text $1 "$v_archives_total" "$color" ""
    printf "Symbolic links = " && print_colored_text $1 "$v_symlinks_total" "$color" ""

    printf "TOP 10 files of maximum size arranged in descending order (path, size and type):\n"
    print_colored_text $1 "$(correct_str "$v_files_list_maxsize")" "$color" ""

    printf "TOP 10 executable files of the maximum size arranged in descending order (path, size and MD5 hash of file):\n"
    print_colored_text $1 "$v_files_list_exec_maxsize" "$color" ""

    printf "Script execution time (in seconds) = " && print_colored_text $1 "$v_exectime" "$color" ""
}

function print_colored_text() {
    flag="$1"
    text="$2"
    font="$3"
    bg="$4"

    if [[ "$flag" = "1" ]]; then tput bold && printf "%b" "$font" && printf "%b" "$bg"; fi
    printf "%s" "$text"
    if [[ "$flag" = "1" ]]; then printf "%b" "$reset"; fi
}

function print_color_settings() {
    #print_single_color "$column1_background" "${colors_font[$column1_background]}" "${colors_txt[$column1_background]}" 0
    echo "~~~~~~~~"
}

function print_color_scheme() {
    echo "aaa"
}

function check_color_default() {
    echo "check"
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
    result=$(find . -type d | du -h | sort -rh | head -6)
    result2=$(echo "$result" | awk '{printf "\t_szffldrr_ - %s/, %s\n", $2, $1}' | grep -v " ./, ")
    awk '{for(x=1;x<=NF;x++)if($x~/_szffldrr_/){sub(/_szffldrr_/,++i)}}1' <<< "$result2"
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
    result2=$(echo "$result" | awk '{printf "\t_szffldrr_ - %s, %s\n", $2, $1}')
    awk '{for(x=1;x<=NF;x++)if($x~/_szffldrr_/){sub(/_szffldrr_/,++i)}}1' <<< "$result2"
}

function get_files_exec_list_maxsize() {
    result=$(find . -type f -executable -exec du -h {} + | sort -rh | head -10)
    result2=$(echo "$result" | awk '{printf "\t_szffldrr_ - %s, %s,\n", $2, $1}')
    awk '{for(x=1;x<=NF;x++)if($x~/_szffldrr_/){sub(/_szffldrr_/,++i)}}1' <<< "$result2"
}

function get_time_millisec() {
    date +"%S.%3N"
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
