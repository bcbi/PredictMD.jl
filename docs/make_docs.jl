import Documenter
import Literate
import PredictMD

Documenter.makedocs(
    modules = [PredictMD],
    sitename = "PredictMD.jl",
    pages = Any[
        "index.md",
        "library/internals.md",
        ],
    )
