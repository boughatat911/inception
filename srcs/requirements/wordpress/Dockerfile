FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    php \
    php-fpm \
    php-mysql \
    mariadb-client \
    curl \
    && apt-get clean \
    && rm -rf /var/lib/apt-get/lists/*

# install wp-cli (bach n setupiw wordpress)
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY tools/init.sh /init.sh
RUN chmod +x /init.sh

ENTRYPOINT ["/init.sh"]