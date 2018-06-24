import Documenter
import PredictMD

srand(999)

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "true"





if is_travis_ci()
    previous_working_directory = pwd()
    temp_docs_dir = joinpath(
        tempdir(),
        "travis",
        "PredictMDTEMP",
        "docs",
        )
    cd(temp_docs_dir)

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
end



ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "false"
