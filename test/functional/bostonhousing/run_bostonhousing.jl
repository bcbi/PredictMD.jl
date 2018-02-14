linearreg_filename = ENV["linearreg_filename"]
randomforestreg_filename = ENV["randomforestreg_filename"]
epsilonsvr_svmreg_filename = ENV["epsilonsvr_svmreg_filename"]
nusvr_svmreg_filename = ENV["nusvr_svmreg_filename"]
knetmlpreg_filename = ENV["knetmlpreg_filename"]

##############################################################################
##############################################################################
### Section 1: Setup #########################################################
##############################################################################
##############################################################################

error("going to skip this test for now.")

# import required packages
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import CSV
import DataFrames
import GZip
import Knet
import LIBSVM
import StatsBase

# set the seed of the global random number generator
# this makes the results reproducible
srand(999)

##############################################################################
##############################################################################
### Section 2: Prepare data ##################################################
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

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
else
    featurecontrasts = asb.featurecontrasts(df, featurenames)
end

# Define labels
labelname = :MedV

# Put features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# View summary statistics for label variable (mean, quartiles, etc.)
StatsBase.summarystats(labelsdf[labelname])

# Split data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    asb.train_test_split(featuresdf,labelsdf;training = 0.7,testing = 0.3,)

##############################################################################
##############################################################################
### Section 3: Set up and train models #######################################
##############################################################################
##############################################################################

##############################################################################
## Linear regression #########################################################
##############################################################################

# Set up linear regression model
linearreg = asb.singlelabeldataframelinearregression(
    featurenames,
    labelname;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Linear regression", # optional
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(linearreg_filename, linearreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(linearreg, featurecontrasts)
    # Train linear regression model
    asb.fit!(linearreg,trainingfeaturesdf,traininglabelsdf,)
end

# View coefficients, p values, etc. for underlying linear regression
asb.getunderlying(linearreg)

# Evaluate performance of linear regression on training set
asb.singlelabelregressionmetrics(
    linearreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of linear regression on testing set
asb.singlelabelregressionmetrics(
    linearreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Random forest regression ##################################################
##############################################################################

# Set up random forest regression model
randomforestreg = asb.singlelabeldataframerandomforestregression(
    featurenames,
    labelname;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(randomforestreg_filename, randomforestreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(randomforestreg, featurecontrasts)
    # Train random forest model on training set
    asb.fit!(randomforestreg,trainingfeaturesdf,traininglabelsdf,)
end

# Evaluate performance of random forest on training set
asb.singlelabelregressionmetrics(
    randomforestreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of random forest on testing set
asb.singlelabelregressionmetrics(
    randomforestreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Support vector machine (epsilon support vector regression) ################
##############################################################################

# Set up epsilon-SVR model
epsilonsvr_svmreg = asb.singlelabeldataframesvmregression(
    featurenames,
    labelname;
    package = :LIBSVMjl,
    svmtype = LIBSVM.EpsilonSVR,
    name = "SVM (epsilon-SVR)",
    kernel = LIBSVM.Kernel.Linear,
    verbose = false,
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(epsilonsvr_svmreg, featurecontrasts)
    # Train epsilon-SVR model on training set
    asb.fit!(epsilonsvr_svmreg,trainingfeaturesdf,traininglabelsdf,)
end

# Evaluate performance of epsilon-SVR on training set
asb.singlelabelregressionmetrics(
    epsilonsvr_svmreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of epsilon-SVR on testing set
asb.singlelabelregressionmetrics(
    epsilonsvr_svmreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Support vector machine (nu support vector regression) ################
##############################################################################

# Set up nu-SVR model
nusvr_svmreg = asb.singlelabeldataframesvmregression(
    featurenames,
    labelname;
    package = :LIBSVMjl,
    svmtype = LIBSVM.NuSVR,
    name = "SVM (nu-SVR)",
    kernel = LIBSVM.Kernel.Linear,
    verbose = false,
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(nusvr_svmreg_filename, nusvr_svmreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(nusvr_svmreg, featurecontrasts)
    # Train nu-SVR model
    asb.fit!(nusvr_svmreg,trainingfeaturesdf,traininglabelsdf,)
end

# Evaluate performance of nu-SVR on training set
asb.singlelabelregressionmetrics(
    nusvr_svmreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of nu-SVR on testing set
asb.singlelabelregressionmetrics(
    nusvr_svmreg,
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
    # x0 = input layer
    # x1 = hidden layer
    x1 = Knet.relu.( w[1]*x0 .+ w[2] ) # w[1] = weights, w[2] = biases
    # x2 = output layer
    x2 = w[3]*x1 .+ w[4] # w[3] = weights, w[4] = biases
    return x2
end

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    # No need to initialize weights since we are going to load them from file
    knetmlp_modelweights = Any[]
else
    # Randomly initialize model weights
    knetmlp_modelweights = Any[
        # input layer has dimension featurecontrasts.numarrayfeatures
        #
        # hidden layer (10 neurons):
        Cfloat.(
            0.1f0*randn(Cfloat,10,featurecontrasts.numarrayfeatures) # weights
            ),
        Cfloat.(
            zeros(Cfloat,10,1) # biases
            ),
        #
        # output layer (regression nets have exactly 1 neuron in output layer):
        Cfloat.(
            0.1f0*randn(Cfloat,1,10) # weights
            ),
        Cfloat.(
            zeros(Cfloat,1,1) # biases
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
    loss = mean(
        abs2,
        ytrue - predict(modelweights, x),
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

# Set up multilayer perceptron model
knetmlpreg = asb.singlelabeldataframeknetregression(
    featurenames,
    labelname;
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
    printlosseverynepochs = 100, # if 0, will not print at all
    )

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    asb.load!(knetmlpreg_filename, knetmlpreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(knetmlpreg, featurecontrasts)
    # Train multilayer perceptron model on training set
    asb.fit!(knetmlpreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot learning curve: loss vs. epoch
knet_learningcurve_lossvsepoch = asb.plotlearningcurve(
    knetmlpreg,
    :lossvsepoch;
    )
asb.open(knet_learningcurve_lossvsepoch)

# Plot learning curve: loss vs. epoch, skip the first 10 epochs
knet_learningcurve_lossvsepoch_skip10epochs = asb.plotlearningcurve(
    knetmlpreg,
    :lossvsepoch;
    startat = 10,
    endat = :end,
    )
asb.open(knet_learningcurve_lossvsepoch_skip10epochs)

# Plot learning curve: loss vs. iteration
knet_learningcurve_lossvsiteration = asb.plotlearningcurve(
    knetmlpreg,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    )
asb.open(knet_learningcurve_lossvsiteration)

# Plot learning curve: loss vs. iteration, skip the first 100 iterations
knet_learningcurve_lossvsiteration_skip100iterations = asb.plotlearningcurve(
    knetmlpreg,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )
asb.open(knet_learningcurve_lossvsiteration_skip100iterations)

# Evaluate performance of multilayer perceptron on training set
asb.singlelabelregressionmetrics(
    knetmlpreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of multilayer perceptron on testing set
asb.singlelabelregressionmetrics(
    knetmlpreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
##############################################################################
### Section 4: Compare performance of all models ##############################
##############################################################################
##############################################################################

# Compare performance of all five models on training set
showall(asb.singlelabelregressionmetrics(
    [
        linearreg,
        randomforestreg,
        epsilonsvr_svmreg,
        nusvr_svmreg,
        knetmlpreg,
        ],
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    ))

# Compare performance of all models on testing set
showall(asb.singlelabelregressionmetrics(
    [
        linearreg,
        randomforestreg,
        epsilonsvr_svmreg,
        nusvr_svmreg,
        knetmlpreg,
        ],
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    ))

##############################################################################
##############################################################################
### Section 5: Save trained models to file (if desired) #######################
##############################################################################
##############################################################################

if get(ENV, "SAVETRAINEDMODELSTOFILE", "") == "true"
    asb.save(linearreg_filename, linearreg)
    asb.save(randomforestreg_filename, randomforestreg)
    asb.save(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)
    asb.save(nusvr_svmreg_filename, nusvr_svmreg)
    asb.save(knetmlpreg_filename, knetmlpreg)
end

##############################################################################
##############################################################################
## Appendix A: Directly access the output of regression models ###############
##############################################################################
##############################################################################

# We can use the asb.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
asb.predict(linearreg,trainingfeaturesdf,)
asb.predict(randomforestreg,trainingfeaturesdf,)
asb.predict(epsilonsvr_svmreg,trainingfeaturesdf,)
asb.predict(nusvr_svmreg,trainingfeaturesdf,)
asb.predict(knetmlpreg,trainingfeaturesdf,)

# Get real-valued predictions from each model for testing set
asb.predict(linearreg,testingfeaturesdf,)
asb.predict(randomforestreg,testingfeaturesdf,)
asb.predict(epsilonsvr_svmreg,testingfeaturesdf,)
asb.predict(nusvr_svmreg,testingfeaturesdf,)
asb.predict(knetmlpreg,testingfeaturesdf,)
