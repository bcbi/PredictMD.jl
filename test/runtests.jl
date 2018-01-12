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
        Base.Test.@testset "Boston housing regression" begin
            linearreg_filename = joinpath(tempdir(), "linearreg.jld2")
            randomforestreg_filename = joinpath(tempdir(), "randomforestreg.jld2")
            epsilonsvr_svmreg_filename = joinpath(tempdir(), "epsilonsvr_svmreg.jld2")
            nusvr_svmreg_filename = joinpath(tempdir(), "nusvr_svmreg.jld2")
            knetmlpreg_filename = joinpath(tempdir(), "knetmlpreg.jld2")
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            include("functional/test_bostonhousing.jl")
            ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
            ENV["SAVETRAINEDMODELSTOFILE"] = "false"
            include("functional/test_bostonhousing.jl")
        end
        #
        Base.Test.@testset "Breast cancer biopsy classification" begin
            logisticclassifier_filename = joinpath(tempdir(), "logisticclassifier.jld2")
            probitclassifier_filename = joinpath(tempdir(), "probitclassifier.jld2")
            rfclassifier_filename = joinpath(tempdir(), "rfclassifier.jld2")
            csvc_svmclassifier_filename = joinpath(tempdir(), "csvc_svmclassifier.jld2")
            nusvc_svmclassifier_filename = joinpath(tempdir(), "nusvc_svmclassifier.jld2")
            knetmlp_filename = joinpath(tempdir(), "knetmlpclassifier.jld2")
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            include("functional/test_breastcancerbiopsy.jl")
            ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
            ENV["SAVETRAINEDMODELSTOFILE"] = "false"
            include("functional/test_breastcancerbiopsy.jl")
        end
        #
    end
    #
end
