# set the seed of the random number generator
srand(999)

# import required packages
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import CSV
import DataFrames
import GZip
import Knet
import LIBSVM
import StatsBase

##############################################################################
##############################################################################
## Section 1: Prepare data ###################################################
##############################################################################
##############################################################################

# Import Boston housing data
df = CSV.read(
    GZip.gzopen(joinpath(Pkg.dir("RDatasets"),"data","MASS","Boston.csv.gz")),
    DataFrames.DataFrame,
    )

# Remove rows with missing data
DataFrames.dropmissing!(df)

# Shuffle rows
asb.shufflerows!(df)

# Define labels
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
featurecontrasts = asb.featurecontrasts(df, featurenames)

# Define labels
labelname = :MedV

# Put features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# View summary statistics for label variable
StatsBase.summarystats(labelsdf[labelname])

# Split data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    asb.train_test_split(featuresdf,labelsdf;training = 0.7,testing = 0.3,)

##############################################################################
##############################################################################
## Section 2: Set up and train models ########################################
##############################################################################
##############################################################################

##############################################################################
## Linear regression #########################################################
##############################################################################

# Set up linear regression model
linearregression = asb.linearregression(
    featurenames,
    labelname;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Linear regression", # optional
    )

# Train linear regression model
asb.fit!(linearregression,trainingfeaturesdf,traininglabelsdf,)

# View coefficients, p values, etc. for underlying linear regression
asb.underlying(linearregression)

# Evaluate performance of linear regression on training set
asb.regressionmetrics(
    linearregression,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of linear regression on testing set
asb.regressionmetrics(
    linearregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Random forest regression ##################################################
##############################################################################

# Set up random forest regression model
randomforestregression = asb.randomforestregression(
    featurenames,
    labelname,
    featurecontrasts;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )

# Train random forest model on training set
asb.fit!(randomforestregression,trainingfeaturesdf,traininglabelsdf,)

# Evaluate performance of random forest on training set
asb.regressionmetrics(
    randomforestregression,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of random forest on testing set
asb.regressionmetrics(
    randomforestregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Support vector machine (epsilon support vector regression) ################
##############################################################################

# Set up epsilon-SVR model
epsilonsvr_svmregression = asb.svmregression(
    featurenames,
    labelname,
    featurecontrasts;
    package = :LIBSVMjl,
    svmtype = LIBSVM.EpsilonSVR,
    name = "SVM (epsilon-SVR)",
    kernel = LIBSVM.Kernel.Linear,
    )

# Train epsilon-SVR model on training set
asb.fit!(epsilonsvr_svmregression,trainingfeaturesdf,traininglabelsdf,)

# Evaluate performance of epsilon-SVR on training set
asb.regressionmetrics(
    epsilonsvr_svmregression,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of epsilon-SVR on testing set
asb.regressionmetrics(
    epsilonsvr_svmregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Support vector machine (epsilon support vector regression) ################
##############################################################################

# Set up nu-SVR model
nusvr_svmregression = asb.svmregression(
    featurenames,
    labelname,
    featurecontrasts;
    package = :LIBSVMjl,
    svmtype = LIBSVM.NuSVR,
    name = "SVM (nu-SVR)",
    kernel = LIBSVM.Kernel.Linear,
    )

# Train nu-SVR model
asb.fit!(nusvr_svmregression,trainingfeaturesdf,traininglabelsdf,)

# Evaluate performance of nu-SVR on training set
asb.regressionmetrics(
    nusvr_svmregression,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of nu-SVR on testing set
asb.regressionmetrics(
    nusvr_svmregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Multilayer perceptron (i.e. fully connected feedforward neural network) ###
##############################################################################

# Define predict function
function knetmlp_predict(
        w, # don't put a type annotation on this
        x0::AbstractArray;
        training::Bool = false,
        )
    x1 = Knet.relu.( w[1]*x0 .+ w[2] )
    x3 = w[3]*x1 .+ w[4]
    return x3
end

# Define loss function
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
        ytrue - predict(modelweights, x),
        )
    if L1 !== 0
        loss += L1 * sum(sum(abs, w_i) for w_i in modelweights[1:2:end])
    end
    if L2 !== 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in modelweights[1:2:end])
    end
    return loss
end

# Define loss hyperparameters
knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.00001)
knetmlp_losshyperparameters[:L2] = Cfloat(0.00001)

# Select optimization algorithm
knetmlp_optimizationalgorithm = :Adam

# Set optimization hyperparameters
knetmlp_optimizerhyperparameters = Dict()

# Set the minibatch size
knetmlp_minibatchsize = 48

# Set the max number of epochs. After training, look at the learning curve. If
# it looks like the model has not yet converged, raise maxepochs. If it looks
# like the loss has hit a plateau and you are worried about overfitting, lower
# maxepochs.
knetmlp_maxepochs = 500

# Randomly initialize model weights
knetmlp_modelweights = Any[
    # input layer has featurecontrasts.numarrayfeatures features
    # first hidden layer (64 neurons):
    Cfloat.(0.1f0*randn(Cfloat,10,featurecontrasts.numarrayfeatures)),#weights
    Cfloat.(zeros(Cfloat,10,1)), # biases
    # output layer (2 neurons, same as number of classes):
    Cfloat.(0.1f0*randn(Cfloat,1,10)), # weights
    Cfloat.(zeros(Cfloat,1,1)), # biases
    ]

# Set up multilayer perceptron model
knetmlpregression = asb.knetregression(
    featurenames,
    labelname,
    featurecontrasts;
    package = :Knetjl,
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = knetmlp_maxepochs,
    printlosseverynepochs = 50, # if 0, will not print at all
    )

# Train multilayer perceptron model on training set
asb.fit!(knetmlpregression,trainingfeaturesdf,traininglabelsdf,)

# Plot learning curve: loss vs. epoch
knetmlp_learningcurve_lossvsepoch = asb.plotlearningcurve(
    knetmlpregression,
    :lossvsepoch;
    )
asb.open(knetmlp_learningcurve_lossvsepoch)

# Plot learning curve: loss vs. epoch, skip the first 10 epochs
knetmlp_learningcurve_lossvsepoch = asb.plotlearningcurve(
    knetmlpregression,
    :lossvsepoch;
    startat = 10,
    endat = :end,
    )
asb.open(knetmlp_learningcurve_lossvsepoch)

# Plot learning curve: loss vs. iteration
knetmlp_learningcurve_lossvsiteration = asb.plotlearningcurve(
    knetmlpregression,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    )
asb.open(knetmlp_learningcurve_lossvsiteration)

# Evaluate performance of multilayer perceptron on training set
asb.regressionmetrics(
    knetmlpregression,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of multilayer perceptron on testing set
asb.regressionmetrics(
    knetmlpregression,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
##############################################################################
## Section 3: Compare performance of all models ##########################
##############################################################################
##############################################################################


# Compare performance of all five models on training set
showall(asb.regressionmetrics(
    [
        linearregression,
        randomforestregression,
        epsilonsvr_svmregression,
        nusvr_svmregression,
        knetmlpregression,
        ],
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    ))

# Compare performance of all models on testing set
showall(asb.regressionmetrics(
    [
        linearregression,
        randomforestregression,
        epsilonsvr_svmregression,
        nusvr_svmregression,
        knetmlpregression,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    ))

##############################################################################
##############################################################################
## Appendix A: Directly access the output of regression models ###############
##############################################################################
##############################################################################

# We can use the asb.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
asb.predict(linearregression,trainingfeaturesdf,)
asb.predict(randomforestregression,trainingfeaturesdf,)
asb.predict(epsilonsvr_svmregression,trainingfeaturesdf,)
asb.predict(nusvr_svmregression,trainingfeaturesdf,)
asb.predict(knetmlpregression,trainingfeaturesdf,)

# Get real-valued predictions from each model for testing set
asb.predict(linearregression,testingfeaturesdf,)
asb.predict(randomforestregression,testingfeaturesdf,)
asb.predict(epsilonsvr_svmregression,testingfeaturesdf,)
asb.predict(nusvr_svmregression,testingfeaturesdf,)
asb.predict(knetmlpregression,testingfeaturesdf,)

##############################################################################
##############################################################################
## Appendix B: Save models to file and load models from file #################
##############################################################################
##############################################################################
