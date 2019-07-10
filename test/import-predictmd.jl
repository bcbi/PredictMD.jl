import InteractiveUtils
import Pkg
import Test

@debug(string("Julia depot paths: "), Base.DEPOT_PATH)
@debug(string("Julia load paths: "), Base.LOAD_PATH)

@debug(string("Julia version info: ",))
logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if !isnothing(logger)
    InteractiveUtils.versioninfo(logger.stream; verbose=true)
end

@debug(string("Output of Pkg.status():",),)
Pkg.status()

@debug(string("Output of Pkg.status(Pkg.Types.PKGMODE_PROJECT):",),)
Pkg.status(Pkg.Types.PKGMODE_PROJECT)

@debug(string("Output of Pkg.status(Pkg.Types.PKGMODE_MANIFEST):",),)
Pkg.status(Pkg.Types.PKGMODE_MANIFEST)

@debug(string("Output of Pkg.status(Pkg.Types.PKGMODE_COMBINED):",),)
Pkg.status(Pkg.Types.PKGMODE_COMBINED)

@debug(string("Attempting to import PredictMD...",))
import PredictMD
@debug(string("Successfully imported PredictMD.",))
@debug(string("PredictMD version: "),PredictMD.version(),)
@debug(string("PredictMD package directory: "),PredictMD.package_directory(),)

@debug(string("Julia depot paths: "), Base.DEPOT_PATH)
@debug(string("Julia load paths: "), Base.LOAD_PATH)

PredictMD.import_all()
