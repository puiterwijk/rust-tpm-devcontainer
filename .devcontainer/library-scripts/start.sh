#!/bin/bash -xe
sudo mkdir /var/run/dbus
sudo dbus-daemon --system

sudo chown -Rv vscode:vscode /var/lib/tpmstate

swtpm socket --tpm2 \
    --tpmstate dir=/var/lib/tpmstate \
    --flags startup-clear \
    --ctrl type=tcp,port=2322 \
    --server type=tcp,port=2321 \
    --daemon
tpm2-abrmd \
    --logger=stdout \
    --tcti=swtpm: \
    --flush-all &
