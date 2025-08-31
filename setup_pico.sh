#!/bin/bash -xe
rm -fr ./third_party

mkdir -p ./third_party

git clone --depth 1 https://github.com/google/flatbuffers.git --branch v23.5.26 ./third_party/flatbuffers

git clone --depth 1 https://github.com/google/ruy.git ./third_party/ruy

git clone --depth 1 https://github.com/mborgerding/kissfft.git --branch 131.1.0 ./third_party/kissfft

git clone --depth 1 https://github.com/ARM-software/CMSIS-NN.git --branch v7.0.0 ./third_party/CMSIS-NN

git clone --depth 1 https://github.com/ARM-software/CMSIS_5.git ./third_party/CMSIS_5

git clone --depth 1 https://github.com/google/gemmlowp.git ./third_party/gemmlowp