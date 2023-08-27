FROM openresty/openresty:alpine
LABEL org.label-schema.schema-version="1.0.0"
LABEL org.label-schema.vendor="BlueFire"
LABEL org.label-schema.name="nginx"

RUN mkdir -p /var/log/nginx; \
  mkdir -p /usr/local/openresty/nginx/conf/conf.d

COPY conf /usr/local/openresty/nginx/conf
COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]

CMD ["/usr/local/openresty/bin/openresty", "-g", "daemon off;"]

EXPOSE 9090