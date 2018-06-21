import Documenter
import PredictMD

srand(999)

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "true"

if is_windows()
    warn(
        string(
            "deploy_docs is not supported on Windows, so skipping",
            )
        )
else
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
end


ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "false"

