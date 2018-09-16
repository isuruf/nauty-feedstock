#!/bin/bash

export CFLAGS="-O2 -g $CFLAGS"

if [[ `uname` == MINGW* ]]; then
    export PATH="$PREFIX/Library/bin:$BUILD_PREFIX/Library/bin:$PATH"
    export CC=clang-cl
    export RANLIB=llvm-ranlib
    export AS=llvm-as
    export AR=llvm-ar
    export LD=lld-link
    export CFLAGS="-MD -I$PREFIX/Library/include -O2"
    export LDFLAGS="$LDFLAGS -L$PREFIX/Library/lib"
    export LIBRARY_PREFIX=$PREFIX/Library
else
    export LIBRARY_PREFIX=$PREFIX
fi

./configure  --disable-popcnt --disable-clz
make

check_output=`make checks`
echo "$check_output"

if [[ "$check_output" != *"PASSED ALL TESTS"* ]]; then
  exit
fi

for program in addedgeg amtog biplabg catg complg converseg copyg countg cubhamg deledgeg delptg directg dreadnaut dretodot dretog \
  genbg genbgL geng genquarticg genrang genspecialg gentourng gentreeg hamheuristic labelg linegraphg listg multig newedgeg \
  pickg planarg ranlabg shortg showg subdivideg twohamg vcolg watercluster2 NRswitchg;
do
  cp -p $program "$LIBRARY_PREFIX"/bin/$program
done

