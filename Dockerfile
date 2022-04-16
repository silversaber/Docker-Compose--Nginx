FROM nginx:1.21-alpine

RUN apk add --update apache2-utils \
    && rm -rf /var/cache/apk/*

RUN apk add --no-cache --upgrade bash


RUN mkdir -p /etc/nginx/sites-available && mkdir -p /etc/nginx/sites-enabled
RUN rm -rf /etc/nginx/sites-enabled/default
RUN mkdir -p /var/webdav/file/share && mkdir -p /var/webdav/client_temp
RUN mkdir -p /etc/nginx/conf.d


# COPY /etc/nginx/sites-available/*.conf /etc/nginx/sites-enabled/

# RUN chown www-data:root -R /var/webdav
# RUN chmod -R 755 /var/webdav

COPY nginx.conf /etc/nginx/nginx.conf

COPY docs/ /usr/share/nginx/

COPY .env .

COPY conf.d/ .
COPY cert.conf.template .
COPY /docs/html/index.html.template .

COPY /docs/html/test.html /usr/share/nginx/html/

COPY entrypoint.sh .
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]


WORKDIR /etc/nginx 
CMD nginx -g "daemon off;"



# install nginx & http ext module
# RUN apt-get update && apt-get install -y nginx-extras libnginx-mod-http-dav-ext git
# # install for htpaswwd / using envsubst in entrypoint.sh 
# RUN apt-get install -y apache2-utils && apt-get install -y gettext-base
