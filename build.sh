#!/bin/sh

# Arguments
REPO=$1
BRANCH=$2

# Install Rust
wget https://sh.rustup.rs/rustup-init.sh
chmod +x rustup-init.sh
./rustup-init.sh --profile minimal --default-toolchain 1.74.0 -y

# Source Cargo environment
. $HOME/.cargo/env

# Clone the repository and check out the branch
git clone ${REPO} tezos
cd tezos
git checkout ${BRANCH}

# Install Octez dependencies
opam init --bare --disable-sandboxing -y
eval $(opam env)
PATH=${PATH##"$HOME"/tezos/:}
opam switch create 4.14.1
opam repository add tezos https://opam.ocaml.org
# opam update
# make build-deps
./scripts/install_build_deps.sh

# Compile sources
eval $(opam env)
eval $(scripts/env.sh)
make
