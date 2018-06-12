"""
"""
module GPU # begin module PredictMD.GPU

##############################################################################
##############################################################################
##############################################################################

# submodules/gpu/clang/
include(joinpath(".", "clang", "clang.jl",))

# submodules/gpu/cuarrays/
include(joinpath(".", "cuarrays", "cuarrays.jl",))

# submodules/gpu/cudaapi/
include(joinpath(".", "cudaapi", "cudaapi.jl",))

# submodules/gpu/cxx/
include(joinpath(".", "cxx", "cxx.jl",))

# submodules/gpu/llvm/
include(joinpath(".", "llvm", "llvm.jl",))


##############################################################################
##############################################################################
##############################################################################

end # end module PredictMD.GPU
