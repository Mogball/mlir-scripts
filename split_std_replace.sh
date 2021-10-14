
declare -A ops_cpp=(
  [arith::ConstantIndexOp]=ConstantIndexOp
  [arith::ConstantIntOp]=ConstantIntOp
  [arith::ConstantFloatOp]=ConstantFloatOp
  [arith::AddIOp]=AddIOp
  [arith::SubIOp]=SubIOp
  [arith::MulIOp]=MulIOp
  [arith::DivUIOp]=UnsignedDivIOp
  [arith::DivSIOp]=SignedDivIOp
  [arith::CeilDivSIOp]=SignedCeilDivIOp
  [arith::FloorDivSIOp]=SignedFloorDivIOp
  [arith::RemUIOp]=UnsignedRemIOp
  [arith::RemSIOp]=SignedRemIOp
  [arith::AndIOp]=AndOp
  [arith::OrIOp]=OrOp
  [arith::XOrIOp]=XOrOp
  [arith::ShLIOp]=ShiftLeftOp
  [arith::ShRUIOp]=UnsignedShiftRightOp
  [arith::ShRSIOp]=SignedShiftRightOp
  [arith::NegFOp]=NegFOp
  [arith::AddFOp]=AddFOp
  [arith::SubFOp]=SubFOp
  [arith::MulFOp]=MulFOp
  [arith::DivFOp]=DivFOp
  [arith::RemFOp]=RemFOp
  [arith::ExtUIOp]=ZeroExtendIOp
  [arith::ExtSIOp]=SignExtendIOp
  [arith::ExtFOp]=FPExtOp
  [arith::TruncIOp]=TruncateIOp
  [arith::TruncFOp]=FPTruncOp
  [arith::UIToFPOp]=UIToFPOp
  [arith::SIToFPOp]=SIToFPOp
  [arith::FPToUIOp]=FPToUIOp
  [arith::FPToSIOp]=FPToSIOp
  [arith::IndexCastOp]=IndexCastOp
  [arith::BitcastOp]=BitcastOp
  [arith::CmpIOp]=CmpIOp
  [arith::CmpFOp]=CmpFOp
  [math::AbsOp]=AbsFOp
  [math::CeilOp]=CeilFOp
  [math::FloorOp]=FloorFOp
  [math::CopySignOp]=CopySignOp
  [math::FmaOp]=FmaFOp
  [arith::CmpIPredicate]=CmpIPredicate
  [arith::CmpFPredicate]=CmpFPredicate
)

declare -A ops_mlir=(
  [arith.addi]=addi
  [arith.subi]=subi
  [arith.muli]=muli
  [arith.divui]=divi_unsigned
  [arith.divsi]=divi_signed
  [arith.ceildivsi]=ceildivi_signed
  [arith.floordivsi]=floordivi_signed
  [arith.remui]=remi_unsigned
  [arith.remsi]=remi_signed
  [arith.andi]=and
  [arith.ori]=or
  [arith.xori]=xor
  [arith.shli]=shift_left
  [arith.shrui]=shift_right_unsigned
  [arith.shrsi]=shift_right_signed
  [arith.negf]=negf
  [arith.addf]=addf
  [arith.subf]=subf
  [arith.mulf]=mulf
  [arith.divf]=divf
  [arith.remf]=remf
  [arith.extui]=zexti
  [arith.extsi]=sexti
  [arith.extf]=fpext
  [arith.trunci]=trunci
  [arith.truncf]=fptrunc
  [arith.uitofp]=uitofp
  [arith.sitofp]=sitofp
  [arith.fptoui]=fptoui
  [arith.fptosi]=fptosi
  [arith.index_cast]=index_cast
  [arith.bitcast]=bitcast
  [arith.cmpi]=cmpi
  [arith.cmpf]=cmpf
  [math.abs]=absf
  [math.ceil]=ceilf
  [math.floor]=floorf
  [math.copysign]=copysign
  [math.fma]=fmaf
)

g3_lookup_cpp() {
  ALL="__xd__"
  for i in "${!ops_cpp[@]}"; do
      j=${ops_cpp[$i]}
      ALL="$ALL OR $j"
  done
  cs --l --f $1 $ALL | sed 's/files\/head\/depot/cloud\/jeffniu\/XD3/g' > ~/files
}

g3_lookup_mlir() {
  ALL="__xd__"
  for i in "${!ops_mlir[@]}"; do
      j=${ops_mlir[$i]}
      ALL="$ALL OR \" = $j \""
  done
  ALL="$ALL OR \" = constant\""
  cs --l --f $1 $ALL | sed 's/files\/head\/depot/cloud\/jeffniu\/XD3/g' > ~/files
}

g3_replace_cpp() {
  for i in "${!ops_cpp[@]}"; do
      j=${ops_cpp[$i]}
      lookup="(?<!::)\b$j\b"
      cat ~/files | xargs -n 16 -P 36 perl -i -pe "s/$lookup/$i/g"
      lookup="(?<!::)\b$jAdaptor\b"
      cat ~/files | xargs -n 16 -P 36 perl -i -pe "s/$lookup/$iAdaptor/g"
      lookup="mlir::\b$j\b"
      cat ~/files | xargs -n 16 -P 36 perl -i -pe "s/$lookup/mlir::$i/g"
  done
}

g3_replace_mlir() {
  for i in "${!ops_mlir[@]}"; do
      j=${ops_mlir[$i]}
      lookup=" = \b$j\b "
      cat ~/files | xargs -n 16 -P 36 perl -i -pe "s/$lookup/ = $i /g"
      lookup=" = \b$j\b$"
      cat ~/files | xargs -n 16 -P 36 perl -i -pe "s/$lookup/ = $i/g"
  done
  cat ~/files | xargs -n 16 -P 36 perl -i -pe 's/ = constant (?![\[\"u@])/ = arith.constant /g'
}

replace_all_cpp() {
  for i in "${!ops_cpp@]}"; do
      j=${ops_cpp[$i]}
      lookup="(?<!::)\b$j\b"
      grep -P "$lookup" -r $1 -l | xargs -n 4 -P 4 perl -i -pe "s/$lookup/$i/g"
      lookup="(?<!::)\b$jAdaptor\b"
      grep -P "$lookup" -r $1 -l | xargs -n 4 -P 4 perl -i -pe "s/$lookup/$iAdaptor/g"
      lookup="mlir::\b$j\b"
      grep -P "$lookup" -r $1 -l | xargs -n 4 -P 4 perl -i -pe "s/$lookup/mlir::$i/g"
  done
}

replace_all_mlir() {
  for i in "${!ops_mlir[@]}"; do
      j=${ops_mlir[$i]}
      lookup=" = \b$j\b "
      grep -P "$lookup" -r $1 -l | xargs -n 4 -P 4 perl -i -pe "s/$lookup/ = $i /g"
      lookup=" = \b$j\b$"
      grep -P "$lookup" -r $1 -l | xargs -n 4 -P 4 perl -i -pe "s/$lookup/ = $i/g"
  done
  grep -P ' = constant (?![\[\"u@])' -r $1 -l | xargs -n 4 -P 4 perl -i -pe 's/ = constant (?![\[\"u@])/ = arith.constant /g'
}
