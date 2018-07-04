##### Beginning of file

import Documenter
import Literate
import PredictMD

srand(999)

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "true"

if is_travis_ci()
    previous_working_directory = pwd()
    temp_makedocs_dir = joinpath(
          tempdir(),
          "make_docs",
          "PredictMDTEMP",
          "docs",
          )
    cd(temp_makedocs_dir)
    Documenter.deploydocs(
        branch = "gh-pages",
        deps = Documenter.Deps.pip(
                "mkdocs",
                "pygments",
                "python-markdown-math",
                ),
        julia = "0.6",
        latest = "develop",
        osname = "linux",
        repo = "github.com/bcbi/PredictMD.jl.git",
        target = "site",
        )
    cd(previous_working_directory)
else
    warn(
        string(
            "This is not a Travis build, so deploy_docs will not be run",
            )
        )
end

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "false"

##### End of file
