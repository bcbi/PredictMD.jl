__precompile__(false)

module AluthgeSinhaBase

# abstract types to export:
export AbstractModelly

# abstract type aliases to export:

# abstract parametric types to export:
export AbstractDataset,
    AbstractTabularDataset,
    AbstractHoldoutTabularDataset,
    AbstractKFoldTabularDataset,
    AbstractSingleModel,
    AbstractClassifier,
    AbstractSingleLabelClassifier,
    AbstractSingleLabelBinaryClassifier,
    AbstractRegression,
    AbstractSingleLabelRegression,
    AbstractModelPerformance

# abstract parametric type aliases to export:
export ArrayOfModels,
    VectorOfModels,
    MatrixOfModels,
    AbstractBinaryClassifier

# concrete types to export:
export HoldoutTabularDataset,
    ResampledHoldoutTabularDataset,
    SingleLabelBinaryLogisticClassifier,
    SingleLabelBinaryRandomForestClassifier,
    SingleLabelBinarySupportVectorMachineClassifier

# concrete type aliases to export:

# concrete parametric types to export:
export ModelPerformance

# concrete parametric type aliases to export:
export BinaryLogistic,
    BinaryRandomForest,
    SingleLabelBinarySVMClassifier,
    BinarySupportVectorMachine,
    BinarySVM

# functions to export:
export getdata,
    numtraining,
    numvalidation,
    numtesting,
    hastraining,
    hasvalidation,
    hastesting,
    plots,
    classifierhistograms

# source files to include:
include("abstracttypes.jl")
include("auc.jl")
include("convenience.jl")
include("ensembles.jl")
include("faketabulardata.jl")
include("formulas.jl")
include("labelcoding.jl")
include("linearmodels.jl")
include("loss.jl")
include("metrics.jl")
include("modelevaluation.jl")
include("randomforest.jl")
include("smote.jl")
include("svm.jl")
include("tabulardatasets.jl")
include("util.jl")
include("version.jl")

end # end module AluthgeSinhaBase
