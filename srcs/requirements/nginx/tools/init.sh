#!/bin/bash

set -e

# create self-signed ssl certificate
openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout /etc/nginx/ssl/nginx.key \
-out /etc/nginx/ssl/nginx.crt \
-subj "/C=MA/ST=Casablanca/L=Casa/O=42/OU=1337/CN=$DOMAIN_NAME"

# start nginx (foreground)
exec nginx -g "daemon off;"