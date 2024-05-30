FROM alpine:latest as builder
ARG REPO="https://gitlab.com/tezos/tezos.git"
ARG BRANCH="latest-release"
RUN apk update && apk add --no-cache \
    bash git m4 build-base patch unzip wget opam jq bc bubblewrap autoconf cmake libev-dev libffi-dev gmp-dev hidapi-dev protobuf-dev sqlite-dev zlib-dev

RUN adduser -D builduser
USER builduser
WORKDIR /home/builduser

COPY --chown=builduser:builduser build.sh /home/builduser/build.sh
RUN chmod +x /home/builduser/build.sh

RUN /home/builduser/build.sh ${REPO} ${BRANCH}

FROM alpine:latest

COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-node /usr/bin/octez-node
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-client /usr/bin/octez-client
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-smart-rollup-node /usr/bin/octez-smart-rollup-node
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-evm-node /usr/bin/octez-evm-node

RUN chmod +x /usr/bin/octez-node /usr/bin/octez-client /usr/bin/octez-smart-rollup-node /usr/bin/octez-evm-node

RUN /usr/bin/octez-evm-node --version

ENTRYPOINT ["/bin/sh", "-c"]
