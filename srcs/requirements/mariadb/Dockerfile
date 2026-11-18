FROM debian:bookworm

RUN apt-get update && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt-get/lists/*

COPY conf/my.cnf /etc/mysql/my.cnf

COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

ENTRYPOINT ["./init.sh"]