#!/bin/bash

source ./src/input_module.sh "would you like to create a .status file to store the info? y/n"
status_flag=$outflag
echo "~~~~~~~~"
source ./src/input_module.sh "would you like to delete all previously created .status files?"
delete_flag=$outflag
echo "~~~~~~~~"

if [ $delete_flag -eq 1 ]; then
    if ! [ -d "$newpath" ]; then
        mkdir $status_folder
        echo "storage directory not found; a new directory created at:" $(pwd)"/"$status_folder
    fi

    cd $status_folder && filecount=$(ls 2>/dev/null -1 *.status | grep . -c)

    if [ $filecount -gt 0 ]; then
        rm -rf *.status && echo "previous .status file(s) deleted successfully"
    else
        echo "no .status file(s) to delete"
    fi
    cd ..
fi

if [ $status_flag -eq 1 ]; then
        echo "creating a new .status file..."
        create_file $sysinfo_flag "sysinfo_" "system information"
        create_file $filesinfo_flag "filesinfo_" "filesystem information"
elif [ $status_flag -eq 2 ]; then
    echo "skipping the .status file creation stage"
fi
