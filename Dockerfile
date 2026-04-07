FROM nginx:1.29-alpine

WORKDIR /usr/share/nginx/html

COPY nginx/default.conf /etc/nginx/conf.d/default.conf
COPY index.html ./index.html
COPY favicon.svg ./favicon.svg

EXPOSE 80
