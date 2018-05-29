import Requires

"""
"""
has_cudnn() = false

Requires.@require CUDNN begin
    import CUDNN

    import CUDAapi
    import CUDAdrv
    import CUDAnative
    import CuArrays
    import GPUArrays
    import NNlib

    has_cudnn() = true
end
