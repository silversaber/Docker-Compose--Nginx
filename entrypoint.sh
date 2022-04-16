#!/bin/bash
set -eu
# receive env form outside

# Check="/etc/letsencrypt/live/$PrimaryDomain/fullchain.pem"
# ------------

servicesNames=(
	"Jdownloader2"
	"Netdata"
	"Photoprism"
	"Transimission"
	"Codeserver"
	"Jellyfin"
	"Jellyfin2"
	"Jenkins"
	"Nextcloud"
	"Tomcat"
)


in_array() {
    local needle array value
    needle="${1}"; shift; array=("${@}")
    for value in ${array[@]}; do [ "${value}" == "${needle}" ] && echo "true" && return; done
    echo "false"
}

function giveEnvBaseConf() {
	envsubst '${SubDomain} ${PrimaryDomain}' < /etc/nginx/template/base.conf.template > /etc/nginx/sites-available/base.conf
	envsubst '${SubDomain} ${PrimaryDomain}' < /etc/nginx/template/index.html.template > /usr/share/nginx/html/index.html
}

function giveEnvAtSubcode() {
	# path="./conf.d/subcode"
	path="/etc/nginx/template/subcode"

	for entry in "${path}"/*
	do
		echo ${entry}

		fileName=${entry#${path}}
		echo "${fileName%.template}"
		
		envsubst '${SubDomain} ${PrimaryDomain}' < ${entry} > /etc/nginx/sites-available${fileName%.template}
	done
}

function makeLinkedFile() {
	path="/etc/nginx/sites-available"

	for entry in "${path}"/*
	do
		fileName=${entry#${path}}

		ln -sf ${entry} /etc/nginx/sites-enabled${fileName}
	done
}

function checkService() {
	for ((i=0; i<${#servicesNames[@]}; i++)) 
	do	
		Check="${!servicesNames[$i]:-false}"

		# echo "${servicesNames[$i]}  ${Check}"

		if [[ ${Check} ]]; then 
			echo "${servicesNames[$i]} Pass"
			#  pass
		else 
			echo "${servicesNames[$i]} removed"
			rm /etc/nginx/template/locations/${servicesNames[$i]} 
			rm /etc/nginx/template/subcode/${servicesNames[$i]} 
			rm /etc/nginx/template/upstreams/${servicesNames[$i]} 

			# rm /etc/nginx/sites-available/locations/${servicesNames[$i]} 
			# rm /etc/nginx/sites-available/subcode/${servicesNames[$i]} 
			# rm /etc/nginx/sites-available/upstreams/${servicesNames[$i]} 
		fi
	done
}

addConfFile() {
	for ((i=0; i<${#servicesNames[@]}; i++)) 
	do 
		echo `$`${servicesNames[$i]}``
	done
}



checkService
giveEnvAtSubcode
giveEnvBaseConf
makeLinkedFile


# ----------

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