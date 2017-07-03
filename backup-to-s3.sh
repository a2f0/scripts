#!/bin/bash

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <path_to_folder> <s3_bucket_name> <zip_prefix>"
  echo "Example: $0 /opt/code/devopsrockstars-website/public/paperclip devopsrockstars-web-backup devopsrockstars-paperclip-production"
  exit 1
elif [ ! -e ~/.aws/credentials ]; then
  echo "~/.aws/credentials not set, exiting"
  exit 1
elif [ ! hash aws 2>/dev/null; then
  echo "aws cli tools not installed, exiting"
  exit 1
fi

CWD=`pwd`
FILE_NAME=$3-`date +%m`.`date +%d`.`date +%y`.`date +%s`.tar.gz
MOST_RECENT=$3-mostrecent

echo "Backing up: $1"
echo "To S3 Bucket: $2"
echo "Prefix: $3"

cd /tmp
tar -czf $FILE_NAME $1

echo "$FILE_NAME" > /tmp/$MOST_RECENT
aws s3 cp /tmp/$MOST_RECENT s3://$2/$MOST_RECENT
aws s3 cp /tmp/$FILE_NAME s3://$2/$FILE_NAME

echo "$FILE_NAME from S3:"
aws s3 ls s3://$2/$FILE_NAME 

echo "$MOST_RECENT from S3:"
aws s3 ls s3://$2/$MOST_RECENT

echo "$MOST_RECENT contents:"
aws s3 cp s3://$2/$MOST_RECENT -

rm -rf /tmp/$FILE_NAME
rm -rf /tmp/$MOST_RECENT

cd $CWD; unset CWD
