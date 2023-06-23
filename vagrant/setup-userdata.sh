#!/bin/bash  -xue

script_dir=$(dirname "$0")

project_base_dir=$(readlink -f "${script_dir}/..")
vagrant_dir="${project_base_dir}/vagrant"

workdir=${WORKDIR:-'/tmp'}

##
##  仮想マシンへ転送するディレクトリを用意する
##

tempdir=$(mktemp -d "${workdir}/vagrant.XXXXXXXXXX")

# プロジェクト内の所定のディレクトリの内容を、
# 作成した作業用ディレクトリにコピーする。

conf_src_dir="${project_base_dir}/data"
userfile_src_dir='data'
conf_trg_dir="${tempdir}/${userfile_src_dir}"

rsync -av "${conf_src_dir}/" "${conf_trg_dir}/"

# プロジェクトの外にある所定のディレクトリも、
# 作業用ディレクトリにコピーする。

rsync -av ~/VagrantConfig/ "${conf_trg_dir}/home/vagrant/"

# 転送するディレクトリをアーカイブしておく

userfile_archive_file="${vagrant_dir}/data.tar.xz"

rm -f "${userfile_archive_file}"

pushd "${tempdir}"
time  tar -cJvf "${userfile_archive_file}" "${userfile_src_dir}/"
popd
