#!/bin/sh


if $1 
then
        start_path=$1
fi

cat ./"bashrc_win10.txt" >> ~/.bashrc

if $start_path
then
        echo "cd $start_path" >> ~/.bashrc
fi
