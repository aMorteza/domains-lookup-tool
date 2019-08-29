#!/bin/bash

get_date_by_format(){
    echo $(date -d $1 $2)
}


if [ -z ${DOMAINS_PROJECT_PATH} ];then
    echo "please define the root path."
    exit 1;
fi;

SCRIPTS_PATH=${DOMAINS_PROJECT_PATH}/scripts/bash
mkdir -p ${SCRIPTS_PATH}/info
domains=($(awk '{ print $1 }' ${SCRIPTS_PATH}/domains-list.txt))

for domain in "${domains[@]}";do

    echo ""

    if [ ! -f ${SCRIPTS_PATH}/info/$domain.txt ];then

       whois $domain > ${SCRIPTS_PATH}/info/$domain.txt

       echo "$domain : info file created."
       echo ""

       dos2unix ${SCRIPTS_PATH}/info/$domain.txt &> /dev/null

    else

        echo "$domain : info file found"
        echo ""



        expiry_date=$(cat ${SCRIPTS_PATH}/info/$domain.txt | grep -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | cut -f2- -d:)
        last_update=$(whois $domain | grep -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | cut -f2- -d:)

        if [ $? -eq 0 ] && [[ $last_update ]]; then

            expiry_second=$(get_date_by_format $last_update "+%s")
            last_update_second=$(get_date_by_format $last_update "+%s")

            if [ $last_update_second -gt $expiry_second ];then

                sed -i -e "s/$expiry_date/$last_update/g" ${SCRIPTS_PATH}/info/$domain.txt
                echo "and the expiration date updated!"
                echo ""

            else

                echo "and domain is up to date"
                echo ""

            fi;

        else

            echo "but connection failed to fetch !!!"
            echo ""

        fi;

    fi;

    echo "+---------------------------------------------------------------------------+"

done;



















