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
@info(
    string("PredictMD package directory: "),
    PredictMD.package_directory(),
    )

@info(string("Attempting to import PredictMDExtra...",))
import PredictMDExtra
@info(string("Successfully imported PredictMDExtra.",))
@info(string("PredictMDExtra version: "),PredictMDExtra.version(),)
@info(
    string("PredictMDExtra package directory: "),
    PredictMDExtra.package_directory(),
    )

@info(string("Julia depot paths: "), Base.DEPOT_PATH)
@info(string("Julia load paths: "), Base.LOAD_PATH)

import DataFrames

if group_includes_block(TEST_GROUP, TestBlockUnitTests())
    Test.@testset "Unit tests" begin
        if false
        else
            unit_test_interval_string = "[,)"
        end
        @debug(
            "unit_test_interval_string: ",
            unit_test_interval_string,
            )
        if !is_interval(unit_test_interval_string)
            throw(
                ArgumentError(
                    string(
                        "$(unit_test_interval_string) ",
                        "is not a valid interval",
                        )
                    )
                )
        end
        unit_test_interval = construct_interval(
            unit_test_interval_string
            )
        @debug(
            "unit_test_interval: ",
            unit_test_interval,
            )
        testmodulea_filename = joinpath("TestModuleA","TestModuleA.jl",)
        testmoduleb_filename = joinpath(
            "TestModuleB",
            "directory1",
            "directory2",
            "directory3",
            "directory4",
            "directory5",
            "TestModuleB.jl",
            )
        testmodulec_filename = joinpath(
            PredictMD.maketempdir(),
            "TestModuleC.jl",
            )
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
                        file_path = joinpath(root, file)
                        if interval_contains_x(unit_test_interval,
                                               strip(file))
                            Test.@testset "$(file_path)" begin
                                @debug("Running $(file_path)")
                                include(file_path)
                            end
                        end
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
    Test.@testset "Generate examples      " begin
        Test.@test(
            temp_generate_examples_dir == PredictMD.generate_examples(
                temp_generate_examples_dir;
                scripts = true,
                include_test_statements = true,
                markdown = false,
                notebooks = false,
                execute_notebooks = false,
                )
            )
    end
    Test.@testset "Boston housing regression example (CPU)  " begin
        @info("Testing Boston housing regression example (CPU)")
        boston_housing_tests = [
            "01_preprocess_data.jl" => TestBlockIntegration1(),
            "02_linear_regression.jl" => TestBlockIntegration1(),
            "03_random_forest_regression.jl" => TestBlockIntegration2(),
            "04_knet_mlp_regression.jl" => TestBlockIntegration2(),
            "05_compare_models.jl" => TestBlockIntegration3(),
            "06_get_model_output.jl" => TestBlockIntegration3(),
            ]
        for test_pair in boston_housing_tests
            test_file = test_pair[1]
            test_block = test_pair[2]
            if group_includes_block(TEST_GROUP, test_block)
                Test.@testset "cpu_examples/bostonhousing/$(test_file)" begin
                    include(
                        joinpath(
                            temp_generate_examples_dir,
                            "cpu_examples",
                            "boston_housing",
                            test_file,
                            )
                        )
                end
            end
        end
    end
    Test.@testset "Breast cancer biopsy classification (CPU)" begin
        @info("Testing breast cancer biopsy classification example (CPU)")
        breast_cancer_tests = [
            "01_preprocess_data.jl" => TestBlockIntegration4(),
            "02_smote.jl" => TestBlockIntegration4(),
            "03_logistic_classifier.jl" => TestBlockIntegration4(),
            "04_random_forest_classifier.jl" => TestBlockIntegration5(),
            "05_c_svc_svm_classifier.jl" => TestBlockIntegration5(),
            "06_nu_svc_svm_classifier.jl" => TestBlockIntegration5(),
            "07_knet_mlp_classifier.jl" => TestBlockIntegration6(),
            "08_compare_models.jl" => TestBlockIntegration7(),
            "09_get_model_output.jl" => TestBlockIntegration7(),
            ]
        for test_pair in breast_cancer_tests
            test_file = test_pair[1]
            test_block = test_pair[2]
            if group_includes_block(TEST_GROUP, test_block)
                Test.@testset "cpu_examples/breastcancer/$(test_file)" begin
                    include(
                        joinpath(
                            temp_generate_examples_dir,
                            "cpu_examples",
                            "breast_cancer_biopsy",
                            test_file,
                            )
                        )
                end
            end
        end
    end
end
