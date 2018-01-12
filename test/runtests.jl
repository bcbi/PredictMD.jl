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
                joinpath(tempdir(), "linearreg.jld2")
            ENV["randomforestreg_filename"] =
                joinpath(tempdir(), "randomforestreg.jld2")
            ENV["epsilonsvr_svmreg_filename"] =
                joinpath(tempdir(), "epsilonsvr_svmreg.jld2")
            ENV["nusvr_svmreg_filename"] =
                joinpath(tempdir(), "nusvr_svmreg.jld2")
            ENV["knetmlpreg_filename"] =
                joinpath(tempdir(), "knetmlpreg.jld2")
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            include("functional/test_bostonhousing.jl")
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
                joinpath(tempdir(), "logisticclassifier.jld2")
            ENV["probitclassifier_filename"] =
                joinpath(tempdir(), "probitclassifier.jld2")
            ENV["rfclassifier_filename"] =
                joinpath(tempdir(), "rfclassifier.jld2")
            ENV["csvc_svmclassifier_filename"] =
                joinpath(tempdir(), "csvc_svmclassifier.jld2")
            ENV["nusvc_svmclassifier_filename"] =
                joinpath(tempdir(), "nusvc_svmclassifier.jld2")
            ENV["knetmlp_filename"] =
                joinpath(tempdir(), "knetmlpclassifier.jld2")
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            include("functional/test_breastcancerbiopsy.jl")
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
