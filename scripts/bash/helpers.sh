#!/bin/bash

get_date_by_format(){
    echo $(date -d $1 $2)
}

get_expiry_date(){
    echo $(cat ${SCRIPTS_PATH}/info/$1.txt | grep -m 1 -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | cut -f2- -d:)
}

get_weeks_remaining(){
    one_week_seconds=604800
    diff=`expr $1 - $2`
    echo `expr ${diff} / ${one_week_seconds}`
}

get_days_remaining(){
    one_day_seconds=86400
    diff=`expr $1 - $2`
    echo `expr ${diff} / ${one_day_seconds}`
}

send_notification(){
    ${SCRIPTS_PATH}/alert.sh $1 "$(get_date_by_format $2 "+%Y-%m-%d")" $3 $4 $5 $6 &> /dev/null
}

modify_notification_level(){
    cat ${SCRIPTS_PATH}/domains-list.txt | awk '$1=="'$1'" {print $1,"'$2'";next};{print $0}' > ${SCRIPTS_PATH}/domains-list.txt.tmp && mv ${SCRIPTS_PATH}/domains-list.txt.tmp ${SCRIPTS_PATH}/domains-list.txt
}

level_up_notification()
{
    if [[ $? -eq 0 ]];then
        echo "At $(date -d now)  queued to notification."

        modify_notification_level $1 $2
        if [[ $? -eq 0 ]];then
            echo "$1 set level to $2"
        else
            echo "having some errors to over write notification level!"
        fi;
    else
        echo "having some errors to add to queue!"
    fi;
    echo "----------------------------------"
}

export curr_second=$(get_date_by_format now "+%s")

send_notifications_for_them_all(){
    ${SCRIPTS_PATH}/alert.sh $1 $2 &> /dev/null
}