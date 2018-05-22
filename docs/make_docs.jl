import Documenter
import Literate

info("DEBUG: importing PredictMD")

import PredictMD

info("DEBUG: using Literate.jl to generate examples")

examples_input_parent_directory = joinpath(
    @__DIR__,
    "..",
    "examples",
    )
examples_output_parent_directory = joinpath(
    @__DIR__,
    "src",
    "examples",
    )

boston_housing_input_directory = joinpath(
    examples_input_parent_directory,
    "boston_housing",
    )
boston_housing_output_directory = joinpath(
    examples_output_parent_directory,
    "boston_housing",
    )

Literate.markdown(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, ""),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )

breast_cancer_biopsy_input_directory = joinpath(
    examples_input_parent_directory,
    "breast_cancer_biopsy",
    )
breast_cancer_biopsy_output_directory = joinpath(
    examples_output_parent_directory,
    "breast_cancer_biopsyg",
    )

Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, ""),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )


info("DEBUG: using Documenter.jl to generate Markdown docs")

Documenter.makedocs(
    modules = [PredictMD],
    sitename = "PredictMD.jl",
    pages = Any[
        "index.md",
        "library/internals.md",
        ],
    )
