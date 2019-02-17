#!/bin/bash

##### Beginning of file

set -ev

export FIRST_GROUP="travis-1"
export LAST_GROUP="travis-7"

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

mkdir -p $HOME/.julia
mkdir -p $HOME/predictmd_cache_travis
ls -la $HOME/.julia
ls -la $HOME/predictmd_cache_travis

export GROUP="$1"
echo "GROUP=$GROUP"

if [[ "$GROUP" == "$FIRST_GROUP" ]];
then
    mv $HOME/.julia $HOME/.julia_discard_firststage
    mv $HOME/predictmd_cache_travis $HOME/predictmd_cache_travis_discard_firststage
else
    :
fi

mkdir -p $HOME/.julia
mkdir -p $HOME/predictmd_cache_travis
ls -la $HOME/.julia
ls -la $HOME/predictmd_cache_travis

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
    if [[ "$GROUP" == "$LAST_GROUP" ]]; then
        julia $JULIA_FLAGS -e '
            import Pkg;
            include(joinpath(Pkg.dir("PredictMD"), "docs", "make.jl",));
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
    fi
    cat Project.toml
    cat Manifest.toml
else
    :
fi

mkdir -p $HOME/.julia
mkdir -p $HOME/predictmd_cache_travis
ls -la $HOME/.julia
ls -la $HOME/predictmd_cache_travis

if [[ "$GROUP" == "$LAST_GROUP" ]]; then
    mv $HOME/.julia $HOME/.julia_discard_laststage
    mv $HOME/predictmd_cache_travis $HOME/predictmd_cache_travis_discard_laststage
fi

mkdir -p $HOME/.julia
mkdir -p $HOME/predictmd_cache_travis
ls -la $HOME/.julia
ls -la $HOME/predictmd_cache_travis

##### End of file
