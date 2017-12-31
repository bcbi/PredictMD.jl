import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import DataFrames
import Knet
import RDatasets
import StatsBase

# Import breast cancer biopsy data
df = RDatasets.dataset("MASS", "biopsy")

# Remove rows with missing data
DataFrames.dropmissing!(df)

# Shuffle the rows
asb.shufflerows!(df)

# Define features and labels
categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
    :V1,
    :V2,
    :V3,
    :V4,
    :V5,
    :V6,
    :V7,
    :V8,
    :V9,
    ]
featurenames = vcat(
    categoricalfeaturenames,
    continuousfeaturenames,
    )
singlelabelname = :Class
singlelabelnegativeclass = "benign"
singlelabelpositiveclass = "malignant"
singlelabellevels = [
    singlelabelnegativeclass,
    singlelabelpositiveclass
    ]
labelnames = [singlelabelname]
labellevels = Dict()
labellevels[singlelabelname] = singlelabellevels

# Examine the counts of each level
StatsBase.countmap(df[singlelabelname])

# Put the features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[labelnames]

# Split the data into training set (70%) and testing set (30%)
trainingfeaturesdf,
    testingfeaturesdf,
    traininglabelsdf,
    testinglabelsdf = asb.train_test_split(
        featuresdf,
        labelsdf;
        training = 0.7,
        testing = 0.3,
        )

# Set up and train a binary logistic classifier
logistic = asb.binarylogisticclassifier(
    featurenames,
    singlelabelname,
    singlelabellevels;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Logistic classifier", # optional
    )
asb.fit!(
    logistic,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# View the coefficients and p values for the logistic classifier
asb.underlying(logistic)
# Evaluate the performance of the logistic classifier on the testing set
asb.binaryclassificationmetrics(
    logistic,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    singlelabelpositiveclass;
    maximize = :f1score,
    )

# Set up and train a random forest
randomforest = asb.randomforestclassifier(
    featurenames,
    singlelabelname,
    singlelabellevels,
    trainingfeaturesdf;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest classifier" # optional
    )
asb.fit!(
    randomforest,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# Evaluate the performance of the random forest on the testing set
asb.binaryclassificationmetrics(
    randomforest,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    singlelabelpositiveclass;
    maximize = :f1score,
    )

# Set up and train an SVM
svm = asb.svmclassifier(
    featurenames,
    singlelabelname,
    singlelabellevels,
    trainingfeaturesdf;
    package = :LIBSVMjl,
    name = "SVM classifier",
    )
asb.fit!(
    svm,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# # Evaluate the performance of the SVM on the testing set
asb.binaryclassificationmetrics(
    svm,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    singlelabelpositiveclass;
    maximize = :f1score,
    )

# Set up and train a multilayer perceptron (i.e. a fully connected feedforward neural network)
function knetmlp_predict(w, x)
    for i = 1:2:(length(w) - 2)
        x = relu.( w[i]*x .+ w[i+1] )
    end
    return w[end-1]*x .+ w[end]
end
function knetmlp_loss(w, x, ygold)
    return Knet.nll(knetmlp_predict(w, x), ygold)
end

knetmlp = asb.knetclassifier(
    featurenames,
    singlelabelname,
    singlelabellevels,
    trainingfeaturesdf;
    name = "Knet MLP with 2 hidden layers",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    maxepochs = 10,
    batchsize  = 256,
    model = Any[
        0.1f0*randn(Float32,64,784), zeros(Float32,64,1),
        0.1f0*randn(Float32,10,64), zeros(Float32,10,1)
        ],
    )
asb.fit!(
    knetmlp,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# Evaluate the performance of the multilayer perceptron on the testing set
asb.binaryclassificationmetrics(
    knetmlp,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass;
    maximize = :f1score,
    )


# Compare the performance of all four models on the testing set
showall(asb.binaryclassificationmetrics(
    [logistic, randomforest, svm, knetmlp],
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass;
    maximize = :f1score,
    ))

# Plot receiver operating characteristic curves for all four models
rocplot = asb.plotroccurves(
    [logistic, randomforest, svm, knetmlp],
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass,
    )
asb.open(rocplot)

# Plot precision-recall curves for all four models
prplot = asb.plotprcurves(
    [logistic, randomforest, svm, knetmlp],
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass,
    )
asb.open(prplot)
