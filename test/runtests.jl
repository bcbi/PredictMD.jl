info("Attempting to import Base.Test")
import Base.Test
info("Successfully imported Base.Test")
info("Attempting to import AluthgeSinhaBase")
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
info("Successfully imported AluthgeSinhaBase")

Base.Test.@testset "Test suite" begin
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
            Base.Test.@testset cohenkappa"" begin
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
            include("functional/test_bostonhousing.jl")
        end
        #
        Base.Test.@testset "Breast cancer biopsy classification" begin
            include("functional/test_breastcancerbiopsy.jl")
        end
        #
    end
    #
end
