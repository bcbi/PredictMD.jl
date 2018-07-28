##### Beginning of file

ENV["PREDICTMD_IS_RUNTESTS"] = "true"

import Base.Test

info(string("Julia package directory: \"",Pkg.dir(),"\"",))

info(string(
        "Julia cache path(s): ",
        "[",
        join("\"" .* Base.LOAD_CACHE_PATH .* "\"",", "),
        "]",
        ))

info(string("Printing Julia version info:",))
versioninfo(true)

info(string("Attempting to import PredictMD...",))

import PredictMD

info(string("Successfully imported PredictMD version ",PredictMD.version(),))

info(string(
        "PredictMD package directory: \"",
        PredictMD.predictmd_package_directory(),
        "\"",
        ))

srand(999)

ENV["PREDICTMD_IS_RUNTESTS"] = "true"

Base.Test.@testset "PredictMD test suite" begin
    Base.Test.@testset "Unit tests (CPU)" begin
        info("Running unit tests (CPU)")

        Base.Test.@testset "Module names are defined" begin
            Base.Test.@test( isdefined(:PredictMD) )
            Base.Test.@test( isdefined(Main, :PredictMD) )
            Base.Test.@test( isa(PredictMD, Module) )
            Base.Test.@test( typeof(PredictMD) == Module )
            Base.Test.@test( typeof(PredictMD) === Module )
        end

        Base.Test.@testset "Submodule names are defined" begin
            Base.Test.@test( isdefined(PredictMD, :Clean) )
            Base.Test.@test( isa(PredictMD.Clean, Module) )
            Base.Test.@test( typeof(PredictMD.Clean) == Module )
            Base.Test.@test( typeof(PredictMD.Clean) === Module )

            Base.Test.@test( isdefined(PredictMD, :GPU) )
            Base.Test.@test( isa(PredictMD.GPU, Module) )
            Base.Test.@test( typeof(PredictMD.GPU) == Module )
            Base.Test.@test( typeof(PredictMD.GPU) === Module )
        end

        Base.Test.@testset "base" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "base",
                    "test_version.jl",)
                )
        end
        Base.Test.@testset "code_loading" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "toplevel", "code_loading",
                    "test_require_versions.jl",)
                )
        end
        Base.Test.@testset "metrics" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "toplevel", "metrics",
                    "test_coefficientofdetermination.jl",)
                )
            include(
                joinpath(
                    ".", "cpu", "unit", "toplevel", "metrics",
                    "test_cohenkappa.jl",)
                )
        end
        Base.Test.@testset "utils" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "toplevel", "utils",
                    "test_fix_dict_type.jl",)
                )
            include(
                joinpath(
                    ".", "cpu", "unit", "toplevel", "utils",
                    "test_fix_vector_type.jl",)
                )
        end
        Base.Test.@testset "\"has\" functions" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "submodules", "gpu",
                    "test_gpu_has_functions.jl",)
                )
        end
        Base.Test.@testset "hcup utility functions" begin
            include(
                joinpath(
                    ".", "cpu", "unit", "submodules", "clean", "hcup",
                    "test_hcup_utility_functions.jl",)
                )
        end
    end
    rm(
          joinpath(
                PredictMD.get_temp_directory(),
                "make_docs",
                );
          force = true,
          recursive = true,
          )
    temp_makedocs_dir = joinpath(
          PredictMD.get_temp_directory(),
          "make_docs",
          "PredictMDTEMP",
          "docs",
          )
    Base.Test.@testset "Generate documentation and examples" begin
        info("Generating examples and documentation")
        include(
            joinpath(
                "..",
                "docs",
                "make.jl",
                )
            )
    end
    Base.Test.@testset "Test examples (CPU)" begin
        info("testing examples (CPU)")
        Base.Test.@testset "Boston housing regression (CPU)" begin
            info("testing Boston housing regression (CPU)")
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "boston_housing",
                    "01_preprocess_data.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "boston_housing",
                    "02_linear_regression.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "boston_housing",
                    "03_random_forest_regression.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "boston_housing",
                    "04_knet_mlp_regression.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "boston_housing",
                    "05_compare_models.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "boston_housing",
                    "06_get_model_output.jl",)
                )
        end
        Base.Test.@testset "Breast cancer biopsy classification (CPU)" begin
            info("testing breast cancer biopsy classification (CPU)")
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "01_preprocess_data.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "02_smote.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "03_logistic_classifier.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "04_random_forest_classifier.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "05_c_svc_svm_classifier.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "06_nu_svc_svm_classifier.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "07_knet_mlp_classifier.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "08_compare_models.jl",)
                )
            include(
                joinpath(
                    temp_makedocs_dir,
                    "src", "examples", "cpu",
                    "breast_cancer_biopsy",
                    "09_get_model_output.jl",)
                )
        end
    end
end

ENV["PREDICTMD_IS_RUNTESTS"] = "false"

##### End of file
