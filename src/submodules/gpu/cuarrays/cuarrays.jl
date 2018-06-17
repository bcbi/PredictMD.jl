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

    info(
        string(
            "PredictMD detected that CuArrays has been imported. ",
            "Thus, CuArrays functionality is now available in PredictMD.",
            )
        )
end
