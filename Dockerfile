# nginx/Dockerfile
FROM ubuntu:18.04
MAINTAINER aglide100@gmail.com

# install nginx & http ext module
RUN apt-get update && apt-get install -y nginx-extras libnginx-mod-http-dav-ext git
# install for htpaswwd / using envsubst in entrypoint.sh 
RUN apt-get install -y apache2-utils && apt-get install -y gettext-base

RUN rm -rf /etc/nginx/sites-enabled/default

RUN mkdir -p /var/webdav/file && mkdir -p /var/webdav/client_temp
RUN chown www-data:root -R /var/webdav
RUN chmod -R 777 /var/webdav

COPY nginx.conf /etc/nginx/nginx.conf

# 80/443포트로 접속시 나오는 index.html. 다른 서비스를 넣을꺼면 삭제 요망
COPY docs/ /usr/share/nginx/
RUN chmod -R 755 /usr/share/nginx/html/img

RUN  mkdir -p /etc/nginx/conf.d

RUN mkdir -p /etc/nginx/sites-available
RUN mkdir -p /etc/nginx/sites-enabled

COPY proxy.conf.template .
COPY /docs/html/index.html.template .

COPY entrypoint.sh .
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN ln -s /etc/nginx/sites-available/proxy.conf /etc/nginx/sites-enabled/proxy.conf

WORKDIR /etc/nginx 
CMD nginx -g "daemon off;"
