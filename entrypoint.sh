#!/bin/sh
set -eu
# receive env form outside
# export SubDomain
# export PrimaryDomain
SubDomain=localhost
PrimaryDomain=localhost
USERNAME=hello
USERPWD=hello
USERNAME2=hello
USERPWD2=hello

envsubst '${SubDomain} ${PrimaryDomain}' < /base.conf.template > /etc/nginx/sites-available/base.conf
envsubst '${SubDomain} ${PrimaryDomain}' < /index.html.template > /usr/share/nginx/html/index.html
# envsubst '${SubDomain} ${PrimaryDomain}' < /cert.conf.template > /etc/nginx/sites-available/cert.conf
envsubst '${SubDomain} ${PrimaryDomain}' < /test.conf.template > /etc/nginx/sites-available/test.conf

Check="/etc/letsencrypt/live/$PrimaryDomain/fullchain.pem"

ln -sf /etc/nginx/sites-available/base.conf /etc/nginx/sites-enabled/base.conf
ln -sf /etc/nginx/sites-available/test.conf /etc/nginx/sites-enabled/test.conf

# if [ -e $Check ]; then
# 	rm -rf /etc/nginx/sites-available/cert.conf
# 	ln -sf /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf
# 	echo cert.conf_removed.
# else
# 	rm -rf /etc/nginx/sites-available/proxy.conf
# 	ln -sf /etc/nginx/sites-available/cert.conf /etc/nginx/sites-enabled/cert.conf
# 	echo proxy.conf_removed.
# fi

if [[ -n "$USERNAME" ]] && [[ -n "$USERPWD" ]]
then
	if [[ -n "$USERNAME2" ]] && [[ -n "$USERPWD2" ]]
	then
		htpasswd -bc /etc/nginx/user.htpasswd  $USERNAME $USERPWD
		htpasswd -b /etc/nginx/user.htpasswd $USERNAME2 $USERPWD2
		echo Done.
	else 
		htpasswd -bc /etc/nginx/user.htpasswd  $USERNAME $USERPWD
		echo Done.
	fi
else
    echo no auth file
fi

exec "$@"