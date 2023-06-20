#!/bin/bash  -xu

script_dir=$(dirname  "$0")
vagrantDir=${script_dir}/../vagrant

pushd  ${vagrantDir}
mkdir  -p  /cygdrive/w/Vagrant/ubuntu-gui/vagrant

time  vagrant  resume ; echo 0

popd
