import InteractiveUtils
import Pkg
import Test

@info(string("Julia depot paths: "), Base.DEPOT_PATH)
@info(string("Julia load paths: "), Base.LOAD_PATH)

@info(string("Julia version info: ",))
InteractiveUtils.versioninfo(verbose=true)

@info(string("Output of Pkg.status():",),)
Pkg.status()

@info(string("Output of Pkg.status(Pkg.Types.PKGMODE_PROJECT):",),)
Pkg.status(Pkg.Types.PKGMODE_PROJECT)

@info(string("Output of Pkg.status(Pkg.Types.PKGMODE_MANIFEST):",),)
Pkg.status(Pkg.Types.PKGMODE_MANIFEST)

@info(string("Output of Pkg.status(Pkg.Types.PKGMODE_COMBINED):",),)
Pkg.status(Pkg.Types.PKGMODE_COMBINED)

@info(string("Attempting to import PredictMD...",))
import PredictMD
@info(string("Successfully imported PredictMD.",))
@info(string("PredictMD version: "),PredictMD.version(),)
@info(string("PredictMD package directory: "),PredictMD.package_directory(),)

@info(string("Julia depot paths: "), Base.DEPOT_PATH)
@info(string("Julia load paths: "), Base.LOAD_PATH)

PredictMD.import_all()
