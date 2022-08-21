#!/bin/bash

source src/config.sh
source ./src/lib.sh

starttime=$(get_time_millisec)
adapter=$(get_adapter)

#check flags and params

set_printf_locale
update_colors 524

v_hostname=$(get_hostname)
v_timezone=$(get_timezone)
v_user=$(get_user)
v_os=$(get_os)
v_date=$(get_date)
v_uptime=$(get_uptime)
v_uptime_sec=$(get_uptime_sec)
v_ip=$(get_ip $adapter)
v_mask=$(get_mask $adapter)
v_gateway=$(get_gateway $adapter)
v_ram_total=$(get_ram_total)
v_ram_used=$(get_ram_used)
v_ram_free=$(get_ram_free)
v_space_root=$(get_space_root)
v_space_root_used=$(get_space_root_used)
v_space_root_free=$(get_space_root_free)

init_arrays

check_path $path
follow_path "$path_type" "$path"

v_folders_total=$(get_folders_total)
v_folders_list_maxsize=$(get_folders_list_maxsize)
v_files_all_total=$(get_files_all_total)
v_files_conf_total=$(get_files_conf_total)
v_files_txt_total=$(get_files_txt_total)
v_files_exec_total=$(get_files_exec_total)
v_files_log_total=$(get_files_log_total)
v_archives_total=$(get_archives_total)
v_symlinks_total=$(get_symlinks_total)
v_files_list_maxsize=$(paste -d' ' <(echo "$(get_files_list_maxsize)") <(echo "$(get_extensions)"))
v_files_list_exec_maxsize=$(paste -d' ' <(echo "$(get_files_exec_list_maxsize)") <(echo "$(get_hashes)"))

endtime=$(get_time_millisec)
v_exectime=$(get_exectime $endtime $starttime)

echo "~~~~~~~~" && print_sysinfo $colored
echo "~~~~~~~~" && print_filesinfo $colored
echo "~~~~~~~~" && print_color_settings

echo "~~~~~~~~" && source ./src/status_module.sh

echo "~~~~~~~~" && echo "end~"
