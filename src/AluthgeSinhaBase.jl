__precompile__(true)

module AluthgeSinhaBase

# base/
include("base/abstracttypes.jl")
include("base/typealiases.jl")
include("base/version.jl")

# calibration/

# classimbalance/
include("classimbalance/smote.jl")

# cluster/

# datasets/
include("datasets/csv.jl")
include("datasets/gzip.jl")
include("datasets/rdatasets.jl")

# decomposition/

# ensemble/

# io/
include("io/fileio.jl")
include("io/jld2.jl")
include("io/saveload.jl")

# linearmodel/
include("linearmodel/glm.jl")

# metrics/
include("metrics/auprc.jl")
include("metrics/aurocc.jl")
include("metrics/averageprecisionscore.jl")
include("metrics/singlelabelbinaryclassificationmetrics.jl")
include("metrics/singlelabelregressionmetrics.jl")
include("metrics/coefficientofdetermination.jl")
include("metrics/cohenkappa.jl")
include("metrics/getbinarythresholds.jl")
include("metrics/prcurve.jl")
include("metrics/roccurve.jl")
include("metrics/rocnumsmetrics.jl")

# modelselection/
include("modelselection/traintestsplit.jl")

# multiclass/

# multioutput/

# neuralnetwork/
include("neuralnetwork/knet.jl")

# pipeline/
include("pipeline/simplelinearpipeline.jl")

# plotting/
include("plotting/plotlearningcurve.jl")
include("plotting/plotprcurve.jl")
include("plotting/plotroccurve.jl")

# postprocessing/
include("postprocessing/packagemultilabelpred.jl")
include("postprocessing/packagesinglelabelpred.jl")
include("postprocessing/packagesinglelabelproba.jl")
include("postprocessing/predictoutput.jl")
include("postprocessing/predictprobaoutput.jl")

# preprocessing/
include("preprocessing/dataframecontrasts.jl")
include("preprocessing/dataframetodecisiontree.jl")
include("preprocessing/dataframetoglm.jl")
include("preprocessing/dataframetoknet.jl")
include("preprocessing/dataframetosvm.jl")

# scikitlearn/
include("scikitlearn/scikitlearnapi.jl")

# svm/
include("svm/libsvm.jl")

# tree/
include("tree/decisiontree.jl")

# utils/
include("utils/formulas.jl")
include("utils/labelstringintmaps.jl")
include("utils/nothings.jl")
include("utils/openbrowserwindow.jl")
include("utils/predictionsassoctodataframe.jl")
include("utils/probabilitiestopredictions.jl")
include("utils/shufflerows.jl")
include("utils/simplemovingaverage.jl")
include("utils/tikzpictures.jl")
include("utils/trapz.jl")
include("utils/travisci.jl")


end # end module AluthgeSinhaBase
