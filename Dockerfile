# Usage: docker run --restart=always -v /var/data/blockchain-xmr:/root/.bitmonero -p 18080:18080 -p 18081:18081 -p 18089:18089 --name=monerod -td ihopf/monero-public-pruned-node
FROM ubuntu:20.04 AS build

ENV MONERO_VERSION=0.18.2.2 MONERO_SHA256=186800de18f67cca8475ce392168aabeb5709a8f8058b0f7919d7c693786d56b  

RUN apt-get update && apt-get install -y curl bzip2

WORKDIR /root

RUN curl https://dlsrc.getmonero.org/cli/monero-linux-x64-v$MONERO_VERSION.tar.bz2 -O &&\
  echo "$MONERO_SHA256  monero-linux-x64-v$MONERO_VERSION.tar.bz2" | sha256sum -c - &&\
  tar -xvf monero-linux-x64-v$MONERO_VERSION.tar.bz2 &&\
  rm monero-linux-x64-v$MONERO_VERSION.tar.bz2 &&\
  cp ./monero-x86_64-linux-gnu-v$MONERO_VERSION/monerod . &&\
  rm -r monero-*

FROM ubuntu:20.04

RUN useradd -ms /bin/bash monero && mkdir -p /home/monero/.bitmonero && chown -R monero:monero /home/monero/.bitmonero
USER monero
WORKDIR /home/monero

COPY --chown=monero:monero --from=build /root/monerod /home/monero/monerod

# blockchain location
VOLUME /home/monero/.bitmonero

EXPOSE 18080 18081 18089

ENTRYPOINT ["./monerod"]
CMD ["--enforce-dns-checkpointing", "--enable-dns-blocklist", "--out-peers=32", "--in-peers=32", "--prune-blockchain", "--non-interactive", "--no-zmq", "--no-igd", "--db-sync-mode=safe:sync", "--rpc-restricted-bind-port=18089", "--rpc-bind-ip=0.0.0.0", "--confirm-external-bind", "--public-node", "--rpc-ssl=enabled"]
