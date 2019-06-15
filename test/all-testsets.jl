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
    @info(string("Running unit tests..."))
    testmodulea_filename::String = joinpath("TestModuleA","TestModuleA.jl",)
    testmoduleb_filename::String = joinpath("TestModuleB", "directory1", "directory2", "directory3","directory4", "directory5", "TestModuleB.jl",)
    testmodulec_filename::String = joinpath(PredictMD.maketempdir(),"TestModuleC.jl",)
    rm(testmodulec_filename; force = true, recursive = true)
    open(testmodulec_filename, "w") do io
        write(io, "module TestModuleC end")
    end
    include(testmodulea_filename)
          include(testmoduleb_filename)
          include(testmodulec_filename)
    test_directory = dirname(@__FILE__)
    unit_test_directory = joinpath(test_directory, "unit")
    for (root, dirs, files) in walkdir(unit_test_directory)
        Test.@testset "$(root)" begin
            for file in files
                if endswith(lowercase(strip(file)), ".jl")
                    Test.@testset "$(file)" begin
                        include(file)
                    end
                end
            end
        end
    end
end

temp_generate_examples_dir = joinpath(
    PredictMD.maketempdir(),
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
                    temp_generate_examples_dir, "cpu_examples",
                    "boston_housing",
                    "01_preprocess_data.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "boston_housing",
                    "02_linear_regression.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration2())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "boston_housing",
                    "03_random_forest_regression.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "boston_housing",
                    "04_knet_mlp_regression.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration3())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "boston_housing",
                    "05_compare_models.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
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
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "01_preprocess_data.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "02_smote.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "03_logistic_classifier.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration5())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "04_random_forest_classifier.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "05_c_svc_svm_classifier.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "06_nu_svc_svm_classifier.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration6())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "07_knet_mlp_classifier.jl",
                    )
                )
        end
        if group_includes_block(TEST_GROUP, TestBlockIntegration7())
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "08_compare_models.jl",
                    )
                )
            include(
                joinpath(
                    temp_generate_examples_dir, "cpu_examples",
                    "breast_cancer_biopsy",
                    "09_get_model_output.jl",
                    )
                )
        end
    end
end
