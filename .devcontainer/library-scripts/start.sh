#!/bin/bash -xe
sudo rm -rf /var/run/dbus
sudo mkdir /var/run/dbus
sudo dbus-daemon --system

sudo chown -Rv vscode:vscode /var/lib/tpmstate

swtpm_setup --tpm2 \
    --tpmstate /var/lib/tpmstate \
    --createek --allow-signing --decryption --create-ek-cert \
    --create-platform-cert \
    --display
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
