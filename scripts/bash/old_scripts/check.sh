#!/bin/bash
get_expiry_date(){
    echo $(cat ${SCRIPTS_PATH}/info/$1.txt | grep -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | cut -f2- -d:)
}

get_weeks_remaining(){
    one_week_seconds=604800
    diff=`expr $1 - $2`
    echo `expr $diff / $one_week_seconds`
}

get_date_by_format(){
    echo $(date -d $1 $2)
}

if [ -z ${DOMAINS_PROJECT_PATH} ];then
    echo "please define the root path."
    exit 1;
fi

SCRIPTS_PATH=${DOMAINS_PROJECT_PATH}/scripts/bash;
domains=($(awk '{ print $1 }' ${SCRIPTS_PATH}/domains-list.txt))
curr_second=$(get_date_by_format now "+%s")

for domain in "${domains[@]}";do

    echo ""
    echo "$domain"
    echo ""

    if [ ! -f ${SCRIPTS_PATH}/info/$domain.txt ] || [ ! -s ${SCRIPTS_PATH}/info/$domain.txt ];then

        echo "The domain info still is'nt available!"
        echo ""

    else
        expiry_date=$(get_expiry_date $domain);

        if [ -z $expiry_date ];then

            last_database_update=$(cat ${SCRIPTS_PATH}/info/$domain.txt  | grep -o -P 'Last update of whois database:.{0,21}' | cut -f2- -d:);

            echo "No match for $domain !!!!"
            echo ""
            echo "Its down, last update of whois database : $(date -d $last_database_update "+%Y-%m-%d %H:%M:%S")"
            echo ""

        else

            echo "Expiration Date : $(date -d $expiry_date "+%Y-%m-%d %H:%M:%S")"
            echo ""

            expiry_second=$(get_date_by_format $expiry_date "+%s")
            week_remaining=$(get_weeks_remaining $expiry_second $curr_second)

            if [ 2 -ge $week_remaining ]; then

                echo "Expiration Alert for $domain"
                echo ""

                test=$(${SCRIPTS_PATH}/alert.sh $domain $week_remaining $(date -d $expiry_date "+%Y-%m-%d %H:%M:%S") ${DOMAINS_PROJECT_PATH} &> /dev/null)


                echo "$week_remaining weeks remaining to expire"
                echo ""
            else

                echo "The domain is up to date"
                echo ""
                echo "but, $week_remaining weeks remaining to expire."

            fi
            echo ""
        fi
    fi
    echo "+--------------------------------------------------------------------------------------+"
done








