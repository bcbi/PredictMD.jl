#!/bin/bash

##### Beginning of file

set -ev

function myretry_10_30 ()
{
    n=1
    until [ $n -gt 10 ]
    do
        echo "Attempt $n of 10"
        "$@" && break
        n=$[$n+1]
        sleep 30
    done
}

function myretry ()
{
    myretry_10_30 "$@"
}

export COMPILED_MODULES=$COMP_MODS
export TRAVIS_JULIA_VERSION=$JULIA_VER

export PATH="${PATH}:${TRAVIS_HOME}/julia/bin"

export JULIA_PROJECT=@.

echo "COMPILED_MODULES=$COMPILED_MODULES"

export JULIA_FLAGS="--check-bounds=yes --code-coverage=all --color=yes --compiled-modules=$COMPILED_MODULES --inline=no"
echo "JULIA_FLAGS=$JULIA_FLAGS"

if [[ "$TRAVIS_OS_NAME" == "osx" ]];
then
    export PATH=/Library/TeX/texbin:"$PATH"
else
    :
fi

mkdir -p $HOME/predictmd_cache_travis
find $HOME/predictmd_cache_travis

export GROUP="$1"
echo "GROUP=$GROUP"

if [[ "$GROUP" == "$FIRST_GROUP" ]];
then
    # mv $HOME/predictmd_cache_travis $HOME/predictmd_cache_travis_discard_firststage
    :
else
    :
fi

mkdir -p $HOME/predictmd_cache_travis
find $HOME/predictmd_cache_travis

if [[ "$TRAVIS_OS_NAME" == "osx" ]];
then
    if [[ "$COMPILED_MODULES" == "yes" ]];
    then
        export DO_TESTS="true"
    else
        export DO_TESTS="false"
    fi
else
    export DO_TESTS="true"
fi

echo "TRAVIS_OS_NAME=$TRAVIS_OS_NAME"
echo "COMPILED_MODULES=$COMPILED_MODULES"
echo "DO_TESTS=$DO_TESTS"

if [[ "$DO_TESTS" == "true" ]];
then
    myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.add(Pkg.RegistrySpec(name="PredictMDRegistry",url="https://github.com/bcbi/PredictMDRegistry.git",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9",));'
    myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.update();'
    myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.add("General");'
    myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.build("PredictMD");'
    myretry julia $JULIA_FLAGS -e 'import PredictMD;'
    myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.test("PredictMD"; coverage=true);'
    myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.add("Coverage");'
    myretry julia $JULIA_FLAGS -e 'import Pkg;cd(Pkg.dir("PredictMD"));import Coverage;Coverage.Codecov.submit(Coverage.Codecov.process_folder());'
    if [[ "$GROUP" == "$LAST_GROUP" ]]; then
        myretry julia $JULIA_FLAGS -e 'import Pkg;include(joinpath(Pkg.dir("PredictMD"), "docs", "make.jl",));'
        myretry julia $JULIA_FLAGS -e 'import Pkg;Pkg.add("Coverage");'
        myretry julia $JULIA_FLAGS -e 'import Pkg;cd(Pkg.dir("PredictMD"));import Coverage;Coverage.Codecov.submit(Coverage.Codecov.process_folder());'
    fi
    cat Project.toml
    cat Manifest.toml
else
    :
fi

mkdir -p $HOME/predictmd_cache_travis
find $HOME/predictmd_cache_travis

if [[ "$GROUP" == "$LAST_GROUP" ]]; then
    # mv $HOME/predictmd_cache_travis $HOME/predictmd_cache_travis_discard_laststage
    :
fi

mkdir -p $HOME/predictmd_cache_travis
find $HOME/predictmd_cache_travis

##### End of file
