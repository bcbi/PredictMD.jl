##### Beginning of file

import Compat

Compat.@info(string("Julia package directory: \"", Pkg.dir(), "\"",))

const julia_cache_paths = string(
    "[\"",
    join(Base.LOAD_CACHE_PATH,"\", \""),
    "\"]",
    )

Compat.@info(string("Julia cache path(s): ", julia_cache_paths, ".", ))

Compat.@info(string("Printing Julia version info:",))

versionCompat.@info(true)

Compat.@info(string("Attempting to import PredictMD...",))

import PredictMD

Compat.@info(string("Successfully imported PredictMD.",))

Compat.@info(string("PredictMD version: ",PredictMD.version(),))

Compat.@info(
    string(
        "PredictMD package directory: \"",
        PredictMD.pkg_dir(),
        "\"",
        )
    )

##### End of file
