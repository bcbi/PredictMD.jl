import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import CSV
import DataFrames
import GZip
import Knet
import LIBSVM
import StatsBase

# Import Boston housing data
df = CSV.read(
    GZip.gzopen(joinpath(Pkg.dir("RDatasets"),"data","MASS","Boston.csv.gz")),
    DataFrames.DataFrame,
    )

# Remove rows with missing data
DataFrames.dropmissing!(df)

# Shuffle the rows
asb.shufflerows!(df)

# Define features and labels
categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
    :Crim,
    :Zn,
    :Indus,
    :Chas,
    :NOx,
    :Rm,
    :Age,
    :Dis,
    :Rad,
    :Tax,
    :PTRatio,
    :Black,
    :LStat,
    ]
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)

# Define labels
labelname = :MedV

# Put the features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# Split the data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    asb.train_test_split(
        featuresdf,
        labelsdf;
        training = 0.7,
        testing = 0.3,
        )

##############################################################################

# Set up and train a linear regression
linear = asb.binarylinearregression(
    featurenames,
    labelname;
    package = :GLM,
    intercept = true, # optional, defaults to true
    name = "Linear regression", # optional
    )
asb.fit!(
    linear,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
# View the coefficients, p values, etc. for the underlying linear regression
asb.underlying(linear)
# Evaluate the performance of the linear regression on the testing set
asb.regressionmetrics(
    linear,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################

# Set up and train a random forest
randomforestregression = asb.randomforestregression(
    featurenames,
    labelname,
    labellevels,
    smotedtrainingfeaturesdf;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTree,
    name = "Random forest" # optional
    )
asb.fit!(
    randomforestregression,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
# Evaluate the performance of the random forest on the testing set
asb.regressionmetrics(
    randomforestregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################

# Set up and train a nu-SVM
nusvmregression = asb.svmregressionregression(
    featurenames,
    labelname,
    labellevels,
    smotedtrainingfeaturesdf;
    package = :LIBSVM,
    name = "nu-SVM",
    )
asb.fit!(
    nusvmregression,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
# Evaluate the performance of the SVM on the testing set
asb.regressionmetrics(
    nusvmregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )

##############################################################################

# Set up and train an epsilon-SVM
epsilonsvmregression = asb.svmregressionregression(
    featurenames,
    labelname,
    labellevels,
    smotedtrainingfeaturesdf;
    package = :LIBSVM,
    name = "epsilon-SVM",
    )
asb.fit!(
    epsilonsvmregression,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    )
# Evaluate the performance of the epsilon-SVM on the testing set
asb.regressionmetrics(
    svmregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
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
    return x3
end
function knetmlp_loss(
        predict::Function,
        modelweights, # don't put a type annotation on this
        x::AbstractArray,
        ytrue::AbstractArray;
        L1::Real = Cfloat(0),
        L2::Real = Cfloat(0),
        )
    loss = mean(
        abs2,
        ytrue - predict(modelweights, x)
        )
    if L1 !== 0
        loss += L1 * sum(sum(abs, w_i) for w_i in modelweights[1:2:end])
    end
    if L2 !== 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in modelweights[1:2:end])
    end
    return loss
end
knet_losshyperparameters = Dict()
knet_losshyperparameters[:L1] = Cfloat(0.00001)
knet_losshyperparameters[:L2] = Cfloat(0.00001)
knet_optimizationalgorithm = :Momentum
knet_optimizerhyperparameters = Dict()
knet_mlpbatchsize = 48
knetmlp_modelweights = Any[
    # input layer has 9 features
    # first hidden layer (64 neurons):
    Cfloat.(0.1f0*randn(Cfloat,64,9)), # weights
    Cfloat.(zeros(Cfloat,64,1)), # biases
    # second hidden layer (32 neurons):
    Cfloat.(0.1f0*randn(Cfloat,32,64)), # weights
    Cfloat.(zeros(Cfloat,32,1)), # biases
    # output layer (2 neurons, same as number of classes):
    Cfloat.(0.1f0*randn(Cfloat,1,64)), # weights
    Cfloat.(zeros(Cfloat,1,1)), # biases
    ]
knetmlp = asb.knetregression(
    featurenames,
    labelname,
    smotedtrainingfeaturesdf;
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    losshyperparameters = knet_losshyperparameters,
    optimizationalgorithm = knet_optimizationalgorithm,
    optimizerhyperparameters = knet_optimizerhyperparameters,
    batchsize = knet_mlpbatchsize,
    modelweights = knetmlp_modelweights,
    )
asb.fit!(
    knetmlp,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf;
    maxepochs = 2_000,
    printlosseverynepochs = 1, # if 0, will not print at all
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
asb.regressionmetrics(
    knetmlp,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################

# Compare the performance of all five models on the testing set
allmodels = [
    linear,
    randomforestregression,
    nusvmregression,
    epsilonsvmregression,
    knetmlp,
    ]
showall(asb.regressionmetrics(
    allmodels,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    ))
