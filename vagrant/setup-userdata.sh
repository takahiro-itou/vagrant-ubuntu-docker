#!/bin/bash  -xue

script_dir=$(dirname "$0")

project_base_dir=$(readlink -f "${script_dir}/..")
vagrant_dir="${project_base_dir}/vagrant"

# 所定のディレクトリを、仮想マシンへ転送する用意をする
rsync -av ~/VagrantConfig/ "${project_base_dir}/data/home/vagrant/"

# 転送するディレクトリをアーカイブしておく
pushd "${project_base_dir}"
rm -f "${vagrant_dir}/data.tar.xz"
time  tar -cJvf "${vagrant_dir}/data.tar.xz" data/
popd
