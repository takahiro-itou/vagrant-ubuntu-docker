#!/bin/bash  -xu

script_dir=$(dirname  "$0")
vagrant_dir="${script_dir}/../vagrant"

pushd "${vagrant_dir}"
mkdir -p  /cygdrive/w/Vagrant/ubuntu-gui/vagrant

time  vagrant resume ; echo $?

popd
