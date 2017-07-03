#!/bin/sh

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <path_to_folder> <s3_bucket_name> <zip_prefix>"
  exit 1
fi

if [ ! -e ~/.aws/credentials ]; then 
  echo "~/.aws/credentials not set, existing"
  exit 1
fi

echo "Backing up: $1"
echo "To S3 Bucket: $2"
echo "Prefix: $3"

cd /tmp
tar -czvf $3-`date +%m`.`date +%d`.`date +%y`.tar.gz $1

#tar -czvf /mnt/devopsrockstars-web-backup/paperclip-production-`date +%m`.`date +%d`.`date +%y`.tar.gz paperclip && rm -rf /mnt/devopsrockstars-web-backup/paperclip-production-latest.tar.gz && ln -s /mnt/devopsrockstars-web-backup/paperclip-production-`date +%m`.`date +%d`.`date +%y`.tar.gz /mnt/devopsrockstars-web-backup/paperclip-production-latest.tar.gz

#echo 'Hello World' > /tmp/file.txt
#aws s3 cp /tmp/file.txt s3://dirname/dirsubfolder/file.txt
#rm /tmp/file.txt
