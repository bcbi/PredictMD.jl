import Documenter
import Literate
import PredictMD

examples_input_directory = joinpath(
    @__DIR__,
    "..",
    "examples",
    )

examples_output_directory = joinpath(
    @__DIR__,
    "",
    "",
    "",
    "",
    )

Literate.markdown(
    ,
    examples_output_directory,
    )
Literate.notebook(
    ,
    examples_output_directory,
    )
Literate.script(
    ,
    examples_output_directory,
    )

Literate.markdown(
    ,
    examples_output_directory,
    )
Literate.notebook(
    ,
    examples_output_directory,
    )
Literate.script(
    ,
    examples_output_directory,
    )

Documenter.makedocs(
    modules = [PredictMD],
    sitename = "PredictMD.jl",
    pages = Any[
        "index.md",
        "library/internals.md",
        ],
    )
