# monero-public-pruned-node

Docker image to run a monero full network node with restricted public RPC, unrestricted private RPC, and a pruned blockchain.

# Usage

`docker run --restart=always -v /var/data/blockchain-xmr:/root/.bitmonero -p 18080:18080 -p 18081:18081 -p 18089:18089 --name=monerod -td ihopf/monero-public-pruned-node`

## Updates
Manual Way
```
docker stop monerod
docker rm monerod
docker pull ihopf/monero-public-pruned-node
```
Then launch using the "how to use" command above

Automatic way
https://github.com/v2tec/watchtower
