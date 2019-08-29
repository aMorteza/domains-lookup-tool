#!/bin/bash
creation_date=$(cat info/$1.txt | grep -m 1 -o -P "Creation Date.{0,30}" | cut -f2- -d:)
if [[ ! -z ${creation_date} ]]; then
    echo "Creation Date: $(date -d ${creation_date} "+%Y-%m-%d")"
fi;
