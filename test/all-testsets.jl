##### Beginning of file

import InteractiveUtils # stdlib
import Pkg # stdlib
import Test # stdlib

import Random
Random.seed!(999)

@info(string("Julia depot paths: "), Base.DEPOT_PATH)
@info(string("Julia load paths: "), Base.LOAD_PATH)

@info(string("Julia version info: ",))
InteractiveUtils.versioninfo(verbose=true)

@info(string("Output of Pkg.status():",),)
Pkg.status()

@info(string("Output of Pkg.status(Pkg.Types.PKGMODE_PROJECT):",),)
Pkg.status(Pkg.Types.PKGMODE_PROJECT)

@info(string("Output of Pkg.status(Pkg.Types.PKGMODE_MANIFEST):",),)
Pkg.status(Pkg.Types.PKGMODE_MANIFEST)

@info(string("Output of Pkg.status(Pkg.Types.PKGMODE_COMBINED):",),)
Pkg.status(Pkg.Types.PKGMODE_COMBINED)

@info(string("Attempting to import PredictMD...",))
import PredictMD
@info(string("Successfully imported PredictMD.",))
@info(string("PredictMD version: "),PredictMD.version(),)
@info(string("PredictMD package directory: "),PredictMD.package_directory(),)

@info(string("Julia depot paths: "), Base.DEPOT_PATH)
@info(string("Julia load paths: "), Base.LOAD_PATH)

import PredictMD

if group_includes_block(TEST_GROUP, TestBlockUnitTests())
    Test.@testset "Unit tests       " begin
        @info(string("Running unit tests..."))

        Test.@testset "Julia version requirements" begin
            Test.@test(Base.VERSION >= VersionNumber("0.6"))
        end

        Test.@testset "base                      " begin
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
            testmodulea_filename::String = joinpath(
                "TestModuleA",
                "TestModuleA.jl",
                )
            testmoduleb_filename::String = joinpath(
                "TestModuleB", "directory1", "directory2", "directory3",
                "directory4", "directory5", "TestModuleB.jl",
                )
            testmodulec_filename::String = joinpath(
                mktempdir(),
                "TestModuleC.jl",
                )
            rm(testmodulec_filename; force = true, recursive = true)
            open(testmodulec_filename, "w") do io
                write(io, "module TestModuleC end")
            end
            include(testmodulea_filename)
            include(testmoduleb_filename)
            include(testmodulec_filename)
            include(joinpath("test_package_directory.jl"))
            include(joinpath("test_registry_url_list.jl"))
            include(joinpath("test_version.jl"))
            include(joinpath("test_version_codename.jl"))
        end

        Test.@testset "code_loading              " begin
            include(
                joinpath(
                    "cpu", "unit",
                    "toplevel", "code_loading",
                    "test_require_versions.jl",
                    )
                )
        end

        Test.@testset "metrics                   " begin
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

        Test.@testset "utils                     " begin
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
                    "test-open-browser-window.jl",
                    )
                )
        end

        Test.@testset "hcup                      " begin
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
end

temp_generate_examples_dir = joinpath(
    PredictMD.get_temp_directory(),
    "generate_examples",
    "PredictMDTEMP",
    "examples",
    )

rm(
    temp_generate_examples_dir;
    force = true,
    recursive = true,
    )

Test.@testset "Integration tests" begin
    @info(string("Running integration tests..."))
    Test.@testset "Generate examples      " begin
        PredictMD.generate_examples(
            temp_generate_examples_dir;
            scripts = true,
            include_test_statements = true,
            markdown = false,
            notebooks = false,
            execute_notebooks = false,
            )
    end
    Test.@testset "Boston housing regression example (CPU)  " begin
        @info("Testing Boston housing regression example (CPU)")
        if group_includes_block(TEST_GROUP, TestBlockIntegration1())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "boston_housing",
                    "01_preprocess_data.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "boston_housing",
                    "02_linear_regression.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration2())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "boston_housing",
                    "03_random_forest_regression.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "boston_housing",
                    "04_knet_mlp_regression.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration3())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "boston_housing",
                    "05_compare_models.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "boston_housing",
                    "06_get_model_output.jl",
                    )
                )
        end
    end
    Test.@testset "Breast cancer biopsy classification (CPU)" begin
        @info("Testing breast cancer biopsy classification example (CPU)")
        if group_includes_block(TEST_GROUP, TestBlockIntegration4())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "01_preprocess_data.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "02_smote.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "03_logistic_classifier.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration5())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "04_random_forest_classifier.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "05_c_svc_svm_classifier.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "06_nu_svc_svm_classifier.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration6())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "07_knet_mlp_classifier.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration7())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "08_compare_models.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu",
                    "breast_cancer_biopsy",
                    "09_get_model_output.jl",
                    )
                )
        end
    end
end

##### End of file
