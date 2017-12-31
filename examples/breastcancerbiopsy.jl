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
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)
labelname = :Class
negativeclass = "benign"
positiveclass = "malignant"
labellevels = [negativeclass, positiveclass]

# Examine the counts of each level
StatsBase.countmap(df[labelname])

# Put the features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

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
    labelname,
    labellevels;
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
    labelname,
    positiveclass;
    maximize = :f1score,
    )

# Set up and train a random forest
randomforest = asb.randomforestclassifier(
    featurenames,
    labelname,
    labellevels,
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
    labelname,
    positiveclass;
    maximize = :f1score,
    )

# Set up and train an SVM
svm = asb.svmclassifier(
    featurenames,
    labelname,
    labellevels,
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
    labelname,
    positiveclass;
    maximize = :f1score,
    )

# Set up and train a multilayer perceptron (i.e. a fully connected feedforward neural network)

function knetmlp_predict(w, x)
    for i = 1:2:(length(w) - 2)
        x = Knet.relu.( w[i]*x .+ w[i+1] )
    end
    result = w[end-1]*x .+ w[end]
    return result
end

function knetmlp_loss(w, x, ygold; L1 = 0, L2 = 0)
    loss = Knet.nll(knetmlp_predict(w, x), ygold)
    if L1 !== 0
        loss += L1 * sum(sum(abs, w_i)  for w_i in w[1:2:end])
    end
    if L2 !== 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in w[1:2:end])
    end
    return loss
end

knetmlp = asb.knetclassifier(
    featurenames,
    labelname,
    labellevels,
    trainingfeaturesdf;
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    maxepochs = 1_000,
    batchsize  = 24,
    model = Any[
        0.1f0*randn(Float32,64,9), zeros(Float32,64,1),
        0.1f0*randn(Float32,2,64), zeros(Float32,2,1)
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
    labelname,
    positiveclass;
    maximize = :f1score,
    )

# Compare the performance of all four models on the testing set
showall(asb.binaryclassificationmetrics(
    [logistic, randomforest, svm, knetmlp],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    ))

# Plot receiver operating characteristic curves for all four models
rocplot = asb.plotroccurves(
    [logistic, randomforest, svm, knetmlp],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )
asb.open(rocplot)

# Plot precision-recall curves for all four models
prplot = asb.plotprcurves(
    [logistic, randomforest, svm, knetmlp],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )
asb.open(prplot)
