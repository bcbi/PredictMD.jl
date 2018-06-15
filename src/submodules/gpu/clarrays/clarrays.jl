import Requires

"""
"""
has_clarrays() = false

Requires.@require CLArrays begin
    import CLArrays

    import CLBLAS
    import CLFFT
    import OpenCL

    has_clarrays() = true
end
