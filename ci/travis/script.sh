#!/bin/bash

##### Beginning of file

set -ev

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    export PATH=/Library/TeX/texbin:"$PATH"
fi

julia --check-bounds=yes --color=yes -e '
    Pkg.clone(pwd(), "PredictMD");
    '

julia --check-bounds=yes --color=yes -e '
    Pkg.build("PredictMD");
    '

julia --check-bounds=yes --color=yes -e '
    import PredictMD;
    '

julia --check-bounds=yes --color=yes -e '
    Pkg.test("PredictMD"; coverage=true);
    '

julia --check-bounds=yes --color=yes -e '
    Pkg.add("Coverage");
    '

julia --check-bounds=yes --color=yes -e '
    cd(Pkg.dir("PredictMD"));
    import Coverage;
    Coverage.Codecov.submit(Coverage.Codecov.process_folder());
    '

export PREDICTMD_PKG_DIR=`julia -e 'println(Pkg.dir("PredictMD"))'`
echo $PREDICTMD_PKG_DIR

export TRAVIS_TEMP_MAKEDOCS_DIR=`cat ~/travis_temp_makedocs_dir.txt`
echo $TRAVIS_TEMP_MAKEDOCS_DIR

ls -la $TRAVIS_TEMP_MAKEDOCS_DIR
ls -la $TRAVIS_TEMP_MAKEDOCS_DIR/build
ls -la $TRAVIS_TEMP_MAKEDOCS_DIR/deploy.jl
ls -la $TRAVIS_TEMP_MAKEDOCS_DIR/make.jl
ls -la $TRAVIS_TEMP_MAKEDOCS_DIR/mkdocs.yml
ls -la $TRAVIS_TEMP_MAKEDOCS_DIR/src

ls -la $PREDICTMD_PKG_DIR
ls -la $PREDICTMD_PKG_DIR/docs

cp -R $TRAVIS_TEMP_MAKEDOCS_DIR/build $PREDICTMD_PKG_DIR/docs/build

ls -la $PREDICTMD_PKG_DIR
ls -la $PREDICTMD_PKG_DIR/docs
ls -la $PREDICTMD_PKG_DIR/docs/build

julia --check-bounds=yes --color=yes -e '
    include(joinpath(Pkg.dir("PredictMD"), "docs", "deploy.jl",));
'

##### End of file
