# base image: kanst3mlo Debian 11 (stable)
FROM debian:bookworm

# hna kaninstalliw mariadb-server (database)
# apt-get update: bach njib latest list dyal packages
# apt-get clean + rm: bach nsghro size dyal image (ma yb9ach cache)
RUN apt-get update && apt-get install -y mariadb-server \
    && apt-get clean \
    && rm -rf /var/lib/apt-get/lists/*

# kan copyiw config dyal mariadb
# had file fih bind-address=0.0.0.0 bach y9dr yconnecti wordpress
# ila ma darinahch → ghadi yb9a localhost only
COPY conf/my.cnf /etc/mysql/my.cnf

# kan copyiw script li ghadi yrun mlli container ybda
# had script kaydir:
# - start mariadb
# - create database
# - create user
# - keep container alive
COPY tools/init.sh /init.sh

RUN chmod +x /init.sh

# port dyal mariadb (documentation only)
# kaybayan li docker bli had service kayst3ml 3306
EXPOSE 3306

# mlli container ybda → yrun init.sh
# ila ma darinahach → container ghadi yti7 (ma kayn hata process)
ENTRYPOINT ["/init.sh"]