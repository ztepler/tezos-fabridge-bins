FROM ubuntu:22.04
COPY octez-evm-node /usr/bin/octez-evm-node
ENTRYPOINT [ "/bin/sh", "-c" ]

