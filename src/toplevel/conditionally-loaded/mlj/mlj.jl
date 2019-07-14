module PredictMD_MLJ

import .MLJ
import .MLJBase
import .MLJModels

function __init__()
    @info("PredictMD: the following backends are now available: MLJ, MLJBase, MLJModels")
end

end # end module PredictMD_MLJ
