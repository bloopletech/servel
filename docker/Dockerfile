FROM ruby:2.7.2-alpine3.13

ENV LANG="C.UTF-8" SSL_CERT_DIR="/etc/ssl/certs"

RUN apk add --no-cache build-base openssl-dev && \
    gem install servel && \
    apk del build-base

ENV SERVEL_LISTINGS="/mnt"

EXPOSE 9292

WORKDIR /servel

CMD ["servel"]
