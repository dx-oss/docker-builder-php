#!/bin/bash
hosts="github.com"
hosts=${SSH_KNOWN_HOSTS:-$hosts}
cd ~/
homedir=$(pwd)
homedir=${1:-$homedir}
if [ "${SSH_PRIVATE_KEY}" = "" ]; then echo "SSH_PRIVATE_KEY build-arg is required" && exit 1 ; fi
mkdir -p $homedir/.ssh
ssht sshkey --private-file=$homedir/.ssh/id_rsa --overwrite
chmod 600 $homedir/.ssh/id_rsa
if [ `grep -c ENCRYPTED $homedir/.ssh/id_rsa` = 1 ]; then echo "The SSH key cannot have password" && exit 1 ; fi
touch $homedir/.ssh/known_hosts
for h in $hosts
do
    ssh-keyscan $h >> $homedir/.ssh/known_hosts
done
if [ "${BUILD_DEBUG}" = "1" ]; then cat $homedir/.ssh/id_rsa ; fi
