#!/bin/bash  -xue

script_dir=$(dirname "$0")

project_base_dir=$(readlink -f "${script_dir}/..")

# 所定のディレクトリを、仮想マシンへ転送する用意をする
rsync -av ~/VagrantConfig/ "${project_base_dir}/data/home/vagrant/"
