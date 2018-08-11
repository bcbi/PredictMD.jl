#!/bin/bash

##### Beginning of file

set -ev

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    brew update
    brew cask install basictex
    export PATH=/Library/TeX/texbin:"$PATH"
    sudo tlmgr update --self
    sudo tlmgr install luatex85
    sudo tlmgr install pgfplots
    sudo tlmgr install standalone
    brew install pdf2svg
fi

##### End of file
