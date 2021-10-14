#!/bin/bash

FILES=~/def_strattr_files
WORKSPACE=tranform_utils

g3_lookup() {
  repl="s/files\/head\/depot/cloud\/jeffniu\/$WORKSPACE/"
  csearch file:$1 "DefaultValuedAttr<StrAttr" --l | sed "$repl" > $FILES
}

g3_replace() {
  cat $FILES | xargs -n 4 -P 16 perl -i -pe 's/DefaultValuedAttr<StrAttr, "(?!\\)(.*)"/DefaultValuedAttr<StrAttr, "\\"\1\\""/g'
}

replace_defstrattr() {
  lookup='s/DefaultValuedAttr<StrAttr, "(?!\\)(.*)"'
  grep -P "$lookup" -r $1 -l | xargs -n 4 -P 8 perl -i -pe "s/$lookup/DefaultValuedAttr<StrAttr, "\\"\1\\""/g"
}
