##### Beginning of file

import Compat
import Requires

function __init__()::Void
    info(string("This is PredictMD, version ", version()))
    # @debug(string("PredictMD package directory: \"", pkg_dir(), "\""))
    info(string("For help, please visit https://www.predictmd.net"))
    return nothing
end

##### End of file
