#!/bin/bash
set -e
#####################################
##
## Install cross toolchain
#####################################

if [ -z $TOOT ]; then
	ROOT=`cd .. && pwd`
fi

TOOLS="$ROOT/toolchain"
TOOLTARXZ="$ROOT/external/toolchain_tar/toolchain"
TOOLTAR="$ROOT/external/toolchain.tar.gz"

echo "Uncompress toolchain.. "
cat ${TOOLTARXZ}* > ${TOOLTAR}

tar xzvf $TOOLTAR -C $ROOT
rm -rf $TOOLTAR


