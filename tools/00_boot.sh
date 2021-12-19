#!/bin/bash  -xu

scriptDir=$(dirname  $0)
vagrantDir=${scriptDir}/../vagrant
pushd  ${vagrantDir}
mkdir  -p  /cygdrive/w/Vagrant/ubuntu-gui/vagrant

time  vagrant  up ; echo 0

popd
