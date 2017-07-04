#!/bin/bash

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <pg_db_name> <s3_bucket_name> <prefix>"
  echo "Example: $0 devopsrockstars devopsrockstars-web-backup devopsrockstars-postgres"
  exit 1
elif [ ! -e ~/.aws/credentials ]; then
  echo "~/.aws/credentials not set, exiting"
  exit 1
elif [ ! hash aws 2>/dev/null ]; then
  echo "aws cli tools not installed, exiting"
  exit 1
fi

CWD=`pwd`
FILE_NAME=$3-`date +%m`.`date +%d`.`date +%y`.`date +%s`.psql
MOST_RECENT=$3-mostrecent

echo "Backing up: $1"
echo "To S3 Bucket: $2"
echo "Prefix: $3"

cd /tmp
pg_dump -Fc --no-owner -U postgres $1 > $FILE_NAME

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
