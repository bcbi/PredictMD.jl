info("Attempting to import Base.Test")
import Base.Test
info("Successfully imported Base.Test")
info("Attempting to import AluthgeSinhaBase")
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
info("Successfully imported AluthgeSinhaBase")

Base.Test.@testset "AluthgeSinhaBase test suite" begin
    #
    Base.Test.@testset "Unit tests" begin
        #
        info("Running unit tests")
        #
        Base.Test.@testset "base" begin
            #
            Base.Test.@testset "version" begin
                include("unit/base/test_version.jl")
            end
            #
        end
        #
        Base.Test.@testset "metrics" begin
            #
            Base.Test.@testset "coefficientofdetermination" begin
                include("unit/metrics/test_coefficientofdetermination.jl")
            end
            #
            Base.Test.@testset "cohenkappa" begin
                include("unit/metrics/test_cohenkappa.jl")
            end
            #
        end
        #
    end
    #
    Base.Test.@testset "Functional tests" begin
        #
        info("Running functional tests")
        #
        Base.Test.@testset "Boston housing regression" begin
            #
            ENV["linearreg_filename"] =
                string(tempname(), "_linearreg.jld2")
            ENV["randomforestreg_filename"] =
                string(tempname(), "_randomforestreg.jld2")
            ENV["epsilonsvr_svmreg_filename"] =
                string(tempname(), "_epsilonsvr_svmreg.jld2")
            ENV["nusvr_svmreg_filename"] =
                string(tempname(), "_nusvr_svmreg.jld2")
            ENV["knetmlpreg_filename"] =
                string(tempname(), "_knetmlpreg.jld2")
            #
            Base.Test.@test(!isfile(ENV["linearreg_filename"]))
            Base.Test.@test(!isfile(ENV["randomforestreg_filename"]))
            Base.Test.@test(!isfile(ENV["epsilonsvr_svmreg_filename"]))
            Base.Test.@test(!isfile(ENV["nusvr_svmreg_filename"]))
            Base.Test.@test(!isfile(ENV["knetmlpreg_filename"]))
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            include("functional/test_bostonhousing.jl")
            #
            Base.Test.@test(isfile(ENV["linearreg_filename"]))
            Base.Test.@test(isfile(ENV["randomforestreg_filename"]))
            Base.Test.@test(isfile(ENV["epsilonsvr_svmreg_filename"]))
            Base.Test.@test(isfile(ENV["nusvr_svmreg_filename"]))
            Base.Test.@test(isfile(ENV["knetmlpreg_filename"]))
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
            ENV["SAVETRAINEDMODELSTOFILE"] = "false"
            include("functional/test_bostonhousing.jl")
            #
        end
        #
        Base.Test.@testset "Breast cancer biopsy classification" begin
            #
            ENV["logisticclassifier_filename"] =
                string(tempname(), "_logisticclassifier.jld2")
            ENV["probitclassifier_filename"] =
                string(tempname(), "_probitclassifier.jld2")
            ENV["rfclassifier_filename"] =
                string(tempname(), "_rfclassifier.jld2")
            ENV["csvc_svmclassifier_filename"] =
                string(tempname(), "_csvc_svmclassifier.jld2")
            ENV["nusvc_svmclassifier_filename"] =
                string(tempname(), "_nusvc_svmclassifier.jld2")
            ENV["knetmlp_filename"] =
                string(tempname(), "_knetmlpclassifier.jld2")
                # joinpath(tempdir(), "")
            #
            Base.Test.@test(!isfile(ENV["logisticclassifier_filename"]))
            Base.Test.@test(!isfile(ENV["probitclassifier_filename"]))
            Base.Test.@test(!isfile(ENV["rfclassifier_filename"]))
            Base.Test.@test(!isfile(ENV["csvc_svmclassifier_filename"]))
            Base.Test.@test(!isfile(ENV["nusvc_svmclassifier_filename"]))
            Base.Test.@test(!isfile(ENV["knetmlp_filename"]))
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            include("functional/test_breastcancerbiopsy.jl")
            #
            Base.Test.@test(isfile(ENV["logisticclassifier_filename"]))
            Base.Test.@test(isfile(ENV["probitclassifier_filename"]))
            Base.Test.@test(isfile(ENV["rfclassifier_filename"]))
            Base.Test.@test(isfile(ENV["csvc_svmclassifier_filename"]))
            Base.Test.@test(isfile(ENV["nusvc_svmclassifier_filename"]))
            Base.Test.@test(isfile(ENV["knetmlp_filename"]))
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
            ENV["SAVETRAINEDMODELSTOFILE"] = "false"
            include("functional/test_breastcancerbiopsy.jl")
            #
        end
        #
    end
    #
end
