#!/bin/bash
# while read line;
# do
# 	export $line
# done < .env



set -eu
# # receive env form outside
# export SubDomain
# export PrimaryDomain


# # envsubst '${SubDomain} ${PrimaryDomain}' < /cert.conf.template > /etc/nginx/sites-available/cert.conf
# envsubst '${SubDomain} ${PrimaryDomain}' < /test.conf.template > /etc/nginx/sites-available/test.conf

# Check="/etc/letsencrypt/live/$PrimaryDomain/fullchain.pem"

# ln -sf /etc/nginx/sites-available/base.conf /etc/nginx/sites-enabled/base.conf
# ln -sf /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled/test.conf

# if [ -e $Check ]; then
# 	rm -rf /etc/nginx/sites-available/cert.conf
# 	ln -sf /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
# 	echo cert.conf_removed.
# else
# 	rm -rf /etc/nginx/sites-available/proxy.conf
# 	ln -sf /etc/nginx/sites-available/cert.conf /etc/nginx/sites-enabled/cert.conf
# 	echo proxy.conf_removed.
# fi
