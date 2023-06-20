#!/bin/bash  -xu

script_dir=$(dirname  "$0")
vagrantDir=${script_dir}/../vagrant

pushd  ${vagrantDir}

time  vagrant  suspend

popd
