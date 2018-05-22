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
mkpath(examples_output_parent_directory)

boston_housing_input_directory = joinpath(
    examples_input_parent_directory,
    "boston_housing",
    )
boston_housing_output_directory = joinpath(
    examples_output_parent_directory,
    "boston_housing",
    )
mkpath(boston_housing_output_directory)

Literate.markdown(
    joinpath(boston_housing_input_directory, "01_preprocess_data.jl"),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, "01_preprocess_data.jl"),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, "01_preprocess_data.jl"),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, "02_linear_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, "02_linear_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, "02_linear_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, "03_random_forest_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, "03_random_forest_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, "03_random_forest_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, "04_knet_mlp_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, "04_knet_mlp_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, "04_knet_mlp_regression.jl"),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, "05_compare_models.jl"),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, "05_compare_models.jl"),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, "05_compare_models.jl"),
    boston_housing_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(boston_housing_input_directory, "06_get_model_output.jl"),
    boston_housing_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(boston_housing_input_directory, "06_get_model_output.jl"),
    boston_housing_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(boston_housing_input_directory, "06_get_model_output.jl"),
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
mkpath(breast_cancer_biopsy_output_directory)

Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "01_preprocess_data.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "01_preprocess_data.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "01_preprocess_data.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "02_smote.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "02_smote.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "02_smote.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "03_logistic_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "03_logistic_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "03_logistic_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "04_random_forest_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "04_random_forest_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "04_random_forest_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "05_c_svc_svm_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "05_c_svc_svm_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "05_c_svc_svm_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "06_nu_svc_svm_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "06_nu_svc_svm_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "06_nu_svc_svm_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "07_knet_mlp_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "07_knet_mlp_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "07_knet_mlp_classifier.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "08_compare_models.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "08_compare_models.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "08_compare_models.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    keep_comments = true,
    )
#
Literate.markdown(
    joinpath(breast_cancer_biopsy_input_directory, "09_get_model_output.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    )
Literate.notebook(
    joinpath(breast_cancer_biopsy_input_directory, "09_get_model_output.jl"),
    breast_cancer_biopsy_output_directory;
    documenter = true,
    execute = false,
    )
Literate.script(
    joinpath(breast_cancer_biopsy_input_directory, "09_get_model_output.jl"),
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
