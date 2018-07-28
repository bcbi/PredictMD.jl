##### Beginning of file

import Documenter
import FileIO
import JLD2
import Literate
import PredictMD

srand(999)

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

PredictMD.generate_docs(temp_makedocs_dir)

if PredictMD.is_travis_ci()
    FileIO.save(
        joinpath(homedir(), "travis_temp_makedocs_dir.jld2"),
        "temp_makedocs_dir",
        temp_makedocs_dir,
        )
end
##### End of file
