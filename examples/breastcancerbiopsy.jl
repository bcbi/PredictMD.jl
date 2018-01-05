import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import DataFrames
import Knet
import LIBSVM
import RDatasets
import StatsBase

# Import breast cancer biopsy data
df = RDatasets.dataset("MASS", "biopsy")

# Remove rows with missing data
DataFrames.dropmissing!(df)

# Shuffle the rows
asb.shufflerows!(df)

# Define features
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
featurecontrasts = asb.featurecontrasts(df, featurenames)

# Define labels
labelname = :Class
negativeclass = "benign"
positiveclass = "malignant"
labellevels = [negativeclass, positiveclass]

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

##############################################################################

# Examine the prevalence of each class in the training set
StatsBase.countmap(traininglabelsdf[labelname])

# We see that malignant is the minority class and benign is the majority class.
# The ratio of malignant:benign is somewhere between 1:2.5 and 1:3 (depending
# on the random seed). We would like that ratio to be 1:1. We will use SMOTE
# to generate synthetic minority class samples. We will also undersample the
# minority class. The result will be a balanced training set.
majorityclass = "benign"
minorityclass = "malignant"

smotedtrainingfeaturesdf, smotedtraininglabelsdf = asb.smote(
    trainingfeaturesdf,
    traininglabelsdf,
    featurenames,
    labelname;
    majorityclass = majorityclass,
    minorityclass = minorityclass,
    pct_over = 100,
    minority_to_majority_ratio = 1.0,
    k = 5,
    )

# Examine the prevalence of each class in the smoted training set
StatsBase.countmap(smotedtraininglabelsdf[labelname])

# Now we have a ratio of malignant:benign that is 1:1.

##############################################################################

# Set up and train a binary logistic classifier
logistic = asb.binarylogisticclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Logistic", # optional
    )
asb.fit!(
    logistic,
    smotedtrainingfeaturesdf, smotedtraininglabelsdf,
    )
# View the coefficients, p values, etc. for the underlying logistic regression
asb.underlying(logistic)
# Evaluate the performance of the logistic classifier on the testing set
asb.binaryclassificationmetrics(
    logistic,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )
asb.binaryclassificationmetrics(
    logistic,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    )
asb.binaryclassificationmetrics(
    logistic,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    )

##############################################################################

# Set up and train a binary probit classifier
probit = asb.binaryprobitclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Probit", # optional
    )
asb.fit!(
    probit,
    smotedtrainingfeaturesdf, smotedtraininglabelsdf,
    )
# View the coefficients, p values, etc. for the underlying probit regression
asb.underlying(probit)
# Evaluate the performance of the logistic classifier on the testing set
asb.binaryclassificationmetrics(
    probit,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )
asb.binaryclassificationmetrics(
    probit,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    )
asb.binaryclassificationmetrics(
    probit,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    )

##############################################################################

# Set up and train a random forest
randomforest = asb.randomforestclassifier(
    featurenames,
    labelname,
    labellevels,
    featurecontrasts;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )
asb.fit!(
    randomforest,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
# Evaluate the performance of the random forest on the testing set
asb.binaryclassificationmetrics(
    randomforest,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )
asb.binaryclassificationmetrics(
    randomforest,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    )
asb.binaryclassificationmetrics(
    randomforest,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    )

##############################################################################

# Set up and train an SVM
svm = asb.svmclassifier(
    featurenames,
    labelname,
    labellevels,
    featurecontrasts; package = :LIBSVMjl,
    svmtype = LIBSVM.SVC,
    name = "SVM",
    verbose = true,
    )
asb.fit!(
    svm,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
# Evaluate the performance of the SVM on the testing set
asb.binaryclassificationmetrics(
    svm,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )
asb.binaryclassificationmetrics(
    svm,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    )
asb.binaryclassificationmetrics(
    svm,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    )

##############################################################################

# Set up and train a multilayer perceptron (i.e. fully connected feedforward
# neural network)

function knetmlp_predict(
        w, # don't put a type annotation on this
        x0::AbstractArray;
        training::Bool = false,
        )
    x1 = Knet.relu.( w[1]*x0 .+ w[2] )
    x2 = Knet.relu.( w[3]*x1 .+ w[4] )
    x3 = w[5]*x1 .+ w[6]
    unnormalizedlogprobs = x3
    if training
        return unnormalizedlogprobs
    else
        normalizedlogprobs = Knet.logp(unnormalizedlogprobs, 1)
        normalizedprobs = exp.(normalizedlogprobs)
        @assert(all(0 .<= normalizedprobs .<= 1))
        @assert(all(isapprox.(sum(normalizedprobs, 1),1.0;atol = 0.00001,)))
        return normalizedprobs
    end
end
function knetmlp_loss(
        predict::Function,
        modelweights, # don't put a type annotation on this
        x::AbstractArray,
        ytrue::AbstractArray;
        L1::Real = Cfloat(0),
        L2::Real = Cfloat(0),
        )
    loss = Knet.nll(
        predict(modelweights, x; training = true),
        ytrue,
        1, # d = 1 means that instances are in columns
        )
    if L1 !== 0
        loss += L1 * sum(sum(abs, w_i) for w_i in modelweights[1:2:end])
    end
    if L2 !== 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in modelweights[1:2:end])
    end
    return loss
end
knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.00001)
knetmlp_losshyperparameters[:L2] = Cfloat(0.00001)
knetmlp_optimizationalgorithm = :Momentum
knetmlp_optimizerhyperparameters = Dict()
knetmlp_batchsize = 48
knetmlp_maxepochs = 500
knetmlp_modelweights = Any[
    # input layer has featurecontrasts.numarrayfeatures features
    # first hidden layer (64 neurons):
    Cfloat.(0.1f0*randn(Cfloat,64,featurecontrasts.numarrayfeatures)),#weights
    Cfloat.(zeros(Cfloat,64,1)), # biases
    # second hidden layer (32 neurons):
    Cfloat.(0.1f0*randn(Cfloat,32,64)), # weights
    Cfloat.(zeros(Cfloat,32,1)), # biases
    # output layer (2 neurons, same as number of classes):
    Cfloat.(0.1f0*randn(Cfloat,2,64)), # weights
    Cfloat.(zeros(Cfloat,2,1)), # biases
    ]
knetmlp = asb.knetclassifier(
    featurenames,
    labelname,
    labellevels,
    featurecontrasts;
    package = :Knetjl,
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    batchsize = knetmlp_batchsize,
    modelweights = knetmlp_modelweights,
    printlosseverynepochs = 50, # if 0, will not print at all
    maxepochs = knetmlp_maxepochs,
    )
asb.fit!(
    knetmlp,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
knetmlp_learningcurve_lossvsepoch = asb.plotlearningcurve(
    knetmlp,
    :lossvsepoch;
    window = 50,
    sampleevery = 1,
    )
asb.open(knetmlp_learningcurve_lossvsepoch)
knetmlp_learningcurve_lossvsiteration = asb.plotlearningcurve(
    knetmlp,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    )
asb.open(knetmlp_learningcurve_lossvsiteration)
# Evaluate the performance of the multilayer perceptron on the testing set
asb.binaryclassificationmetrics(
    knetmlp,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )
asb.binaryclassificationmetrics(
    knetmlp,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    )
asb.binaryclassificationmetrics(
    knetmlp,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score
    )

##############################################################################

# Compare the performance of all models on the testing set
allmodels = [
    logistic,
    probit,
    randomforest,
    svm,
    knetmlp,
    ]
showall(asb.binaryclassificationmetrics(
    allmodels,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(asb.binaryclassificationmetrics(
    allmodels,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(asb.binaryclassificationmetrics(
    allmodels,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    ))

# Plot receiver operating characteristic curves for all models
rocplot = asb.plotroccurves(
    allmodels,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )
asb.open(rocplot)

# Plot precision-recall curves for all models
prplot = asb.plotprcurves(
    allmodels,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )
asb.open(prplot)
