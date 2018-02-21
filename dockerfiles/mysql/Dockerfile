# Build it:
#   docker build -t mysql .
# Run it:
#   docker run -it --rm mysql -h hostname -u user database
#
# In scripts:
#
# if [[ "$(docker images -q mysql 2> /dev/null)" == "" ]]; then
#   docker build -t mysql .
# fi
# docker run -it --rm mysql -h hostname -u user database

FROM alpine:3.7

RUN apk add --no-cache --virtual .persistent-deps \
    mariadb-client

STOPSIGNAL SIGKILL

ENTRYPOINT ["/usr/bin/mysql"]
