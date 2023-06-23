#!/bin/bash  -xu

script_dir=$(dirname  "$0")
vagrant_dir="${script_dir}/../vagrant"

# 所定のディレクトリを、仮想マシンへ転送する用意をする
project_base_dir=$(readlink -f "${script_dir}/..")
/bin/bash -xue "${vagrant_dir}/setup-userdata.sh"
rsync -av ~/VagrantConfig/ "${project_base_dir}/data/home/vagrant/"

pushd "${vagrant_dir}"
mkdir -p /cygdrive/w/Vagrant/ubuntu-gui/vagrant

time  vagrant destroy -f
time  vagrant up ; echo $?

popd
