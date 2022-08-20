#!/bin/bash

source src/config.sh
source ./src/lib.sh

set_printf_locale
update_colors 526

echo $color_bg1_user $color_font1_user $color_font2_user

adapter=$(get_adapter)

echo "~~~~~~~~"
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

print_sysinfo $colored
print_color_settings

echo "~~~~~~~~"
source ./src/status_module.sh

echo "~~~~~~~~"
echo "end~"
