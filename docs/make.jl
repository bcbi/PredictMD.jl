import Documenter
import Literate
import PredictMD

srand(999)

if is_travis_ci()
    temp_makedocs_dir = joinpath(
          tempdir(),
          "travis",
          "PredictMDTEMP",
          "docs",
          )
else
    temp_makedocs_dir = joinpath(
          tempname(),
          "PredictMDTEMP",
          "docs",
          )
end

PredictMD.generate_docs(temp_makedocs_dir)
