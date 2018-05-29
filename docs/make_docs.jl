import Documenter
import Literate
import PredictMD

ENV["PREDICTMD_IS_MAKE_DOCS"] = "true"

Documenter.makedocs(
    modules = [
        PredictMD,
        PredictMD.Clean,
        PredictMD.GPU,
        ],
    sitename = "PredictMD.jl",
    pages = Any[
        "index.md",
        "library/internals.md",
        ],
    )

ENV["PREDICTMD_IS_MAKE_DOCS"] = "false"
