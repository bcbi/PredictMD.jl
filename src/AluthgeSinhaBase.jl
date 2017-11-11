module AluthgeSinhaBase

# abstract types to export:
export AbstractDataset,
    AbstractTabularDataset,
    AbstractHoldoutTabularDataset,
    AbstractKFoldTabularDataset,
    AbstractModel,
    AbstractClassifier,
    AbstractSingleLabelClassifier,
    AbstractSingleLabelBinaryClassifier,
    AbstractRegression,
    AbstractSingleLabelRegression,
    AbstractModelPerformance

# concrete types to export:
export HoldoutTabularDataset,
    ResampledHoldoutTabularDataset,
    SingleLabelBinaryLogisticClassifier,
    ModelPerformance

# functions to export:
export getdata,
    performance,
    numtraining,
    numvalidation,
    numtesting,
    hastraining,
    hasvalidation,
    hastesting

include("abstracttypes.jl")
include("faketabulardata.jl")
include("formulas.jl")
include("labelcoding.jl")
include("linearmodels.jl")
include("modelevaluation.jl")
include("tabulardatasets.jl")
include("util.jl")
include("version.jl")

end # end module AluthgeSinhaBase
