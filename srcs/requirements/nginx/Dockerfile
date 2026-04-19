FROM debian:bookworm

RUN apt update && apt install -y nginx openssl \
    && apt clean \
    && rm -rf /var/lib/apt/lists/*

# create ssl cert
RUN mkdir -p /etc/nginx/ssl

COPY conf/nginx.conf /etc/nginx/nginx.conf
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

EXPOSE 443

ENTRYPOINT ["/init.sh"]