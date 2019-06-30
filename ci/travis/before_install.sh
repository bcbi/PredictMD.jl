#!/bin/bash

set -ev

export COMPILED_MODULES=$COMP_MODS
export TRAVIS_JULIA_VERSION=$JULIA_VER

export JULIA_PROJECT=@.

if [[ "$TRAVIS_OS_NAME" == "linux" ]];
then
    if [[ "$TRAVIS_JULIA_VERSION" == "1.1" ]];
    then
        export JULIA_URL="https://julialang-s3.julialang.org/bin/linux/x64/1.1/julia-1.1-latest-linux-x86_64.tar.gz"
    fi
    if [[ "$TRAVIS_JULIA_VERSION" == "nightly" ]];
    then
        export JULIA_URL="https://julialangnightlies-s3.julialang.org/bin/linux/x64/julia-latest-linux64.tar.gz"
    fi

    cd $HOME
    export CURL_USER_AGENT="Travis-CI $(curl --version | head -n 1)"
    mkdir -p ~/julia
    curl -A "$CURL_USER_AGENT" -s -L --retry 7 "$JULIA_URL" | tar -C ~/julia -x -z --strip-components=1 -f -
    export PATH="${PATH}:${TRAVIS_HOME}/julia/bin"
else
    :
fi

if [[ "$TRAVIS_OS_NAME" == "osx" ]];
then
    if [[ "$TRAVIS_JULIA_VERSION" == "1.1" ]];
    then
        export JULIA_URL="https://julialang-s3.julialang.org/bin/mac/x64/1.1/julia-1.1-latest-mac64.dmg"
    else
        :
    fi
    if [[ "$TRAVIS_JULIA_VERSION" == "nightly" ]];
    then
        export JULIA_URL="https://julialangnightlies-s3.julialang.org/bin/mac/x64/julia-latest-mac64.dmg"
    else
        :
    fi

    cd $HOME
    export CURL_USER_AGENT="Travis-CI $(curl --version | head -n 1)"
    curl -A "$CURL_USER_AGENT" -s -L --retry 7 -o julia.dmg "$JULIA_URL"
    mkdir juliamnt
    hdiutil mount -readonly -mountpoint juliamnt julia.dmg
    cp -a juliamnt/*.app/Contents/Resources/julia ~/
    export PATH="${PATH}:${TRAVIS_HOME}/julia/bin"
else
    :
fi

julia --color=yes -e "VERSION >= v\"0.7.0-DEV.3630\" && import InteractiveUtils; InteractiveUtils.versioninfo()"

if [[ "$TRAVIS_OS_NAME" == "osx" ]];
then
    brew update
    brew cask install basictex
    export PATH=/Library/TeX/texbin:"$PATH"
    sudo tlmgr update --self
    sudo tlmgr install luatex85
    sudo tlmgr install pgfplots
    sudo tlmgr install standalone
    brew install pdf2svg
else
    :
fi
