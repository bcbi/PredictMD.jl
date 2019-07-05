import Documenter
import DocumenterMarkdown
import DocumenterLaTeX
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
    pages = [
        "Home" => "index.md",
        "Requirements for plotting (optional)" => "requirements_for_plotting.md",
        "Examples" => [
            "Generating these example files on your computer" => "generate_examples/generate_examples.md",
            "Boston housing (single label regression)" => [
                "1\\.  Preprocess data" => "examples/cpu_examples/boston_housing/01_preprocess_data.md",
                "2\\.  Linear regressions" => "examples/cpu_examples/boston_housing/02_linear_regression.md",
                "3\\.  Random forest regression" => "examples/cpu_examples/boston_housing/03_random_forest_regression.md",
                "4\\.  Knet neural network regression" => "examples/cpu_examples/boston_housing/04_knet_mlp_regression.md",
                "5\\.  Compare models" => "examples/cpu_examples/boston_housing/05_compare_models.md",
                "6\\.  Directly access model output" => "examples/cpu_examples/boston_housing/06_get_model_output.md",
                ],
            "Breast cancer biopsy (single label binary classification)" => [
                "1\\.  Preprocess data" => "examples/cpu_examples/breast_cancer_biopsy/01_preprocess_data.md",
                "2\\.  Apply SMOTE algorithm" => "examples/cpu_examples/breast_cancer_biopsy/02_smote.md",
                "3\\.  Logistic classifier" => "examples/cpu_examples/breast_cancer_biopsy/03_logistic_classifier.md",
                "4\\.  Random forest classifier" => "examples/cpu_examples/breast_cancer_biopsy/04_random_forest_classifier.md",
                "5\\.  C-SVC support vector machine classifier" => "examples/cpu_examples/breast_cancer_biopsy/05_c_svc_svm_classifier.md",
                "6\\.  nu-SVC support vector machine classifier" => "examples/cpu_examples/breast_cancer_biopsy/06_nu_svc_svm_classifier.md",
                "7\\.  Knet neural network classifier" => "examples/cpu_examples/breast_cancer_biopsy/07_knet_mlp_classifier.md",
                "8\\.  Compare models" => "examples/cpu_examples/breast_cancer_biopsy/08_compare_models.md",
                "9\\.  Directly access model output" => "examples/cpu_examples/breast_cancer_biopsy/09_get_model_output.md",
                ],
            ],
        "Library" => [
            "Internals" => "library/internals.md",
            ],
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

if COMPILED_MODULES_CURRENT_VALUE == COMPILED_MODULES_VALUE_FOR_DOCS
    Documenter.deploydocs(
        target = "build",
        repo = "github.com/bcbi/PredictMD.jl.git",
        branch = "gh-pages",
        devbranch = "master",
        devurl = "development",
        )
end



ENV["PREDICTMD_IS_DEPLOY_DOCS"] = "false"
