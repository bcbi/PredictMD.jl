import Base.Test

info("INFO Printing Julia version info:")
versioninfo(true)

info("INFO Attempting to import PredictMD")
import PredictMD
info("INFO Successfully imported PredictMD")
info("INFO Printing PredictMD version info:")
println(string("PredictMD Version ", PredictMD.VERSION))

ENV["PREDICTMD_RUNTESTS"] = "true"

Base.Test.@testset "PredictMD test suite" begin
    #
    Base.Test.@testset "Unit tests (CPU)" begin
        info("INFO Running unit tests (CPU)")
        #
        Base.Test.@testset "base" begin
            include("cpu/unit/base/test_version.jl")
        end
        #
        Base.Test.@testset "metrics" begin
            include("cpu/unit/metrics/test_coefficientofdetermination.jl")
            include("cpu/unit/metrics/test_cohenkappa.jl")
        end
        #
        Base.Test.@testset "utils" begin
            include("cpu/unit/utils/test_fix_dict_type.jl")
            include("cpu/unit/utils/test_fix_vector_type.jl")
        end
    end
    #
    Base.Test.@testset "Test examples (CPU)" begin
        info("INFO testing examples (CPU)")
        #
        Base.Test.@testset "Boston housing regression" begin
            include("")
        end
        #
        Base.Test.@testset "Breast cancer biopsy classification" begin
            include("")
        end
    end
end
