#!/bin/bash

filecount=0
dircount=0
scriptdir=$(pwd)
dirpath_list=""
delete_list=""

source ./input_module.sh "WARNING: this operation is irreversible. would you like to continue? y/n"
rm_flag=$outflag

if [ $rm_flag -eq 1 ]; then
    echo "cleaning process launched, please wait..."

    ### building a list - option 1

    if [ $cleaner_mode -eq 1 ]; then
        log=$cleaner_param
        oldpath=""

        linecount=$(($(cat $log | wc -l) + 1))
        for ((i=1; i<$linecount; i++)); do
            line=$(sed -n "$i"p $log)
            filepath=$(echo "$line" | awk '{printf $1}')
            newpath=$(get_dirpath "$filepath")$'\n'

            if ! [[ "$oldpath" = "$newpath" ]]; then
                dirpath_list+=$newpath && oldpath=$newpath
            fi

            if [ -f "$filepath" ]; then
                delete_list+="$filepath"$'\n'
            fi
        done

        if ! [ -z "$delete_list" ]; then
            linecount=$(($(echo "$dirpath_list" | wc -l) + 1))
            for ((i=1; i<$linecount; i++)); do
                line=$(echo "$dirpath_list" | sed -n "$i"p)
                if [ -d "$line" ]; then
                    delete_list+="$line"$'\n'
                fi
            done
        fi
    fi

    ### building a list - option 2

    if [ $cleaner_mode -eq 2 ]; then
        start_date=${cleaner_param: 0 :10}
        start_time=${cleaner_param: 11 :5}
        end_date=${cleaner_param: 18 : 10}
        end_time=${cleaner_param: 29}

        delete_list=$(find /home/ -newermt "$start_date $start_time" ! -newermt "$end_date $end_time" -ls | awk '{printf "%s%s\n", $11, $12}')
    fi

    ### building a list - option 3

    if [ $cleaner_mode -eq 3 ]; then
        process_param_filename $cleaner_param
        mask_filedate=${mask_filename: -7}
        mask_filename=$(echo "$mask_filename" | rev | cut -c8- | rev)

        count_insert_file=0
        index_char_file=0

        for ((i=0; i<${#mask_filename}; i++)); do
            for ((j=0; j<250; j++)); do
                count_insert_file=$(($count_insert_file + 1))

                if [ $count_insert_file -gt 250 ]; then
                    count_insert_file=0
                    index_char_file=$(($index_char_file + 1))
                fi

                gen=$(generate_name_from_pattern $mask_filename $count_insert_file $index_char_file)
                add=$(find /home/ -name "$gen$mask_filedate*")

                if ! [ -z "$add" ]; then 
                    delete_list+="$add"$'\n'
                fi
            done
        done
    fi

    ## deletion

    linecount=$(echo "$delete_list" | wc -l)

    if [ -z "$delete_list" ] || [ $linecount -eq 0 ]; then display_error_message 14 0
    else
        for ((i=1; i<$linecount; i++)); do
            line=$(echo "$delete_list" | sed -n "$i"p | tr '\\' ' ')
            if [ -z "$line" ]; then break; fi

            if [ -f "$line" ]; then
                echo "deleted: $line, $i/$(($linecount - 1))"
                filecount=$(($filecount + 1))
                rm -rf "$line"
            elif [ -d "$line" ]; then
                if ! [ -z "$(ls -A $line)" ] && [ $cleaner_mode -eq 1 ]; then continue
                else
                    contains=$(find "$line" -type f | wc -l)
                    echo "deleted: $line, $i/$(($linecount - 1))"
                    dircount=$(($dircount + 1))
                    filecount=$(($filecount + $contains))
                    rm -rf "$line"
                fi
            fi
        done
    fi
fi

display_separator && print_results_cleaner
