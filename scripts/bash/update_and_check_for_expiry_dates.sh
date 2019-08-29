#!/bin/bash


PID=`ps -ef | grep 'update_and_check_for_expiry_dates' | head -n1 |  awk ' {print $2;} '`;
echo "${PID}" > ${PID_FILE};



source ${SCRIPTS_PATH}/helpers.sh

mkdir -p ${SCRIPTS_PATH}/info
domains=($(awk 'NF { print $1 }' ${SCRIPTS_PATH}/domains-list.txt))
curr_second=$(get_date_by_format now "+%s")
alerting_domains=()

for domain in "${domains[@]}";do

    is_fresh=0
    is_loaded=1

    if [[ ! -f ${SCRIPTS_PATH}/info/${domain}.txt ||  ! -s ${SCRIPTS_PATH}/info/${domain}.txt ]];then

        tmp_data=$(timeout 15s whois ${domain})
        tmp_data_expiry_date=$(echo ${tmp_data} | grep -m 1 -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | awk '{ print $3; }')

        if [[ ! -z ${tmp_data_expiry_date} ]];then

            IFSBAK=$IFS
            IFS=" "
            echo ${tmp_data} > ${SCRIPTS_PATH}/info/${domain}.txt
            IFS=${IFSBAK}
            dos2unix ${SCRIPTS_PATH}/info/${domain}.txt &> /dev/null
            modify_notification_level ${domain} 0
            is_fresh=1
            is_loaded=1
            echo "$domain, info loaded for first time."
        else
            is_fresh=0
            is_loaded=0
            echo "$domain, having some errors get info for first time!"
        fi;
    fi;

    if [[ ${is_loaded} -eq  1 ]];then

        notification_level=$(cat ${SCRIPTS_PATH}/domains-list.txt | awk '$1=="'${domain}'" {print $2;}')
        if [[ -z ${notification_level} ]]; then
            modify_notification_level ${domain} 0
        fi

        expiry_date=$(get_expiry_date ${domain});

        #we sure info exists but, some domains are down like medmaxin.com
        if [[ ! -z ${expiry_date} ]];then

            notification_level=($(cat ${SCRIPTS_PATH}/domains-list.txt | awk '$1=="'${domain}'" {print $2;}'))
            expiry_second=$(get_date_by_format ${expiry_date} "+%s")

            if [[ ${notification_level} -lt 3 ]];then

                week_remaining=$(get_weeks_remaining ${expiry_second} ${curr_second})

                if [[ ${week_remaining} -le 2 ]];then

                    if [[ ${is_fresh} -eq  0 ]];then

                        echo -e "$domain \n Getting info..."

                        tmp_data=$(timeout 15s whois ${domain})
                        tmp_data_expiry_date=$(echo ${tmp_data} | grep -m 1 -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | awk '{ print $2; }')

                        if [[ ! -z ${tmp_data_expiry_date} ]];then

                            IFSBAK=$IFS
                            IFS=" "
                            echo ${tmp_data} > ${SCRIPTS_PATH}/info/${domain}.txt
                            IFS=${IFSBAK}
                            dos2unix ${SCRIPTS_PATH}/info/${domain}.txt &> /dev/null
                            is_loaded=1
                            is_fresh=1
                            echo "info reloaded."
                        else

                            is_loaded=0
                            is_fresh=0
                            echo "$domain, having some errors get info!"
                        fi;

                    fi;
                    if [[ ${is_loaded} -eq  1 ]];then

                        latest_expiry_date=$(get_expiry_date ${domain})
                        latest_expiry_second=$(get_date_by_format ${latest_expiry_date} "+%s")
                        latest_week_remaining=$(get_weeks_remaining ${latest_expiry_second} ${curr_second})

                        if [[ ${latest_expiry_second} -gt ${expiry_second} ]];then

                            echo "$domain updated."
                            modify_notification_level ${domain} 0

                            if [[ $? -eq 0 ]]; then
                                echo "At $(date -d now) : notification levels over loaded."
                            else
                                echo "having some errors to reset notification levels!"
                            fi
                            echo "----------------------------------"
                        else
                            if [[ ${latest_week_remaining} -le 2 ]];then

                                echo "$latest_week_remaining weeks remaining"
                                echo -e "Determining alert for $domain \n"

                                latest_days_remaining=$(get_days_remaining ${latest_expiry_second} ${curr_second})

                                if [[ ${notification_level} -eq 0 && ${latest_days_remaining} -le 14 ]];then

                                    alerting_domains+=("$domain")
                                    level_up_notification ${domain} 1
                                     echo -e "Added $domain \n"

                                elif [[ ${notification_level} -eq 1 && ${latest_days_remaining} -le 7 ]];then

                                    alerting_domains+=("$domain")
                                    level_up_notification ${domain} 2
                                    echo -e "Added $domain \n"

                                elif [[ ${notification_level} -eq 2 && ${latest_days_remaining} -le 2 ]];then

                                    alerting_domains+=("$domain")
                                    level_up_notification ${domain} 3
                                    echo -e "Added $domain \n"
                                    #we can call send sms script here
                                else
                                    echo "At $(date -d now) : sending notification ignored."
                                    echo "----------------------------------"
                                fi;
                            fi;
                        fi;
                    fi;
                fi;
            else
                echo "$domain,"
                week_ago=$(get_weeks_remaining ${curr_second} ${expiry_second})
                echo "expired $week_ago, week ago"
                if [[ ${week_ago} -gt 1 ]]; then
                    echo -e "Getting info..."
                    tmp_data=$(timeout 15s whois ${domain})
                    tmp_data_expiry_date=$(echo ${tmp_data} | grep -m 1 -o -P "expire-date.{0,30}|Expiry Date.{0,30}|Expiration Date.{0,30}" | awk '{ print $2; }')

                    if [[ ! -z ${tmp_data_expiry_date} ]];then

                        IFSBAK=$IFS
                        IFS=" "
                        echo ${tmp_data} > ${SCRIPTS_PATH}/info/${domain}.txt
                        IFS=${IFSBAK}
                        dos2unix ${SCRIPTS_PATH}/info/${domain}.txt &> /dev/null
                        echo "$domain, info reloaded."

                        latest_expiry_date=$(get_expiry_date ${domain})
                        latest_expiry_second=$(get_date_by_format ${latest_expiry_date} "+%s")

                        if [[ ${latest_expiry_second} -gt ${expiry_second} ]]; then

                            echo "$domain updated"
                            modify_notification_level ${domain} 0

                            if [[ $? -eq 0 ]]; then
                                echo "At $(date -d now) : notification levels over loaded."
                            else
                                echo "having some errors to reset notification levels!"
                            fi
                        else
                            echo "At $(date -d now) : no change, reset notification levels ignored."
                        fi

                    else
                        echo "$domain, having some errors get info!"
                    fi;

                else
                    echo "At $(date -d now) : reload info ignored."
                fi
                echo "----------------------------------"
            fi;
        else
            echo "$domain, having some errors get info!"
        fi;
    fi;

done;

if [[ ! -z ${alerting_domains+x} ]];then

    #TODO: send notification per user.
    #send_notifications_for_them_all "${alerting_domains[@]}"

    if [[ $? -eq 0 ]]; then
        echo "At $(date -d now) : notification sent."
    else
        echo "having some errors send notification !"
    fi;

fi;

if [[ -f ${PID_FILE} ]]; then
    rm -rf ${PID_FILE}
fi