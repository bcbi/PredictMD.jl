import PredictMD
import PredictMD.GPU

Base.Test.@test(
    PredictMD.GPU.has_clang() || !PredictMD.GPU.has_clang()
    )
Base.Test.@test(
    PredictMD.GPU.has_clarrays() || !PredictMD.GPU.has_clarrays()
    )
Base.Test.@test(
    PredictMD.GPU.has_cuarrays() || !PredictMD.GPU.has_cuarrays()
    )
Base.Test.@test(
    PredictMD.GPU.has_cxx() || !PredictMD.GPU.has_cxx()
    )
Base.Test.@test(
    PredictMD.GPU.has_llvm() || !PredictMD.GPU.has_llvm()
    )
