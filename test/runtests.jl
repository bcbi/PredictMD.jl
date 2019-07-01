import Test

ENV["PREDICTMD_IS_RUNTESTS"] = "true"

Test.@testset "PredictMD.jl" begin
    ENV["PREDICTMD_IS_RUNTESTS"] = "true"
    import PredictMDExtra
    PredictMDExtra.import_all()
    include("intervals.jl")
    include("import-predictmd.jl")
    include("define-test-groups.jl")
    include("define-test-blocks.jl")
    include("get-test-group.jl")
    include("set-predictmd-test-plots.jl")
    include("set-predictmd-open-plots-during-tests.jl")
    include("all-testsets.jl")
    ENV["PREDICTMD_IS_RUNTESTS"] = "false"
end

ENV["PREDICTMD_IS_RUNTESTS"] = "false"
