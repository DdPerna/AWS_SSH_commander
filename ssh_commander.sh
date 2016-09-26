#!/bin/bash

# Safety feature: exit script if error is returned, or if variables not set.
# Exit if a pipeline results in an error.
#set -ue
#set -o pipefail



if [ "$1" == "-h" ]; then
  echo ""
  echo "### Description ###"
  echo " `basename $0` is a script to run commands to multiple instances in aws via ssh "
  echo " It uses the aws API to grab a list of the instances you want based on tag values"
  echo " the first tag its looking is Region, then environment, then type"
  echo ""
  echo " You can input a line of bash commands or input a file with commands"
  echo ""
  echo "### Flags ###"
  echo " -h     display help "
  echo " -f     run a bash script against the instances"
  echo ""
  echo "### Options ####"
  echo "Region - {us-east-1,us-west-1}"
  echo "Environment - {Prod,Pilot,Stage}"
  echo "Type - {LOG,HTTPD,APP}"
  echo ""
  echo "Multiple options can be entered for a category if seperated by a comma. EX: LOG,HTTPD,APP"
  echo ""
  echo "Usage: `basename $0` {Region} {Environment} {Type} '[bash command]'"
  echo "Usage: `basename $0` {Region} {Environment} {Type} -f [/path/to/script]"
  exit 1
fi

REGION=$1
ENVIR=$2
VALUES=$3
COM=$4

SPACER="echo '"====================================="'"

INSTANCE="curl -s http://169.254.169.254/latest/meta-data/instance-id && echo ''"
ADDR="ip a s|sed -ne '/127.0.0.1/!{s/^[ \t]*inet[ \t]*\([0-9.]\+\)\/.*$/\1/p}'"

if [ "$REGION" = "us-east-1" ]; then
  CERT="ec2-user-east.pem"

  elif [ "$REGION" = "us-west-1" ]; then
    CERT="ec2-user-west.pem"
fi


if [ "$COM" = "-f" ]; then

  SCRIPT=$5

for i in `aws ec2 describe-instances --region $REGION --query 'Reservations[].Instances[].PrivateIpAddress[]' --filters "Name=tag:Environment,Values=$ENVIR" "Name=tag:Server Type,Values=$VALUES" "Name=instance-state-name,Values=running" --output=text`; do ssh -q -t -o "StrictHostKeyChecking no" -i $CERT ec2-user@$i "$SPACER"; \
bash -s < "$SCRIPT";
done;

else

for i in `aws ec2 describe-instances --region $REGION --query 'Reservations[].Instances[].PrivateIpAddress[]' --filters "Name=tag:Environment,Values=$ENVIR" "Name=tag:Server Type,Values=$VALUES" "Name=instance-state-name,Values=running" --output=text`; do ssh -q -t -o "StrictHostKeyChecking no" -i $CERT ec2-user@$i " sudo $ADDR && sudo $INSTANCE && sudo $COM && $SPACER";
done;

fi
