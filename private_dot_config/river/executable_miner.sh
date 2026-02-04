#!/bin/bash
set -eu

sudo nvidia-smi -pl 165
cd ~/miners/trex
./t-rex -a kawpow -o stratum+tcp://rvn.2miners.com:6060 \
-u RTNzb97f2pSZYJCG5xTW4FJKZrb4ftpnpR.worker1 -i 18

exit 0
