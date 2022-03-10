WORKSPACE=$1
SANDBOX_DIR=$HOME/src/iree-llvm-sandbox
CL=$2

TMP0=/tmp/_iree_export_files0

g4 whatsout -c $CL > $TMP0
sed -i "s/^google3\/third_party\/mlir_edge\/iree_llvm_sandbox\///g" $TMP0
cat $TMP0 | xargs -I{} cp /google/src/cloud/jeffniu/$WORKSPACE/google3/third_party/mlir_edge/iree_llvm_sandbox/{} $SANDBOX_DIR/{}
