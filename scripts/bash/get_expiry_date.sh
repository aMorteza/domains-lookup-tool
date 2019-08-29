#!/bin/bash
expiry_date=$(cat info/$1.txt | grep -o -m 1 -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | cut -f2- -d:)

if [[ ! -z ${expiry_date} ]]; then
    echo "Expiry Date: $(date -d $expiry_date "+%Y-%m-%d")"
fi;
