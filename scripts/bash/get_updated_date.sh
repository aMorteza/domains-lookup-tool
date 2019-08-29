#!/bin/bash
updated_date=$(cat info/$1.txt | grep -m 1 -o -P "last-updated.{0,30}|Updated Date.{0,30}" | cut -f2- -d:)
if [[ ! -z ${updated_date} ]]; then
    echo "Updated Date: $(date -d ${updated_date} "+%Y-%m-%d")"
fi;