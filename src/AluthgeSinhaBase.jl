__precompile__(true)

module AluthgeSinhaBase

# load base.jl first:
include("base.jl")

# then load the remaining the source files:
include("calibration.jl")
include("cluster.jl")
include("datasets.jl")
include("decomposition.jl")
include("ensemble.jl")
include("linearmodel.jl")
include("metrics.jl")
include("modelselection.jl")
include("multiclass.jl")
include("multioutput.jl")
include("neuralnetwork.jl")
include("pipeline.jl")
include("plotting.jl")
include("preprocessing.jl")
include("svm.jl")
include("tree.jl")
include("utils.jl")

end # end module AluthgeSinhaBase
