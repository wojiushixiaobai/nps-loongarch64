FROM golang:1.21-buster as builder

ARG GORELEASER_VERSION=latest

RUN set -ex; \
    go install github.com/goreleaser/goreleaser@${GORELEASER_VERSION}

ARG NPC_VERSION=v0.26.11
ENV NPC_VERSION=${NPC_VERSION}

ARG WORKDIR=/opt/nps

RUN set -ex; \
    git clone -b ${NPC_VERSION} --depth=1 https://github.com/wojiushixiaobai/nps ${WORKDIR}

ADD .goreleaser.yaml /opt/
WORKDIR ${WORKDIR}

RUN set -ex; \
    goreleaser --config /opt/.goreleaser.yaml release --skip-publish --clean

FROM debian:buster-slim

WORKDIR /opt/nps

COPY --from=builder /opt/nps/dist /opt/nps/dist

VOLUME /dist

CMD cp -rf dist/* /dist/