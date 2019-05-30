##### Beginning of file

__precompile__(true)

"""
"""
module PredictMD_Glue_MLJ # begin module PredictMD_Glue_MLJ

import MLJ
import MLJBase
import MLJModels

# import .MLJ
# import .MLJBase
# import .MLJModels

function __init__()::Nothing
    @info("PredictMD: the following backend is now available: MLJ")
    @info("PredictMD: the following backend is now available: MLJBase")
    @info("PredictMD: the following backend is now available: MLJModels")
    return nothing
end

end # end module PredictMD_Glue_MLJ

##### End of file
