"""
"""
module GPU # begin submodule PredictMD.GPU


############################################################################
# PredictMD.GPU.__init__() #################################################
############################################################################

function __init__()
end

############################################################################
# PredictMD.GPU source files ###############################################
############################################################################

# submodules/gpu/clang/
include(joinpath(".", "clang", "clang.jl",))

# submodules/gpu/clarrays/
include(joinpath(".", "clarrays", "clarrays.jl",))

# submodules/gpu/cuarrays/
include(joinpath(".", "cuarrays", "cuarrays.jl",))

# submodules/gpu/cudaapi/
include(joinpath(".", "cudaapi", "cudaapi.jl",))

# submodules/gpu/cxx/
include(joinpath(".", "cxx", "cxx.jl",))

# submodules/gpu/gpuarrays/
include(joinpath(".", "gpuarrays", "gpuarrays.jl",))

# submodules/gpu/llvm/
include(joinpath(".", "llvm", "llvm.jl",))

end # end submodule PredictMD.GPU
