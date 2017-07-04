#!/bin/bash

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <path_to_destination> <s3_bucket_name> <zip_prefix> <strip_components>"
  echo "Example: $0 /opt/code/devopsrockstars-website/public devopsrockstars-web-backup devopsrockstars-paperclip-production 4"
  exit 1
elif [ ! -e ~/.aws/credentials ]; then
  echo "~/.aws/credentials not set, exiting"
  exit 1
elif [ ! hash aws 2>/dev/null; then
  echo "aws cli tools not installed, exiting"
  exit 1
elif [ ! -d "$1" ]; then
  echo "destination $1 does not exist, exiting"
  exit 1
fi

CWD=`pwd`
MOST_RECENT=$3-mostrecent

aws s3 cp s3://$2/$MOST_RECENT /tmp/$MOST_RECENT

TO_RESTORE=`cat /tmp/$MOST_RECENT`
aws s3 cp s3://$2/$TO_RESTORE /tmp/$TO_RESTORE

tar -zxf /tmp/$TO_RESTORE --strip-components=$4 -C $1 

#rm -rf /tmp/$TO_RESTORE
#rm -rf /tmp/$MOST_RECENT

cd $CWD; unset CWD

