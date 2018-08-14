##### Beginning of file

import Compat
import Requires

function __init__()::Void
    info(string("This is PredictMD, version ", version()))
    # @debug(string("PredictMD debugging messages are enabled"))
    info(string("For help, please visit https://www.predictmd.net"))
    info(string("PredictMD package directory: \"", pkg_dir(), "\""))
    return nothing
end

##### End of file
