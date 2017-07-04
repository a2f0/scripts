#!/bin/bash

if [[ $# -lt 2 ]]; then
  echo "Usage: $0 <s3_bucket_name> <prefix>"
  echo "Example: $0 devopsrockstars-web-backup devopsrockstars-postgres"
  exit 1
elif [ ! -e ~/.aws/credentials ]; then
  echo "~/.aws/credentials not set, exiting"
  exit 1
elif [ ! hash aws 2>/dev/null; then
  echo "aws cli tools not installed, exiting"
  exit 1
fi

CWD=`pwd`
MOST_RECENT=$2-mostrecent

aws s3 cp s3://$1/$MOST_RECENT /tmp/$MOST_RECENT

TO_STAGE=`cat /tmp/$MOST_RECENT`
aws s3 cp s3://$1/$TO_STAGE /tmp/$2-staged

cd $CWD; unset CWD
