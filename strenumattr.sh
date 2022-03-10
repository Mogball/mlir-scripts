#!/bin/bash
csearch --f tensorflow/compiler/mlir/lite --f \.mlir$ --l \
  "$1 = \\\"" | \
  sed "s/google\/src\/files\/head\/depot/google\/src\/cloud\/jeffniu\/enumattr/g" | \
  xargs perl -i -pe "s/$1 = \"([A-Z0-9a-z_]+)\"/$1 = #tfl.$2<\1>/g"
