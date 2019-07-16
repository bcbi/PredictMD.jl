import InteractiveUtils # stdlib
import Pkg # stdlib
import Test # stdlib

import Random
Random.seed!(999)

@debug(string("Julia depot paths: "), Base.DEPOT_PATH)
@debug(string("Julia load paths: "), Base.LOAD_PATH)

logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if !isnothing(logger)
    @debug(string("Julia version info: ",))
    InteractiveUtils.versioninfo(logger.stream; verbose=true)
end

@debug(string("Attempting to import PredictMD...",))
import PredictMD
@debug(string("Successfully imported PredictMD.",))
@debug(string("PredictMD version: "),PredictMD.version(),)
@debug(
    string("PredictMD package directory: "),
    PredictMD.package_directory(),
    )

@debug(string("Attempting to import PredictMDExtra...",))
import PredictMDExtra
@debug(string("Successfully imported PredictMDExtra.",))
@debug(string("PredictMDExtra version: "),PredictMDExtra.version(),)
@debug(
    string("PredictMDExtra package directory: "),
    PredictMDExtra.package_directory(),
    )

@debug(string("Julia depot paths: "), Base.DEPOT_PATH)
@debug(string("Julia load paths: "), Base.LOAD_PATH)

logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if !isnothing(logger)
    if ispath(Base.active_project())
        println(logger.stream, "# Location of test environment Project.toml: \"$(Base.active_project())\"")
        println(logger.stream, "# Beginning of test environment Project.toml")
        println(logger.stream, read(Base.active_project(), String))
        println(logger.stream, "# End of test environment Project.toml")
    else
        println(logger.stream, "# File \"$(Base.active_project())\" does not exist")
    end
    if ispath(joinpath(dirname(Base.active_project()), "Manifest.toml"))
        println(logger.stream, "# Location of test environment Manifest.toml: \"$(joinpath(dirname(Base.active_project()), "Manifest.toml"))\"")
        println(logger.stream, "# Beginning of test environment Manifest.toml")
        println(logger.stream, read(joinpath(dirname(Base.active_project()), "Manifest.toml"),String))
        println(logger.stream, "# End of test environment Manifest.toml")
    else
        println(logger.stream, "# File \"$(joinpath(dirname(Base.active_project()), "Manifest.toml"))\" does not exist")
    end
end

logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if !isnothing(logger)
    if ispath(PredictMD.package_directory("Project.toml"))
        println(logger.stream, "# Location of PredictMD package Project.toml: \"$(PredictMD.package_directory("Project.toml"))\"")
        println(logger.stream, "# Beginning of PredictMD package Project.toml")
        println(logger.stream, read(PredictMD.package_directory("Project.toml"), String))
        println(logger.stream, "# End of PredictMD package Project.toml")
    else
        println(logger.stream, "# File \"$(PredictMD.package_directory("Project.toml"))\" does not exist")
    end
    if ispath(PredictMD.package_directory("Manifest.toml"))
        println(logger.stream, "# Location of PredictMD package Manifest.toml: \"$(PredictMD.package_directory("Manifest.toml"))\"")
        println(logger.stream, "# Beginning of PredictMD package Manifest.toml")
        println(logger.stream, read(PredictMD.package_directory("Manifest.toml"),String))
        println(logger.stream, "# End of PredictMD package Manifest.toml")
    else
        println(logger.stream, "# File \"$(PredictMD.package_directory("Manifest.toml"))\" does not exist")
    end
end

logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if !isnothing(logger)
    if ispath(joinpath(dirname(pathof(PredictMDAPI)), "..", "Project.toml"))
        println(logger.stream, "# Location of PredictMDAPI package Project.toml: \"$(joinpath(dirname(pathof(PredictMDAPI)), "..", "Project.toml"))\"")
        println(logger.stream, "# Beginning of PredictMDAPI package Project.toml")
        println(logger.stream, read(joinpath(dirname(pathof(PredictMDAPI)), "..", "Project.toml"), String))
        println(logger.stream, "# End of PredictMDAPI package Project.toml")
    else
        println(logger.stream, "# File \"$(joinpath(dirname(pathof(PredictMDAPI)), "..", "Project.toml"))\" does not exist")
    end
    if ispath(joinpath(dirname(pathof(PredictMDAPI)), "..", "Manifest.toml"))
        println(logger.stream, "# Location of PredictMDAPI package Manifest.toml: \"$(joinpath(dirname(pathof(PredictMDAPI)), "..", "Manifest.toml"))\"")
        println(logger.stream, "# Beginning of PredictMDAPI package Manifest.toml")
        println(logger.stream, read(joinpath(dirname(pathof(PredictMDAPI)), "..", "Manifest.toml"),String))
        println(logger.stream, "# End of PredictMDAPI package Manifest.toml")
    else
        println(logger.stream, "# File \"$(joinpath(dirname(pathof(PredictMDAPI)), "..", "Manifest.toml"))\" does not exist")
    end
end

logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if !isnothing(logger)
    if ispath(PredictMDExtra.package_directory("Project.toml"))
        println(logger.stream, "# Location of PredictMDExtra package Project.toml: \"$(PredictMDExtra.package_directory("Project.toml"))\"")
        println(logger.stream, "# Beginning of PredictMDExtra package Project.toml")
        println(logger.stream, read(PredictMDExtra.package_directory("Project.toml"), String))
        println(logger.stream, "# End of PredictMDExtra package Project.toml")
    else
        println(logger.stream, "# File \"$(PredictMDExtra.package_directory("Project.toml"))\" does not exist")
    end
    if ispath(PredictMDExtra.package_directory("Manifest.toml"))
        println(logger.stream, "# Location of PredictMDExtra package Manifest.toml: \"$(PredictMDExtra.package_directory("Manifest.toml"))\"")
        println(logger.stream, "# Beginning of PredictMDExtra package Manifest.toml")
        println(logger.stream, read(PredictMDExtra.package_directory("Manifest.toml"),String))
        println(logger.stream, "# End of PredictMDExtra package Manifest.toml")
    else
        println(logger.stream, "# File \"$(PredictMDExtra.package_directory("Manifest.toml"))\" does not exist")
    end
end

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
        include("unit-tests-type-definitions.jl")
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
        @debug("Testing Boston housing regression example (CPU)")
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
                Test.@testset "cpu_examples/bostonhousing/src/$(test_file)" begin
                    include(
                        joinpath(
                            temp_generate_examples_dir,
                            "cpu_examples",
                            "boston_housing",
                            "src",
                            test_file,
                            )
                        )
                end
            end
        end
    end
    Test.@testset "Breast cancer biopsy classification (CPU)" begin
        @debug("Testing breast cancer biopsy classification example (CPU)")
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
                Test.@testset "cpu_examples/breastcancer/src/$(test_file)" begin
                    include(
                        joinpath(
                            temp_generate_examples_dir,
                            "cpu_examples",
                            "breast_cancer_biopsy",
                            "src",
                            test_file,
                            )
                        )
                end
            end
        end
    end
end
