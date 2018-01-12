logisticclassifier_filename = ENV["logisticclassifier_filename"]
probitclassifier_filename = ENV["probitclassifier_filename"]
rfclassifier_filename = ENV["rfclassifier_filename"]
csvc_svmclassifier_filename = ENV["csvc_svmclassifier_filename"]
nusvc_svmclassifier_filename = ENV["nusvc_svmclassifier_filename"]
knetmlp_filename = ENV["knetmlp_filename"]

##############################################################################
##############################################################################
### Section 1: Setup #########################################################
##############################################################################
##############################################################################

# import required packages
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import DataFrames
import Knet
import LIBSVM
import RDatasets
import StatsBase

# set the seed of the global random number generator
srand(999)

##############################################################################
##############################################################################
### Section 2: Prepare data ##################################################
##############################################################################
##############################################################################

# Import breast cancer biopsy data
df = RDatasets.dataset("MASS", "biopsy")

# Remove rows with missing data
DataFrames.dropmissing!(df)

# Shuffle rows
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

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
else
    featurecontrasts = asb.featurecontrasts(df, featurenames)
end

# Define labels
labelname = :Class
negativeclass = "benign"
positiveclass = "malignant"
labellevels = [negativeclass, positiveclass]

# Put features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# Split data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    asb.train_test_split(featuresdf,labelsdf;training = 0.7,testing = 0.3,)

##############################################################################
##############################################################################
### Section 3: Apply the SMOTE algorithm to the training set #################
##############################################################################
##############################################################################

# Examine prevalence of each class in training set
StatsBase.countmap(traininglabelsdf[labelname])

# We see that malignant is minority class and benign is majority class.
# The ratio of malignant:benign is somewhere between 1:2.5 and 1:3 (depending
# on random seed). We would like that ratio to be 1:1. We will use SMOTE
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
    pct_over = 100, # how much to oversample the minority class
    minority_to_majority_ratio = 1.0, # desired minority:majority ratio
    k = 5,
    )

# Examine prevalence of each class in smoted training set
StatsBase.countmap(smotedtraininglabelsdf[labelname])

# Now we have a ratio of malignant:benign that is 1:1.

##############################################################################
##############################################################################
### Section 4: Set up and train models #######################################
##############################################################################
##############################################################################

##############################################################################
## Logistic regression classifier ############################################
##############################################################################

# Set up logistic classifier model
logisticclassifier = asb.binarylogisticclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Logistic regression", # optional
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(logisticclassifier_filename, logisticclassifier)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(logisticclassifier, featurecontrasts)
    # Train logistic classifier model on smoted training set
    asb.fit!(
        logisticclassifier,
        smotedtrainingfeaturesdf,
        smotedtraininglabelsdf,
        )
end

# View coefficients, p values, etc. for underlying logistic regression
asb.getunderlying(logisticclassifier)

# Evaluate performance of logistic classifier on smoted training set
asb.binaryclassificationmetrics(
    logisticclassifier,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

# Evaluate performance of logistic classifier on testing set
asb.binaryclassificationmetrics(
    logisticclassifier,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

##############################################################################
## Probit regression classifier ##############################################
##############################################################################

# Set up probit classifier model
probitclassifier = asb.binaryprobitclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Probit regression", # optional
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(probitclassifier_filename, probitclassifier)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(probitclassifier, featurecontrasts)
    # Train probit classifier model on smoted training set
    asb.fit!(
        probitclassifier,
        smotedtrainingfeaturesdf,
        smotedtraininglabelsdf,
        )
end

# View coefficients, p values, etc. for underlying probit regression
asb.getunderlying(probitclassifier)

# Evaluate performance of probit classifier on smoted training set
asb.binaryclassificationmetrics(
    probitclassifier,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

# Evaluate performance of probit classifier on testing set
asb.binaryclassificationmetrics(
    probitclassifier,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

##############################################################################
## Random forest #############################################################
##############################################################################

# Set up random forest classifier model
rfclassifier = asb.randomforestclassifier(
    featurenames,
    labelname,
    labellevels;
    nsubfeatures = 4, # number of subfeatures; defaults to 2
    ntrees = 200, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(rfclassifier_filename, rfclassifier)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(rfclassifier, featurecontrasts)
    # Train random forest classifier model on smoted training set
    asb.fit!(
        rfclassifier,
        smotedtrainingfeaturesdf,
        smotedtraininglabelsdf,
        )
end

# Evaluate performance of random forest classifier on smoted training set
asb.binaryclassificationmetrics(
    rfclassifier,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

# Evaluate performance of random forest on testing set
asb.binaryclassificationmetrics(
    rfclassifier,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

##############################################################################
## Support vector machine (C support vector classification) #################
##############################################################################

# Set up C-SVC model
csvc_svmclassifier = asb.svmclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :LIBSVMjl,
    svmtype = LIBSVM.SVC,
    name = "SVM (C-SVC)",
    verbose = false,
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(csvc_svmclassifier_filename, csvc_svmclassifier)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(csvc_svmclassifier, featurecontrasts)
    # Train C-SVC model on smoted training set
    asb.fit!(
        csvc_svmclassifier,
        smotedtrainingfeaturesdf,
        smotedtraininglabelsdf,
        )
end

# Evaluate performance of C-SVC on smoted training set
asb.binaryclassificationmetrics(
    csvc_svmclassifier,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

# Evaluate performance of C-SVC on testing set
asb.binaryclassificationmetrics(
    csvc_svmclassifier,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

##############################################################################
## Support vector machine (nu support vector classification) #################
##############################################################################

# Set up nu-SVC model
nusvc_svmclassifier = asb.svmclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :LIBSVMjl,
    svmtype = LIBSVM.NuSVC,
    name = "SVM (nu-SVC)",
    verbose = false,
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(nusvc_svmclassifier_filename, nusvc_svmclassifier)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(nusvc_svmclassifier, featurecontrasts)
    # Train nu-SVC model on smoted training set
    asb.fit!(
        nusvc_svmclassifier,
        smotedtrainingfeaturesdf,
        smotedtraininglabelsdf,
        )
end

# Evaluate performance of nu-SVC on smoted training set
asb.binaryclassificationmetrics(
    nusvc_svmclassifier,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

# Evaluate performance of SVM on testing set
asb.binaryclassificationmetrics(
    nusvc_svmclassifier,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
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
    # x0 = input layer
    # x1 = first hidden layer
    x1 = Knet.relu.( w[1]*x0 .+ w[2] ) # w[1] = weights, w[2] = biases
    # x2 = second hidden layer
    x2 = Knet.relu.( w[3]*x1 .+ w[4] ) # w[3] = weights, w[4] = biases
    # x3 = output layer
    x3 = w[5]*x2 .+ w[6] # w[5] = weights, w[6] = biases
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

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    # No need to initialize weights since we are going to load them from file
    knetmlp_modelweights = Any[]
else
    # Randomly initialize model weights
    knetmlp_modelweights = Any[
        # input layer has dimension featurecontrasts.numarrayfeatures
        #
        # first hidden layer (64 neurons):
        Cfloat.(
            0.1f0*randn(Cfloat,64,featurecontrasts.numarrayfeatures) # weights
            ),
        Cfloat.(
            zeros(Cfloat,64,1) # biases
            ),
        #
        # second hidden layer (32 neurons):
        Cfloat.(
            0.1f0*randn(Cfloat,32,64) # weights
            ),
        Cfloat.(
            zeros(Cfloat,32,1) # biases
            ),
        #
        # output layer (number of neurons == number of classes):
        Cfloat.(
            0.1f0*randn(Cfloat,2,32) # weights
            ),
        Cfloat.(
            zeros(Cfloat,2,1) # biases
            ),
        ]
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
    loss = Knet.nll(
        predict(modelweights, x; training = true),
        ytrue,
        1, # d = 1 means that instances are in columns
        )
    if L1 != 0
        loss += L1 * sum(sum(abs, w_i) for w_i in modelweights[1:2:end])
    end
    if L2 != 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in modelweights[1:2:end])
    end
    return loss
end

# Define loss hyperparameters
knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.0)
knetmlp_losshyperparameters[:L2] = Cfloat(0.0)

# Select optimization algorithm
knetmlp_optimizationalgorithm = :Momentum

# Set optimization hyperparameters
knetmlp_optimizerhyperparameters = Dict()

# Set the minibatch size
knetmlp_minibatchsize = 48

# Set the max number of epochs. After training, look at the learning curve. If
# it looks like the model has not yet converged, raise maxepochs. If it looks
# like the loss has hit a plateau and you are worried about overfitting, lower
# maxepochs.
knetmlp_maxepochs = 500

# Set up multilayer perceptron model
knetmlpclassifier = asb.knetclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :Knetjl,
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    printlosseverynepochs = 100, # if 0, will not print at all
    maxepochs = knetmlp_maxepochs,
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(knetmlp_filename, knetmlpclassifier)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(knetmlpclassifier, featurecontrasts)
    # Train multilayer perceptron model on training set
    asb.fit!(
        knetmlpclassifier,
        smotedtrainingfeaturesdf,
        smotedtraininglabelsdf,
        )
end

# Plot learning curve: loss vs. epoch
knet_learningcurve_lossvsepoch = asb.plotlearningcurve(
    knetmlpclassifier,
    :lossvsepoch;
    )
asb.open(knet_learningcurve_lossvsepoch)

# Plot learning curve: loss vs. epoch, skip the first 10 epochs
knet_learningcurve_lossvsepoch_skip10epochs = asb.plotlearningcurve(
    knetmlpclassifier,
    :lossvsepoch;
    startat = 10,
    endat = :end,
    )
asb.open(knet_learningcurve_lossvsepoch_skip10epochs)

# Plot learning curve: loss vs. iteration
knet_learningcurve_lossvsiteration = asb.plotlearningcurve(
    knetmlpclassifier,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    )
asb.open(knet_learningcurve_lossvsiteration)

# Plot learning curve: loss vs. iteration, skip the first 100 iterations
knet_learningcurve_lossvsiteration_skip100iterations = asb.plotlearningcurve(
    knetmlpclassifier,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )
asb.open(knet_learningcurve_lossvsiteration_skip100iterations)

# Evaluate performance of multilayer perceptron on smoted training set
asb.binaryclassificationmetrics(
    knetmlpclassifier,
    smotedtrainingfeaturesdf,
    smotedtraininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

# Evaluate performance of multilayer perceptron on testing set
asb.binaryclassificationmetrics(
    knetmlpclassifier,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

##############################################################################
##############################################################################
## Section 5: Compare performance of all models ##############################
##############################################################################
##############################################################################

# Compare performance of all models on smoted training set
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    ))
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    positiveclass;
    maximize = :cohenkappa,
    ))

# Compare performance of all models on testing set
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :f1score,
    ))
showall(asb.binaryclassificationmetrics(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass;
    maximize = :cohenkappa,
    ))

# Plot receiver operating characteristic curves for all models on testing set.
rocplottesting = asb.plotroccurves(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )
asb.open(rocplottesting)

# Plot precision-recall curves for all models on testing set.
prplottesting = asb.plotprcurves(
    [
        logisticclassifier,
        probitclassifier,
        rfclassifier,
        csvc_svmclassifier,
        nusvc_svmclassifier,
        knetmlpclassifier,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    positiveclass,
    )
asb.open(prplottesting)

##############################################################################
##############################################################################
### Section 6: Save trained models to file (if desired) #######################
##############################################################################
##############################################################################

if get(ENV, "SAVETRAINEDMODELSTOFILE", "") == "true"
    asb.save(logisticclassifier_filename, logisticclassifier)
    asb.save(probitclassifier_filename, probitclassifier)
    asb.save(rfclassifier_filename, rfclassifier)
    asb.save(csvc_svmclassifier_filename, csvc_svmclassifier)
    asb.save(nusvc_svmclassifier_filename, nusvc_svmclassifier)
    asb.save(knetmlp_filename, knetmlpclassifier)
end

##############################################################################
##############################################################################
## Appendix A: Directly access the output of classification models ###########
##############################################################################
##############################################################################

# We can use the asb.predict_proba() function to get the probabilities output
# by each of the classification models.

# Get probabilities from each model for smoted training set
asb.predict_proba(logisticclassifier,smotedtrainingfeaturesdf,)
asb.predict_proba(probitclassifier,smotedtrainingfeaturesdf,)
asb.predict_proba(rfclassifier,smotedtrainingfeaturesdf,)
asb.predict_proba(csvc_svmclassifier,smotedtrainingfeaturesdf,)
asb.predict_proba(nusvc_svmclassifier,smotedtrainingfeaturesdf,)
asb.predict_proba(knetmlpclassifier,smotedtrainingfeaturesdf,)

# Get probabilities from each model for testing set
asb.predict_proba(logisticclassifier,testingfeaturesdf,)
asb.predict_proba(probitclassifier,testingfeaturesdf,)
asb.predict_proba(rfclassifier,testingfeaturesdf,)
asb.predict_proba(csvc_svmclassifier,testingfeaturesdf,)
asb.predict_proba(nusvc_svmclassifier,testingfeaturesdf,)
asb.predict_proba(knetmlpclassifier,testingfeaturesdf,)

# If we want to get predicted classes instead of probabilities, we can use the
# asb.predict() function to get the class predictions output by each of the
# classification models. For each sample, asb.predict() will select the class
# with the highest probability. In the case of binary classification, this is
# equivalent to using a threshold of 0.5.

# Get class predictions from each model for smoted training set
asb.predict(logisticclassifier,smotedtrainingfeaturesdf,)
asb.predict(probitclassifier,smotedtrainingfeaturesdf,)
asb.predict(rfclassifier,smotedtrainingfeaturesdf,)
asb.predict(csvc_svmclassifier,smotedtrainingfeaturesdf,)
asb.predict(nusvc_svmclassifier,smotedtrainingfeaturesdf,)
asb.predict(knetmlpclassifier,smotedtrainingfeaturesdf,)

# Get class predictions from each model for testing set
asb.predict(logisticclassifier,testingfeaturesdf,)
asb.predict(probitclassifier,testingfeaturesdf,)
asb.predict(rfclassifier,testingfeaturesdf,)
asb.predict(csvc_svmclassifier,testingfeaturesdf,)
asb.predict(nusvc_svmclassifier,testingfeaturesdf,)
asb.predict(knetmlpclassifier,testingfeaturesdf,)
