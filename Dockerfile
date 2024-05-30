FROM ubuntu:22.04 as builder
ARG REPO="https://gitlab.com/tezos/tezos.git"
ARG BRANCH="latest-release"

RUN apt-get update && apt-get install -y \
    rsync git m4 build-essential patch unzip wget opam jq bc bubblewrap autoconf cmake libev-dev libffi-dev libgmp-dev libhidapi-dev libprotobuf-dev libsqlite3-dev pkg-config protobuf-compiler zlib1g-dev
RUN useradd -m -s /bin/bash builduser && echo 'builduser ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
USER builduser
WORKDIR /home/builduser

COPY --chown=builduser:builduser build.sh /home/builduser/build.sh
RUN chmod +x /home/builduser/build.sh
RUN /home/builduser/build.sh ${REPO} ${BRANCH}

FROM ubuntu:22.04
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-node /usr/bin/octez-node
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-client /usr/bin/octez-client
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-smart-rollup-node /usr/bin/octez-smart-rollup-node
COPY --from=builder /home/builduser/tezos/_build/install/default/bin/octez-evm-node /usr/bin/octez-evm-node

ENTRYPOINT ["/bin/sh", "-c"]
