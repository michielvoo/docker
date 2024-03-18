# syntax=docker/dockerfile:1

FROM alpine:3.19

LABEL org.opencontainers.image.title="Hugo SDK"
LABEL org.opencontainers.image.description="Hugo Extended and Git on Alpine Linux, for building static websites"

RUN apk update --no-cache \
    && apk add git=~2.43 --no-cache \
    && apk add hugo=~0.120 --no-cache

EXPOSE 1313

WORKDIR /root/work

ENTRYPOINT ["hugo"]
