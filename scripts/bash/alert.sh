#!/bin/bash


export SCRIPTS_PATH=${DOMAINS_PROJECT_PATH}/scripts/bash;
source ${SCRIPTS_PATH}/helpers.sh
curr_second=$(get_date_by_format now "+%s")
CERTS_DIR_PATH=${DOMAINS_PROJECT_PATH}/scripts/certs
TEST_EMAIL_ADDRESS="Amirhosein_Morteza@yahoo.com"
SYSTEM_EMAIL_ADDRESS="domains.hinzaco.com@gmail.com"
ADMIN_EMAIL_ADDRESS="admin@hinzaco.com"
DEVELOPER_EMAIL_ADDRESS="a.morteza@hinzaco.com"

 subject="Domain Expiration Alert"
 toEmail=${ADMIN_EMAIL_ADDRESS}
 toMe=${DEVELOPER_EMAIL_ADDRESS}

 messages=()
 domains=("$@")
 for domain in "${domains[@]}";do
    echo "$domain"
    expiry_date=$(get_expiry_date ${domain});
    expiry_second=$(get_date_by_format ${expiry_date} "+%s")

    if [[ ${expiry_second} -ge ${curr_second}  ]];then
        messages+=("* $domain,* expiration date: $(get_date_by_format ${expiry_date} "+%Y-%m-%d"),* just "$(get_weeks_remaining $expiry_second $curr_second)" weeks or "$(get_days_remaining $expiry_second $curr_second)" days remaining. **")
    else
        messages+=("* $domain,* expiration date: $(get_date_by_format ${expiry_date} "+%Y-%m-%d"),* expired "$(get_weeks_remaining $curr_second $expiry_second)" weeks or "$(get_days_remaining $curr_second $expiry_second)" days ago! **")
    fi;
 done;

 fromEmail=${SYSTEM_EMAIL_ADDRESS}
 fromName="Hinzaco Domains"

 echo "${messages[@]}" | sed 's/*/\n/g' | mailx -v -s "$subject" \
 -S smtp-use-starttls \
 -S ssl-verify=ignore \
 -S smtp-auth=login \
 -S smtp=smtp://smtp.gmail.com:587 \
 -S from=${fromEmail}"($fromName)" \
 -S smtp-auth-user=domains.hinzaco.com@gmail.com \
 -S smtp-auth-password=Hinza@dmin123 \
 -S ssl-verify=ignore \
 -S nss-config-dir=${CERTS_DIR_PATH}  \
 ${toEmail}

 echo "${messages[@]}" | sed 's/*/\n/g' | mailx -v -s "$subject" \
 -S smtp-use-starttls \
 -S ssl-verify=ignore \
 -S smtp-auth=login \
 -S smtp=smtp://smtp.gmail.com:587 \
 -S from=${fromEmail}"($fromName)" \
 -S smtp-auth-user=domains.hinzaco.com@gmail.com \
 -S smtp-auth-password=Hinza@dmin123 \
 -S ssl-verify=ignore \
 -S nss-config-dir=${CERTS_DIR_PATH}  \
 ${toMe}


