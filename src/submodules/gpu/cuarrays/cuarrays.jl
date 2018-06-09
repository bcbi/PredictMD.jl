import Requires

"""
"""
has_cuarrays() = false

Requires.@require CuArrays begin
    import CuArrays

    import CUDAapi
    import CUDAdrv
    import CUDAnative
    import NNlib
    import GPUArrays

    has_cuarrays() = true
end
