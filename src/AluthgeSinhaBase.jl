__precompile__(false)

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
    AbstractSingleLabelRegression

# abstract type aliases to export:
export AbstractBinaryClassifier

# concrete types to export:
export HoldoutTabularDataset,
    ResampledHoldoutTabularDataset,
    SingleLabelBinaryLogisticClassifier,
    SingleLabelBinaryRandomForestClassifier,
    SingleLabelBinarySupportVectorMachineClassifier

# concrete type aliases to export:
export BinaryLogistic,
    BinaryRandomForest,
    SingleLabelBinarySVMClassifier,
    BinarySupportVectorMachine,
    BinarySVM

# functions to export:
export getdata,
    performance,
    numtraining,
    numvalidation,
    numtesting,
    hastraining,
    hasvalidation,
    hastesting,
    roctraining,
    rocvalidation,
    roctesting,
    precisionrecalltraining,
    precisionrecallvalidation,
    precisionrecalltesting

include("abstracttypes.jl")
include("faketabulardata.jl")
include("formulas.jl")
include("labelcoding.jl")
include("linearmodels.jl")
include("modelevaluation.jl")
include("randomforest.jl")
include("svm.jl")
include("tabulardatasets.jl")
include("util.jl")
include("version.jl")

end # end module AluthgeSinhaBase
