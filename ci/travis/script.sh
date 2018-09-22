#!/bin/bash

##### Beginning of file

set -ev

if [[ "$TRAVIS_OS_NAME" == "osx" ]]; then
    export PATH=/Library/TeX/texbin:"$PATH"
fi

julia --check-bounds=yes --color=yes -e '
    import Pkg;
    Pkg.build("PredictMD");
    '

julia --check-bounds=yes --color=yes -e '
    import PredictMD;
    '

julia --check-bounds=yes --color=yes -e '
    import Pkg;
    Pkg.test("PredictMD"; coverage=true);
    '

julia --check-bounds=yes --color=yes -e '
    import Pkg;
    Pkg.add("Coverage");
    '

julia --check-bounds=yes --color=yes -e '
    import Pkg;
    cd(Pkg.dir("PredictMD"));
    import Coverage;
    Coverage.Codecov.submit(Coverage.Codecov.process_folder());
    '

julia --check-bounds=yes --color=yes -e '
    import Pkg;
    include(joinpath(Pkg.dir("PredictMD"), "docs", "make.jl",));
    '
    
cat Project.toml

cat Manifest.toml

##### End of file
