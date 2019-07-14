import InteractiveUtils
import Pkg
import Test

@debug(string("Julia depot paths: "), Base.DEPOT_PATH)
@debug(string("Julia load paths: "), Base.LOAD_PATH)

logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
@debug(string("Julia version info: ",))
if !isnothing(logger)
    InteractiveUtils.versioninfo(logger.stream; verbose=true)
end

@debug(string("Attempting to import PredictMD...",))
import PredictMD
@debug(string("Successfully imported PredictMD.",))
@debug(string("PredictMD version: "),PredictMD.version(),)
@debug(string("PredictMD package directory: "),PredictMD.package_directory(),)

@debug(string("Julia depot paths: "), Base.DEPOT_PATH)
@debug(string("Julia load paths: "), Base.LOAD_PATH)

PredictMD.import_all()
