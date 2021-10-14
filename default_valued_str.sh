#!/bin/bash

FILES=~/def_strattr_files
WORKSPACE=tranform_utils

replace_defstrattr() {
  lookup_base="<$2(<.*>)?, \"(.*)\""
  lookup="DefaultValuedAttr$lookup_base"
  grep -P "$lookup" -r $1 -l | xargs -n 4 -P 8 perl -i -pe "s/$lookup/DefaultValuedStrAttr<$2\1, \"\2\"/g"
  lookup="ConstantAttr$lookup_base"
  grep -P "$lookup" -r $1 -l | xargs -n 4 -P 8 perl -i -pe "s/$lookup/ConstantStrAttr<$2\1, \"\2\"/g"
}
