#!/bin/bash

if [ $sysinfo_flag -eq 1 ]; then
    adapter=$(get_adapter)

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

    vars=("$v_hostname" "$v_timezone" "$v_user" "$v_os" "$v_date"
          "$v_uptime" "$v_uptime_sec" "$v_ip" "$v_mask" "$v_gateway"
          "$v_ram_total" "$v_ram_used" "$v_ram_free" "$v_space_root"
          "$v_space_root_used" "$v_space_root_free")

    headers=("HOSTNAME" "TIMEZONE" "USER" "OS" "DATE"
             "UPTIME" "UPTIME_SEC" "IP" "MASK" "GATEWAY"
             "RAM_TOTAL" "RAM_USED" "RAM_FREE" "SPACE_ROOT"
             "SPACE_ROOT_USED" "SPACE_ROOT_FREE")

    echo "~~~~~~~~" && print_sysinfo $colored
fi
