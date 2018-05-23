import Documenter
import PredictMD

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "true"

Documenter.deploydocs(
    branch = "gh-pages",
    deps = Documenter.Deps.pip(
        "pygments",
        "mkdocs",
        "python-markdown-math",
        ),
    julia = "0.6",
    latest = "develop", # latest = develop branch
    osname = "linux",
    repo = "github.com/bcbi/PredictMD.jl.git",
    target = "site",
    )

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "false"
