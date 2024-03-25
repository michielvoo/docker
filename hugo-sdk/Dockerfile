# syntax=docker/dockerfile:1

FROM --platform=$TARGETPLATFORM alpine:3.19

RUN apk update --no-cache \
    && apk add git=~2.43 --no-cache \
    && apk add hugo=~0.120 --no-cache

EXPOSE 1313

WORKDIR /root/work

ENTRYPOINT ["hugo"]
