info("Attempting to import Base.Test")
import Base.Test
info("Successfully imported Base.Test")
info("Attempting to import AluthgeSinhaBase")
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
info("Successfully imported AluthgeSinhaBase")

Base.Test.@testset "AluthgeSinhaBase test suite" begin
    Base.Test.@testset "Unit tests" begin
        info("Running unit tests")
        Base.Test.@testset "base" begin
            include("unit/base/test_version.jl")
        end
        Base.Test.@testset "metrics" begin
            include("unit/metrics/test_coefficientofdetermination.jl")
            include("unit/metrics/test_cohenkappa.jl")
        end
    end
    Base.Test.@testset "Functional tests" begin
        info("Running functional tests")
        Base.Test.@testset "Boston housing regression" begin
            include("functional/bostonhousing/setup_bostonhousing.jl")
        end
        Base.Test.@testset "Breast cancer biopsy classification" begin
            include("functional/breastcancerbiopsy/setup_breastcancerbiopsy.jl")
        end
    end
end
