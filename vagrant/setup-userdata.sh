#!/bin/bash  -xue

script_dir=$(dirname "$0")

project_base_dir=$(readlink -f "${script_dir}/..")
vagrant_dir="${project_base_dir}/vagrant"

##
##  仮想マシンへ転送するディレクトリを用意する
##

# プロジェクトの外にある所定のディレクトリを、
# プロジェクト内の特定のディレクトリにコピーしておく。
conf_trg_dir="${project_base_dir}/data/"
rsync -av ~/VagrantConfig/ "${conf_trg_dir}/home/vagrant/"

# 転送するディレクトリをアーカイブしておく
userfile_src_dir='data'
userfile_archive_file="${vagrant_dir}/data.tar.xz"

pushd "${project_base_dir}"
rm -f "${userfile_archive_file}"
time  tar -cJvf "${userfile_archive_file}" "${userfile_src_dir}/"
popd
