#!/bin/bash

if ! [ -d "logs" ]; then mkdir "logs"; fi
log=$(generate_logname)

cd ~ && cd ../..

if ! [ -f "$log" ]; then touch $log; fi

dircount=0
filecount=0
count_insert_dir=0
index_char_dir=0
error_flag=0
tempdir=$let_subdirs
tempfile=$let_filenames
filesize_bytes=$(convert_to_bytes "$filesize" "$filesize_type")

echo "file generation process launched, please wait..."

for ((i=0; i<$num_subdirs; i++)); do
    print_percentage $i $num_subdirs

    if [ $(check_partition_size) -ne 1 ]; then
        display_error_message 6 0 && error_flag=1
        break
    fi

    find_random_path
    while (( $(check_str_contains "$path" "bin") != 0 )); do
        find_random_path
    done
    cd $path

    count_insert_file=0
    index_char_file=0
    count_insert_dir=$(($count_insert_dir + 1))

    if [ $count_insert_dir -gt 200 ]; then
        count_insert_dir=0
        index_char_dir=$(($index_char_dir + 1))
    fi

    gen=$(generate_name_from_pattern $let_subdirs $count_insert_dir $index_char_dir)
    subdir=$(generate_dirname "$gen")

    if [ -z "$gen" ]; then
        display_error_message 7 0 && error_flag=1
        break
    elif [ -d "$subdir" ]; then
        display_error_message 4 0 "$subdir" && error_flag=1
    else 
        mkdir $subdir
        dircount=$(($dircount + 1))
    fi

    for ((j=0; j<$num_files; j++)); do
        if [ $(check_partition_size) -ne 1 ]; then break; fi

        count_insert_file=$(($count_insert_file + 1))

        if [ $count_insert_file -gt 200 ]; then
            count_insert_file=0
            index_char_file=$(($index_char_file + 1))
        fi

        gen=$(generate_name_from_pattern $let_filenames $count_insert_file $index_char_file)
        filename=$(generate_filename "$subdir" "$gen")

        if [ -z "$gen" ]; then
            display_error_message 8 0 && error_flag=1
            break
        elif [ -f "$filename" ]; then
            display_error_message 5 0 "$filename" && error_flag=1
            continue
        else
            dd if=/dev/zero of=$filename bs=$filesize_bytes count=1 >& /dev/null
            get_fileinfo "$filename" >> $log
            filecount=$(($filecount + 1))
        fi 
    done
done

if [ $error_flag -eq 1 ]; then display_separator; fi
