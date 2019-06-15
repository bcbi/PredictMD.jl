import Pkg

Pkg.add("Documenter")
Pkg.add("Literate")

import Documenter
import Literate
import PredictMD

import Random
Random.seed!(999)

ENV["PREDICTMD_IS_MAKE_DOCS"] = "true"

generate_examples_output_directory = PredictMD.package_directory(
    "docs",
    "src",
    "examples",
    )

rm(
    generate_examples_output_directory;
    force = true,
    recursive = true,
    )

PredictMD.generate_examples(
    generate_examples_output_directory;
    execute_notebooks = false,
    markdown = true,
    notebooks = true,
    scripts = true,
    include_test_statements = false,
    )

Documenter.makedocs(
    modules = [
        PredictMD,
        PredictMD.Cleaning,
        PredictMD.Compilation,
        PredictMD.GPU,
        PredictMD.Server,
        ],
    pages = Any[
        "index.md",
        "requirements_for_plotting.md",
        "library/internals.md",
        ],
    root = PredictMD.package_directory(
        "docs",
        ),
    sitename = "PredictMD documentation",
    )

ENV["PREDICTMD_IS_MAKE_DOCS"] = "false"

ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "true"

COMPILED_MODULES_CURRENT_VALUE = strip(
    lowercase(strip(get(ENV, "COMPILED_MODULES", "")))
    )
COMPILED_MODULES_VALUE_FOR_DOCS = strip(
    lowercase(strip(get(ENV, "COMPILED_MODULES_VALUE_FOR_DOCS", "")))
    )
JULIA_VERSION_FOR_DOCS = strip(
    lowercase(strip(get(ENV, "JULIA_VERSION_FOR_DOCS", "")))
    )

@debug("COMPILED_MODULES_CURRENT_VALUE: ", COMPILED_MODULES_CURRENT_VALUE,)
@debug("COMPILED_MODULES_VALUE_FOR_DOCS: ", COMPILED_MODULES_VALUE_FOR_DOCS,)
@debug("JULIA_VERSION_FOR_DOCS: ", JULIA_VERSION_FOR_DOCS,)

if COMPILED_MODULES_CURRENT_VALUE == COMPILED_MODULES_VALUE_FOR_DOCS
    Documenter.deploydocs(
        branch = "gh-pages",
        deps = Documenter.Deps.pip(
            "mkdocs",
            "pygments",
            "python-markdown-math",
            ),
        julia = JULIA_VERSION_FOR_DOCS,
        latest = "master",
        osname = "linux",
        repo = "github.com/bcbi/PredictMD.jl.git",
        target = "site",
        )
end



ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "false"

