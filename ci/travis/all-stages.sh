#!/bin/bash

##### Beginning of file

set -ev

echo "COMPILED_MODULES=$COMPILED_MODULES"

export JULIA_FLAGS="--check-bounds=yes --code-coverage=all --color=yes --compiled-modules=$COMPILED_MODULES --inline=no"
echo "JULIA_FLAGS=$JULIA_FLAGS"

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    export PATH=/Library/TeX/texbin:"$PATH"
fi

mkdir -p $HOME/.julia
mkdir -p $HOME/predictmd_cache_travis
ls -la $HOME/.julia
ls -la $HOME/predictmd_cache_travis

############################################################################

export GROUP="$1"
echo "GROUP=$GROUP"

julia $JULIA_FLAGS -e '
    import Pkg;
    Pkg.build("PredictMD");
    '

julia $JULIA_FLAGS -e '
    import PredictMD;
    '

julia $JULIA_FLAGS -e '
    import Pkg;
    Pkg.test("PredictMD"; coverage=true);
    '

julia $JULIA_FLAGS -e '
    import Pkg;
    Pkg.add("Coverage");
    '

julia $JULIA_FLAGS -e '
    import Pkg;
    cd(Pkg.dir("PredictMD"));
    import Coverage;
    Coverage.Codecov.submit(Coverage.Codecov.process_folder());
    '

############################################################################

cat Project.toml
cat Manifest.toml

mkdir -p $HOME/.julia
mkdir -p $HOME/predictmd_cache_travis
ls -la $HOME/.julia
ls -la $HOME/predictmd_cache_travis

##### End of file
