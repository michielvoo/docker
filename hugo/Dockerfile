FROM alpine:3.14.0

LABEL org.opencontainers.image.title="Hugo"
LABEL org.opencontainers.image.description="Hugo Extended and Git on Alpine Linux, for building static websites"

RUN apk update --no-cache \
    && apk add git=2.32.0-r0 --no-cache \
    && apk add hugo=0.83.1-r1 --no-cache

EXPOSE 1313

WORKDIR /src

ENTRYPOINT ["hugo"]
