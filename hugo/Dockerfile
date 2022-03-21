FROM alpine:edge

LABEL org.opencontainers.image.title="Hugo"
LABEL org.opencontainers.image.description="Hugo Extended and Git on Alpine Linux, for building static websites"

RUN apk update --no-cache \
    && apk add git=2.35.1-r1 --no-cache \
    && apk add hugo=0.95.0-r0 --no-cache

EXPOSE 1313

WORKDIR /root/work

ENTRYPOINT ["hugo"]
