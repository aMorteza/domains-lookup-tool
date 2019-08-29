#!/bin/bash
#crontab */2 * * * * every 2 minute!

if [[ -z ${DOMAINS_PROJECT_PATH} ]];then

    echo "please define the root path."
    exit 1;
    #export DOMAINS_PROJECT_PATH=$(pwd)
fi;

export SCRIPTS_PATH=${DOMAINS_PROJECT_PATH}/scripts/bash;
export TMP_DATA_PATH=${SCRIPTS_PATH}/tmp
export PID_FILE=${TMP_DATA_PATH}/expiry_date_checker.pid

if [[ ! -d ${TMP_DATA_PATH} ]]; then
    mkdir -p ${TMP_DATA_PATH}
fi;

if [[ -f ${PID_FILE} ]];then

    OLD_PID=`cat ${PID_FILE}`
    RESULT=`ps -ef | grep ${OLD_PID} | grep 'update_and_check_for_expiry_dates'`

    if [[ -n "${RESULT}" ]]; then
        echo "update_and_check_for_expiry_dates is already running! Exiting"
        exit 255
    fi

fi;

if [[ -f ${SCRIPTS_PATH}/update_and_check_for_expiry_dates.sh ]]; then
    echo "checking..."
    ${SCRIPTS_PATH}/update_and_check_for_expiry_dates.sh
    echo -e "done. \n"
else
    echo "the selected file not exist, please create update_and_check_for_expiry_dates.sh first";
fi;

