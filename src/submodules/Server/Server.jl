##### Beginning of file

"""
"""
module Server # begin submodule PredictMD.Server

############################################################################
# PredictMD.Server source files ############################################
############################################################################

# submodules/Server/cryptography/
include(joinpath(".", "cryptography", "gnutls.jl",))
include(joinpath(".", "cryptography", "transportlayersecurity.jl",))

# submodules/Server/web/
include(joinpath(".", "web", "genie.jl",))
include(joinpath(".", "web", "http.jl",))
include(joinpath(".", "web", "httpserver.jl",))
include(joinpath(".", "web", "juliawebapi.jl",))
include(joinpath(".", "web", "mux.jl",))
include(joinpath(".", "web", "websockets.jl",))

# submodules/Server/SUBFOLDER/
include(joinpath(".", "SUBFOLDER", "FILENAME.jl",))

# submodules/Server/SUBFOLDER/
include(joinpath(".", "SUBFOLDER", "FILENAME.jl",))

# submodules/Server/SUBFOLDER/
include(joinpath(".", "SUBFOLDER", "FILENAME.jl",))

end # end submodule PredictMD.Server

##### End of file
