ENV["LOADTRAINEDMODELSFROMFILE"] = "false"
ENV["SAVETRAINEDMODELSTOFILE"] = "true"
include("../examples/bostonhousing.jl")
include("../examples/breastcancerbiopsy.jl")

ENV["LOADTRAINEDMODELSFROMFILE"] = "true"
ENV["SAVETRAINEDMODELSTOFILE"] = "false"
include("../examples/bostonhousing.jl")
include("../examples/breastcancerbiopsy.jl")
