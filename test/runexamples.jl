ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
include("../examples/bostonhousing.jl")
include("../examples/breastcancerbiopsy.jl")

ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
include("../examples/bostonhousing.jl")
include("../examples/breastcancerbiopsy.jl")
