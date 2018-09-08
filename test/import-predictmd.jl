##### Beginning of file

@info(string("Julia depot paths: "), Base.DEPOT_PATH)

@info(string("Printing Julia version info:",))
import InteractiveUtils
InteractiveUtils.versioninfo(verbose=true)

@info(string("Packages in the project (explicitly added): ",))
import Pkg
Pkg.status(Pkg.PKGMODE_PROJECT)

@info(string("Packages in the manifest (recursive dependencies): ",))
Pkg.status(Pkg.PKGMODE_MANIFEST)

@info(string("Attempting to import PredictMD...",))
import PredictMD
@info(string("Successfully imported PredictMD.",))
@info(string("PredictMD version: "),PredictMD.version(),)
@info(string("PredictMD package directory: "),PredictMD.package_directory(),)

##### End of file
