##### Beginning of file

import Base.Test

srand(999)

Base.Test.@testset "Julia version requirements               " begin
    Base.Test.@test(Base.VERSION >= VersionNumber("0.6"))
end

Base.Test.@testset "Unit tests (CPU)                         " begin
    info("Running unit tests (CPU)")

    Base.Test.@testset "base        " begin
        include(
            joinpath(
                "cpu", "unit",
                "base",
                "test_get_version_number.jl",
                )
            )

        include(
            joinpath(
                "cpu", "unit",
                "base",
                "test_pkg_dir.jl",
                )
            )
    end

    Base.Test.@testset "code_loading" begin
        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "code_loading",
                "test_require_versions.jl",
                )
            )
    end

    Base.Test.@testset "metrics     " begin
        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "metrics",
                "test_coefficientofdetermination.jl",
                )
            )

        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "metrics",
                "test_cohenkappa.jl",
                )
            )
    end

    Base.Test.@testset "utils       " begin
        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "utils",
                "test_fix_type.jl",
                )
            )

        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "utils",
                "test-inverse-dictionary.jl",
                )
            )

        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "utils",
                "test_logging.jl",
                )
            )

        include(
            joinpath(
                "cpu", "unit",
                "toplevel", "utils",
                "test-open-browser-window.jl",
                )
            )
    end

    Base.Test.@testset "hcup        " begin
        include(
            joinpath(
                "cpu", "unit",
                "submodules", "clean",
                "hcup",
                "test_hcup_utility_functions.jl",
                )
            )
    end
end

Base.Test.@testset "Generate documentation and examples      " begin
    info("Generating examples and documentation")
    rm(
        joinpath(PredictMD.get_temp_directory(), "make_docs",);
        force = true,
        recursive = true,
        )
    temp_makedocs_dir = joinpath(
        PredictMD.get_temp_directory(),
        "make_docs",
        "PredictMDTEMP",
        "docs",
        )
    include(
        joinpath(
            "..", "docs", "make.jl",
            )
        )
end

Base.Test.@testset "Boston housing regression example (CPU)  " begin
    info("Testing Boston housing regression example (CPU)")
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "boston_housing",
            "01_preprocess_data.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "boston_housing",
            "02_linear_regression.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "boston_housing",
            "03_random_forest_regression.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "boston_housing",
            "04_knet_mlp_regression.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "boston_housing",
            "05_compare_models.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "boston_housing",
            "06_get_model_output.jl",
            )
        )
end

Base.Test.@testset "Breast cancer biopsy classification (CPU)" begin
    info("Testing breast cancer biopsy classification example (CPU)")
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "01_preprocess_data.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "02_smote.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "03_logistic_classifier.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "04_random_forest_classifier.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "05_c_svc_svm_classifier.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "06_nu_svc_svm_classifier.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "07_knet_mlp_classifier.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "08_compare_models.jl",
            )
        )
    include(
        joinpath(
            temp_makedocs_dir, "src", "examples", "cpu",
            "breast_cancer_biopsy",
            "09_get_model_output.jl",
            )
        )
end

##### End of file
