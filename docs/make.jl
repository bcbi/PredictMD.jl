##### Beginning of file

import Documenter
import Literate
import PredictMD

import Random
Random.seed!(999)

rm(
    joinpath(
        PredictMD.get_temp_directory(),
        "make_docs",
        );
    force = true,
    recursive = true,
    )

temp_makedocs_dir = joinpath(
    PredictMD.get_temp_directory(),
    "make_docs",
    "PredictMDTEMP",
    "docs",
    )

PredictMD.generate_docs(
    temp_makedocs_dir;
    execute_notebooks = true,
    markdown = true,
    notebooks = true,
    scripts = true,
    )

if PredictMD.is_travis_ci()
    filename = joinpath(homedir(), "travis_temp_makedocs_dir.txt")
    rm(filename; force = true, recursive = true)
    write(filename, temp_makedocs_dir)
end

##### End of file
