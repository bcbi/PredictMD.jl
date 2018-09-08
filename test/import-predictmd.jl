##### Beginning of file

@info(string("Julia package directory: \"", Pkg.dir(), "\"",))

const julia_cache_paths = string(
    "[\"",
    join(Base.LOAD_CACHE_PATH,"\", \""),
    "\"]",
    )

@info(string("Julia cache path(s): ", julia_cache_paths, ".", ))

@info(string("Printing Julia version info:",))

versioninfo(true)

@info(string("Attempting to import PredictMD...",))

import PredictMD

@info(string("Successfully imported PredictMD.",))

@info(string("PredictMD version: ",PredictMD.version(),))

@info(
    string(
        "PredictMD package directory: \"",
        PredictMD.pkg_dir(),
        "\"",
        )
    )

##### End of file
