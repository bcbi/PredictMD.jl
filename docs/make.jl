##### Beginning of file

Pkg.add("Documenter")
Pkg.add("Literate")

import Documenter
import Literate
import PredictMD

import Random
Random.seed!(999)

ENV["PREDICTMD_IS_MAKE_DOCS"] = "true"

generate_examples_output_directory =

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
    root = @__DIR__,
    sitename = "PredictMD documentation",
    )

ENV["PREDICTMD_IS_MAKE_DOCS"] = "false"

##### End of file
