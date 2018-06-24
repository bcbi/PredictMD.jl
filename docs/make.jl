import Documenter
import Literate
import PredictMD

srand(999)

rm(
      joinpath(
            tempdir(),
            "make_docs",
            );
      force = true,
      recursive = true,
      )

temp_makedocs_dir = joinpath(
      tempdir(),
      "make_docs",
      "PredictMDTEMP",
      "docs",
      )

PredictMD.generate_docs(temp_makedocs_dir)
