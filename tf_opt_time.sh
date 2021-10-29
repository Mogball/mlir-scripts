#!/bin/bash

for (( c=0; c<$1; c++ )); do
  TIMEFORMAT=%R
  time blaze-bin/third_party/tensorflow/compiler/mlir/tf-opt --tf-tpu-bridge learning/brain/mlir/bridge/regression_tests/$2.mlir --mlir-disable-threading -o /tmp/out.mlir
done
