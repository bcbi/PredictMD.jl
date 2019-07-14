#!/bin/bash

set -ev

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

export GROUP="$1"
echo "GROUP=$GROUP"

mkdir -p $HOME/predictmd_cache_travis
tree $HOME/predictmd_cache_travis

if [[ "$GROUP" == "$FIRST_GROUP" ]];
then
    # rm -rf $HOME/predictmd_cache_travis_discard_firststage
    # mv $HOME/predictmd_cache_travis $HOME/predictmd_cache_travis_discard_firststage
    :
else
    :
fi

mkdir -p $HOME/predictmd_cache_travis
tree $HOME/predictmd_cache_travis

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
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.add("General");'
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.update();'
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.add(Pkg.RegistrySpec(name="BCBIRegistry",url="https://github.com/bcbi/BCBIRegistry.git",uuid="26a550a3-39fe-4af4-af6d-e8814c2b6dd9",));'
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.Registry.update();'
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.build("PredictMD");'
    julia $JULIA_FLAGS -e '
        logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
        if !isnothing(logger)
            if ispath(Base.active_project())
                println(logger.stream, "# Location of default environment Project.toml: \"$(Base.active_project())\"")
                println(logger.stream, "# Beginning of default environment Project.toml")
                println(logger.stream, read(Base.active_project(), String))
                println(logger.stream, "# End of default environment Project.toml")
            else
                println(logger.stream, "# File \"$(Base.active_project())\" does not exist")
            end
            if ispath(joinpath(dirname(Base.active_project()), "Manifest.toml"))
                println(logger.stream, "# Location of default environment Manifest.toml: \"$(joinpath(dirname(Base.active_project()), "Manifest.toml"))\"")
                println(logger.stream, "# Beginning of default environment Manifest.toml")
                println(logger.stream, read(joinpath(dirname(Base.active_project()), "Manifest.toml"),String))
                println(logger.stream, "# End of default environment Manifest.toml")
            else
                println(logger.stream, "# File \"$(joinpath(dirname(Base.active_project()), "Manifest.toml"))\" does not exist")
            end
        end
        '
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.test("PredictMD"; coverage=true);'
    if [[ "$GROUP" == "$LAST_GROUP" ]]; then
        if [[ "$TRAVIS_JULIA_VERSION" == "$JULIA_VERSION_FOR_DOCS" ]]; then
            if [[ "$TRAVIS_OS_NAME" == "linux" ]]; then
                julia $JULIA_FLAGS --project=docs/ -e 'import Pkg; Pkg.develop(Pkg.PackageSpec(path=pwd())); Pkg.instantiate()'
                julia $JULIA_FLAGS --project=docs/ docs/make.jl
            fi
        fi
    fi
    julia $JULIA_FLAGS -e 'import Pkg;Pkg.add("Coverage");'
    julia $JULIA_FLAGS -e 'import Pkg;cd(Pkg.dir("PredictMD"));import Coverage;Coverage.Codecov.submit(Coverage.Codecov.process_folder());'
else
    :
fi

mkdir -p $HOME/predictmd_cache_travis
tree $HOME/predictmd_cache_travis

if [[ "$GROUP" == "$LAST_GROUP" ]]; then
    # rm $HOME/predictmd_cache_travis_discard_laststage
    # mv $HOME/predictmd_cache_travis $HOME/predictmd_cache_travis_discard_laststage
    :
fi

mkdir -p $HOME/predictmd_cache_travis
tree $HOME/predictmd_cache_travis
