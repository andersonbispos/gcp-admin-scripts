#!/bin/bash
# simple bash script to create a gcp firewall rule to permit ssh access from actual external admin ip
#
# by: Anderson Bispo (andersonbispos@gmail.com)
# last update: 2021/07/21

# the python script and bash script need to be on the same directory
dir=`dirname ${BASH_SOURCE[0]}`

# get actual external ip
ip=`python $dir/meuip.py`

create_rule(){
    gcloud compute firewall-rules create allow-admin-ip \
    --action allow \
    --source-ranges $ip/32 \
    --rules tcp:22 \
    --no-disabled
}

update_rule_enabled(){
    gcloud compute firewall-rules update allow-admin-ip \
    --source-ranges $ip/32 \
    --no-disabled
}

update_rule_disabled(){
    gcloud compute firewall-rules update allow-admin-ip \
    --source-ranges $ip/32 \
    --disabled
}


rule_exists=`gcloud compute firewall-rules describe allow-admin-ip 2> /dev/null`

if [ $? -ne "0" ]; then
    create_rule
    exit 0
fi

rule_state=`gcloud compute firewall-rules describe allow-admin-ip | grep disabled | awk '{print $2}'`
if [ $rule_state = 'false' ]
then
    update_rule_disabled
    echo "disabled: $ip/32"
    exit 0
else
    update_rule_enabled
    echo "enabled: $ip/32"
    exit 0
fi