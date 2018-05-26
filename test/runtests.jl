import Base.Test

info("Printing Julia version info:")
versioninfo(true)

info("Attempting to import PredictMD")
import PredictMD
info("Successfully imported PredictMD")
info("Printing PredictMD version info:")
println(string("PredictMD Version ", PredictMD.VERSION))

ENV["PREDICTMD_IS_RUNTESTS"] = "true"

Base.Test.@testset "PredictMD test suite" begin
    Base.Test.@testset "Unit tests (CPU)" begin
        info("Running unit tests (CPU)")
        Base.Test.@testset "base" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "base", "test_version.jl",)
                )
        end
        Base.Test.@testset "metrics" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "metrics", "test_coefficientofdetermination.jl",)
                )
            include(
                joinpath(
                    ".", "cpu", "unit", "metrics", "test_cohenkappa.jl",)
                )
        end
        Base.Test.@testset "utils" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "utils", "test_fix_dict_type.jl",)
                )
            include(
                joinpath(
                    ".", "cpu", "unit", "utils", "test_fix_vector_type.jl",)
                )
        end
    end
    Base.Test.@testset "Generate documentation and examples" begin
        Base.Test.@testset "Generate examples" begin
            info("Generating examples")
            include(
                joinpath(
                    "..",
                    "docs",
                    "make_examples.jl",
                    )
                )
        end
        Base.Test.@testset "Generate documentation" begin
            info("Generating documentation")
            include(
                joinpath(
                    "..",
                    "docs",
                    "make_docs.jl",
                    )
                )
        end
    end
    Base.Test.@testset "Test examples (CPU)" begin
        info("testing examples (CPU)")
        Base.Test.@testset "Boston housing regression (CPU)" begin
            info("testing Boston housing regression (CPU)")
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing", "01_preprocess_data.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing", "02_linear_regression.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing", "03_random_forest_regression.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing", "04_knet_mlp_regression.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing", "05_compare_models.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing", "06_get_model_output.jl",)
                )
        end
        Base.Test.@testset "Breast cancer biopsy classification (CPU)" begin
            info("testing breast cancer biopsy classification (CPU)")
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "01_preprocess_data.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "02_smote.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "03_logistic_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "04_random_forest_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "05_c_svc_svm_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "06_nu_svc_svm_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "07_knet_mlp_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "08_compare_models.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "breast_cancer_biopsy", "09_get_model_output.jl",)
                )
        end
    end
end

ENV["PREDICTMD_IS_RUNTESTS"] = "false"
