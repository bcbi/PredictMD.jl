import Base.Test

info("Printing Julia version info:")
versioninfo(true)

info("Attempting to import PredictMD")
import PredictMD
info("Successfully imported PredictMD")
info("Printing PredictMD version info:")
println(string("PredictMD Version ", PredictMD.VERSION))

ENV["PREDICTMD_RUNTESTS"] = "true"

Base.Test.@testset "PredictMD test suite" begin
    Base.Test.@testset "Unit tests (CPU)" begin
        info("Running unit tests (CPU)")
        Base.Test.@testset "base" begin
            include("cpu/unit/base/test_version.jl")
        end
        Base.Test.@testset "metrics" begin
            include("cpu/unit/metrics/test_coefficientofdetermination.jl")
            include("cpu/unit/metrics/test_cohenkappa.jl")
        end
        Base.Test.@testset "utils" begin
            include("cpu/unit/utils/test_fix_dict_type.jl")
            include("cpu/unit/utils/test_fix_vector_type.jl")
        end
    end
    Base.Test.@testset "Functional tests (CPU)" begin
        info("Running functional tests (CPU)")
        Base.Test.@testset "Boston housing regression" begin
            include("cpu/functional/bostonhousing/setup_bostonhousing.jl")
        end
        Base.Test.@testset "Breast cancer biopsy classification" begin
            include("cpu/functional/breastcancerbiopsy/setup_breastcancerbiopsy.jl")
        end
    end
end
