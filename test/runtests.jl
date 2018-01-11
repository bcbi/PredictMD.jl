info("Attempting to import Base.Test")
import Base.Test
info("Successfully imported Base.Test")
info("Attempting to import AluthgeSinhaBase")
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
info("Successfully imported AluthgeSinhaBase")

Base.Test.@testset "AluthgeSinhaBase test suite" begin
    info("Running AluthgeSinhaBase test suite")
    #
    Base.Test.@testset "Unit tests" begin
        info("Running Unit tests")
        #
        Base.Test.@testset "Testing base/" begin
            info("Testing base/")
            #
            Base.Test.@testset "Testing base/version.jl" begin
                info("Testing base/version.jl")
                include("test_base/test_version.jl")
            end
            #
        end
        #
        Base.Test.@testset "Testing metrics/" begin
            info("Testing metrics/")
            #
            Base.Test.@testset "Testing metrics/coefficientofdetermination.jl" begin
                info("Testing metrics/coefficientofdetermination.jl")
                include("test_metrics/test_coefficientofdetermination.jl")
            end
            #
            Base.Test.@testset "Testing metrics/cohenkappa.jl" begin
                info("Testing metrics/cohenkappa.jl")
                include("test_metrics/test_cohenkappa.jl")
            end
            #
        end
        #
    end
    #
    Base.Test.@testset "Examples" begin
        info("Running examples")
        #
        Base.Test.@testset "Save trained models to file" begin
            info("Running examples and saving trained models to file")
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
            ENV["SAVETRAINEDMODELSTOFILE"] = "true"
            #
            Base.Test.@testset "Running ../examples/bostonhousing.jl" begin
                info("Running ../examples/bostonhousing.jl")
                Base.Test.@test_nowarn(
                    include("../examples/bostonhousing.jl")
                    )
            end
            #
            Base.Test.@testset "Running ../examples/breastcancerbiopsy.jl" begin
                info("Running ../examples/breastcancerbiopsy.jl")
                Base.Test.@test_nowarn(
                    include("../examples/breastcancerbiopsy.jl")
                    )
            end
            #
        end
        #
        Base.Test.@testset "Load trained models from file" begin
            info("Running examples after loading trained models from file")
            #
            ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
            ENV["SAVETRAINEDMODELSTOFILE"] = "false"
            #
            Base.Test.@testset "Running ../examples/bostonhousing.jl" begin
                info("Running ../examples/bostonhousing.jl")
                Base.Test.@test_nowarn(
                    include("../examples/bostonhousing.jl")
                    )
            end
            #
            Base.Test.@testset "Running ../examples/breastcancerbiopsy.jl" begin
                info("Running ../examples/breastcancerbiopsy.jl")
                Base.Test.@test_nowarn(
                    include("../examples/breastcancerbiopsy.jl")
                    )
            end
            #
        end
        #
    end
    #
end
