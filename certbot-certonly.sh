#!/bin/bash

if [[ $# -lt 3 ]]; then
  echo "Usage: $0 <webroot> <fqdn1> <fqdn2>"
  echo "Example: $0 /opt/code/devopsrockstars-website/public/ devopsrockstars.com rose.devopsrockstars.com"
  exit 1
elif [ ! -e /usr/local/bin/certbot-auto ]; then
  echo "certbot-auto not installed, exiting"
  exit 1
fi

/usr/local/bin/certbot-auto certonly --no-bootstrap -n --webroot -w $1 -d $2 -d $3 --logs-dir=/opt/certbot/logs --config-dir=/opt/certbot/config --work-dir=/opt/certbot/work --email=webmaster@devopsrockstars.com --agree-tos --expand --hsts --post-hook 'apachectl restart' --debug
