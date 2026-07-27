FROM debian:bookworm

RUN apt-get update && apt-get install -y nginx openssl gettext-base \
    && apt-get clean \
    && rm -rf /var/lib/apt-get/lists/*

# create ssl cert
RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/conf.d/zz.conf
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 443

ENTRYPOINT ["/init.sh"]