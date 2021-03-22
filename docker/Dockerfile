FROM ruby:2.6.6-alpine3.12

ENV LANG="C.UTF-8" SSL_CERT_DIR="/etc/ssl/certs"

RUN apk add --no-cache build-base && \
    gem install servel && \
    apk del build-base

ENV SERVEL_LISTINGS="/mnt"

EXPOSE 9292

CMD ["servel"]
