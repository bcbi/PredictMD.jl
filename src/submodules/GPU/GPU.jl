"""
"""
module GPU # begin submodule PredictMD.GPU

############################################################################
# PredictMD.GPU source files ###############################################
############################################################################

# submodules/GPU/clang/
include(joinpath(".", "clang", "clang.jl",))

# submodules/GPU/clarrays/
include(joinpath(".", "clarrays", "clarrays.jl",))

# submodules/GPU/cuarrays/
include(joinpath(".", "cuarrays", "cuarrays.jl",))

# submodules/GPU/cudaapi/
include(joinpath(".", "cudaapi", "cudaapi.jl",))

# submodules/GPU/cxx/
include(joinpath(".", "cxx", "cxx.jl",))

# submodules/GPU/gpuarrays/
include(joinpath(".", "gpuarrays", "gpuarrays.jl",))

# submodules/GPU/llvm/
include(joinpath(".", "llvm", "llvm.jl",))

end # end submodule PredictMD.GPU
