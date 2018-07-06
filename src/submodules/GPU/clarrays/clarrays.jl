##### Beginning of file

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

    info(
        string(
            "PredictMD detected that CLArrays has been imported. ",
            "Thus, CLArrays functionality is now available in PredictMD.",
            )
        )
end

##### End of file
