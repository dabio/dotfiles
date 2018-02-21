# Build it:
#   docker build -t mysqldump .
# Run it:
#   docker run -it --rm mysqldump -h hostname -u user --password=password database > dump.sql
#
# In scripts:
#
# if [[ "$(docker images -q mysqldump 2> /dev/null)" == "" ]]; then
#   docker build -t mysqldump .
# fi
# docker run -it --rm mysqldump -h hostname -u user --password=password database > dump.sql

FROM alpine:3.7

RUN apk add --no-cache --virtual .persistent-deps \
    mariadb-client

STOPSIGNAL SIGKILL

ENTRYPOINT ["/usr/bin/mysqldump"]
