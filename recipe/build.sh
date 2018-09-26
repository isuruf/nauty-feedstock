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

programs="addedgeg amtog biplabg catg complg converseg copyg cubhamg deledgeg delptg directg dreadnaut dretodot dretog \
  genbg genbgL geng genquarticg genrang genspecialg gentourng gentreeg hamheuristic labelg linegraphg listg multig newedgeg \
  planarg ranlabg shortg showg subdivideg twohamg vcolg watercluster2 NRswitchg"

if [[ `uname` == MINGW* ]]; then
    # countg and pickg are not supported on platforms with size(void*) != size(long)
    if [[ "$check_output" != *"3 TESTS FAILED"* ]]; then
      exit 1
    fi
else
    if [[ "$check_output" != *"PASSED ALL TESTS"* ]]; then
      exit 1
    fi
    programs="$programs countg pickg"
fi

for program in $programs;
do
  cp -p $program "$LIBRARY_PREFIX"/bin/$program
done

