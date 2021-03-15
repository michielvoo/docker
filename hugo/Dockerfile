FROM alpine:3.13.0

RUN apk update --no-cache \
    && apk add git=2.30.2-r0 --no-cache \
    && apk add hugo=0.79.1-r0 --no-cache

EXPOSE 1313

WORKDIR /src

ENTRYPOINT ["hugo"]
