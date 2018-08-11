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

julia --check-bounds=yes --color=yes -e '
    import PredictMD;
    cd(Pkg.dir("PredictMD"));
    include(joinpath("docs", "deploy.jl"));
    '

##### End of file
