#!/bin/bash

function get_input() {
    flag=0
    read answer

    if [[ "$answer" =~ ^(yes|YES|y|Y)$ ]]; then flag=1
    elif [[ "$answer" =~ ^(no|NO|n|N)$ ]]; then flag=2
    else flag=3
    fi

    echo "$flag"
}

outflag=0
ask=$1

echo $ask

while ! [[ $outflag =~ $inputre ]]; do
    outflag=$(get_input)
    if ! [[ $outflag =~ $inputre ]]; then echo "incorrect input, please try again; y/n"; fi
done
