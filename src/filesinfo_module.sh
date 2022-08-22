#!/bin/bash

if [ $filesinfo_flag -eq 1 ]; then
    check_path $path
    follow_path "$path_type" "$path"

    if [[ "$path" != "n/a" ]]; then
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

        echo "~~~~~~~~" && print_filesinfo $colored

    else display_error_message 4 && filesinfo_flag=0; fi
fi
