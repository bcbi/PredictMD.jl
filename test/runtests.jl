import Base.Test

info("Printing Julia version info:")
versioninfo(true)

info("Attempting to import PredictMD")
import PredictMD
info("Successfully imported PredictMD")
info("Printing PredictMD version info:")
println(string("PredictMD Version ", PredictMD.version()))

srand(999)

Base.flush( Base.STDOUT )
Base.flush( Base.STDERR )

ENV["PREDICTMD_IS_RUNTESTS"] = "true"

Base.Test.@testset "PredictMD test suite" begin
    Base.flush( Base.STDOUT )
    Base.flush( Base.STDERR )
    Base.Test.@testset "Test module imports" begin
        info("Testing module imports")
        
        import PredictMD
        Base.Test.@test( isdefined(:PredictMD) )
        Base.Test.@test( typeof(PredictMD) === Module )
        
        import PredictMD.Clean
        Base.Test.@test( isdefined(PredictMD, :Clean) )
        Base.Test.@test( typeof(PredictMD.Clean) === Module )
        
        import PredictMD.GPU
        Base.Test.@test( isdefined(PredictMD, :GPU) )
        Base.Test.@test( typeof(PredictMD.GPU) === Module )
    end
    Base.Test.@testset "Unit tests (CPU)" begin
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
        info("Running unit tests (CPU)")
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
        Base.Test.@testset "base" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "base", "test_version.jl",)
                )
        end
        Base.Test.@testset "metrics" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "metrics",
                    "test_coefficientofdetermination.jl",)
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
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
        Base.Test.@testset "Generate examples" begin
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            info("Generating examples")
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            include(
                joinpath(
                    "..",
                    "docs",
                    "make_examples.jl",
                    )
                )
        end
        Base.Test.@testset "Generate documentation" begin
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            info("Generating documentation")
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            include(
                joinpath(
                    "..",
                    "docs",
                    "make_docs.jl",
                    )
                )
        end
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
    end
    Base.Test.@testset "Test examples (CPU)" begin
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
        info("testing examples (CPU)")
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
        Base.Test.@testset "Boston housing regression (CPU)" begin
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            info("testing Boston housing regression (CPU)")
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing",
                    "01_preprocess_data.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing",
                    "02_linear_regression.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing",
                    "03_random_forest_regression.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing",
                    "04_knet_mlp_regression.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing",
                    "05_compare_models.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu", "boston_housing",
                    "06_get_model_output.jl",)
                )
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
        end
        Base.Test.@testset "Breast cancer biopsy classification (CPU)" begin
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            info("testing breast cancer biopsy classification (CPU)")
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "01_preprocess_data.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "02_smote.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "03_logistic_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "04_random_forest_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "05_c_svc_svm_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "06_nu_svc_svm_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "07_knet_mlp_classifier.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "08_compare_models.jl",)
                )
            include(
                joinpath(
                    "..", "docs", "src", "examples", "cpu",
                    "breast_cancer_biopsy", "09_get_model_output.jl",)
                )
            Base.flush( Base.STDOUT )
            Base.flush( Base.STDERR )
        end
        Base.flush( Base.STDOUT )
        Base.flush( Base.STDERR )
    end
    Base.flush( Base.STDOUT )
    Base.flush( Base.STDERR )
end

ENV["PREDICTMD_IS_RUNTESTS"] = "false"

Base.flush( Base.STDOUT )
Base.flush( Base.STDERR )
