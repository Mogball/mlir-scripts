#!/bin/bash

FILES=/tmp/real_attr_flat_files

lookup_g3() {
  cs "ArrayRef" AND "NamedAttribute" --f third_party/llvm/llvm-project --l | sed 's/files\/head\/depot/cloud\/jeffniu\/real_attr_flat/' > $FILES
}

replace() {
  cat $FILES | xargs -n 4 -P 16 perl -i -pe 's/ArrayRef<(.*)NamedAttribute>/\1AttributeRange/g'
}

