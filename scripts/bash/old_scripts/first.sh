#!/bin/bash
#CURRENT_USERS=$(who)
while IFS='' read -r line || [[ -n "$line" ]]; do
  echo -n "$line - "
  full_domain="$(whois $line | egrep -i 'Expiration Date' | head -1)"
  echo "$full_domain"
  expir_date="${full_domain:40}"
  echo "Expiration Date: $expir_date"
  curr_date=`date '+%Y-%m-%d'`
  echo "Current Date: $curr_date"
  echo ""
  echo ""
  decimal_expir_date=$(date -d $expir_date +"%s")  # = 20130718
  echo "decimal expir : $decimal_expir_date"
  decimal_curr_date=$(date -d $curr_date +"%s")    # = 20130715
  echo "decimal curr : $decimal_curr_date"
  diff=`expr $decimal_expir_date - $decimal_curr_date`
  echo "diff(seconds): $diff"
  oneweek=604800
  week_remaining=`expr $diff / $oneweek`
  echo "week remaining to expire: $week_remaining"
  if [ 2 -ge $week_remaining ];
  then
         echo "Expiration Alert for $line"
  fi
   echo ""
   echo "-----------------------------------------------"
done < "domains-list.txt"



#    if [ -f ${SCRIPTS_PATH}/info/$domain.txt ];then
#       expiry_date=$( cat ${SCRIPTS_PATH}/info/$domain.txt | grep -o -P 'Expiration Date.{0,30}' | cut -f2- -d:)
#
#       echo "$domain file found"
#       echo "ExpiryDate: $(get_date_by_format $expiry_date "+%Y-%m-%d %H:%M:%S")"
#       expiry_second=$(get_date_by_format $expiry_date "+%s")
#       latest_expiry_second=$(get_date_by_format ${latest_expiry_dates[$counter]} "+%s")
#
#       if [ $latest_expiry_second  -gt $expiry_second ];then
#
#           sed -i "s/$expiry_date/${latest_expiry_dates[$counter]}/g" ${SCRIPTS_PATH}/info/$domain.txt
#           echo "$domain updated!"
#
#       else
#           echo "$domain date is up to date!"
#       fi
#   fi














#
#
#
#
#
#if [ 2 -ge $week_remaining ]; then
#
#                last_update=$(whois $domain | grep -o -P "Expiry Date.{0,30}|Expiration Date.{0,30}" | cut -f2- -d:)
#
#                if [ $? -eq 0 ] && [[ $last_update ]]; then
#
#                    echo "Last Update : $(date -d $last_update "+%Y-%m-%d %H:%M:%S")"
#                    echo ""
#
#
#                    last_update_second=$(get_date_by_format $last_update "+%s")
#                    latest_week_remaining=$(get_weeks_remaining $last_update_second $curr_second)
#
#                    if [  $expiry_second -ge $last_update_second  ];then
#
#                        echo "Expiration Alert for $domain"
#                        echo ""
#
#                        ${SCRIPTS_PATH}/alert.sh $domain $week_remaining $(date -d $expiry_date "+%Y-%m-%d %H:%M:%S") &> /dev/null
#
#                        if [ $? -eq 0 ];then
#                            echo "Notification sent."
#                            echo ""
#                        else
#                            echo "Having some Errors to send email !!"
#                            echo ""
#                        fi
#
#                    else
#
#                        sed -i -e "s/$expiry_date/$last_update/g" ${SCRIPTS_PATH}/info/$domain.txt
#                        echo "The expiration date updated!"
#                        echo ""
#
#                    fi
#
#                    echo "$latest_week_remaining weeks remaining to expire"
#
#                else
#
#                    echo "connection failed to get update"
#                    echo ""
#                    echo "but, $week_remaining weeks remaining to expire."
#
#                fi
#
#            else
#
#                echo "The domain is up to date"
#                echo ""
#                echo "but, $week_remaining weeks remaining to expire."
#fi
