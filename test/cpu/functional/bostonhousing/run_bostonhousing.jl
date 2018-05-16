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

# import required packages
import PredictMD
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
PredictMD.shuffle_rows!(df)

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
    feature_contrasts = PredictMD.generate_feature_contrasts(df, featurenames)
end

# Define labels
labelname = :MedV

# Put features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# View summary statistics for label variable (mean, quartiles, etc.)
DataFrames.describe(labelsdf[labelname])

# Split data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    PredictMD.split_data(featuresdf,labelsdf,0.7)

##############################################################################
##############################################################################
### Section 3: Set up and train models #######################################
##############################################################################
##############################################################################

##############################################################################
## Linear regression #########################################################
##############################################################################

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    linearreg = PredictMD.load(linearreg_filename)
else
    # Set up linear regression model
    linearreg = PredictMD.singlelabeldataframelinearregression(
        featurenames,
        labelname;
        package = :GLMjl,
        intercept = true, # optional, defaults to true
        name = "Linear regression", # optional
        )
    # set feature contrasts
    PredictMD.set_feature_contrasts!(linearreg , feature_contrasts)
    # Train linear regression model
    PredictMD.fit!(linearreg,trainingfeaturesdf,traininglabelsdf,)
end

# View coefficients, p values, etc. for underlying linear regression
PredictMD.get_underlying(linearreg)

# Plot true values versus predicted values for linear regression on training set
linearreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linearreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )
PredictMD.open(linearreg_plot_training)

# Plot true values versus predicted values for linear regression on testing set
linearreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linearreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname
    )
PredictMD.open(linearreg_plot_testing)

# Evaluate performance of linear regression on training set
PredictMD.singlelabelregressionmetrics(
    linearreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of linear regression on testing set
PredictMD.singlelabelregressionmetrics(
    linearreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Random forest regression ##################################################
##############################################################################



if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    randomforestreg = PredictMD.load!(randomforestreg_filename)
else
    # Set up random forest regression model
    randomforestreg = PredictMD.singlelabeldataframerandomforestregression(
        featurenames,
        labelname;
        nsubfeatures = 2, # number of subfeatures; defaults to 2
        ntrees = 20, # number of trees; defaults to 10
        package = :DecisionTreejl,
        name = "Random forest" # optional
        )
    # set feature contrasts
    PredictMD.set_feature_contrasts!(randomforestreg , feature_contrasts)
    # Train random forest model on training set
    PredictMD.fit!(randomforestreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot true values versus predicted values for random forest on training set
randomforestreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    randomforestreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )
PredictMD.open(randomforestreg_plot_training)

# Plot true values versus predicted values for random forest on testing set
randomforestreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    randomforestreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )
PredictMD.open(randomforestreg_plot_testing)

# Evaluate performance of random forest on training set
PredictMD.singlelabelregressionmetrics(
    randomforestreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of random forest on testing set
PredictMD.singlelabelregressionmetrics(
    randomforestreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Support vector machine (epsilon support vector regression) ################
##############################################################################

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    epsilonsvr_svmreg = PredictMD.load(epsilonsvr_svmreg_filename)
else
    # Set up epsilon-SVR model
    epsilonsvr_svmreg = PredictMD.singlelabeldataframesvmregression(
        featurenames,
        labelname;
        package = :LIBSVMjl,
        svmtype = LIBSVM.EpsilonSVR,
        name = "SVM (epsilon-SVR)",
        kernel = LIBSVM.Kernel.Linear,
        verbose = false,
        )
    # set feature contrasts
    PredictMD.set_feature_contrasts!(epsilonsvr_svmreg , feature_contrasts)
    # Train epsilon-SVR model on training set
    PredictMD.fit!(epsilonsvr_svmreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot true values versus predicted values for epsilon-SVR on training set
epsilonsvr_svmreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    epsilonsvr_svmreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )
PredictMD.open(epsilonsvr_svmreg_plot_training)

# Plot true values versus predicted values for epsilon-SVR on testing set
epsilonsvr_svmreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    epsilonsvr_svmreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )
PredictMD.open(epsilonsvr_svmreg_plot_testing)

# Evaluate performance of epsilon-SVR on training set
PredictMD.singlelabelregressionmetrics(
    epsilonsvr_svmreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of epsilon-SVR on testing set
PredictMD.singlelabelregressionmetrics(
    epsilonsvr_svmreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
## Support vector machine (nu support vector regression) ################
##############################################################################

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    nusvr_svmreg = PredictMD.load!(nusvr_svmreg_filename)
else
    # Set up nu-SVR model
    nusvr_svmreg = PredictMD.singlelabeldataframesvmregression(
        featurenames,
        labelname;
        package = :LIBSVMjl,
        svmtype = LIBSVM.NuSVR,
        name = "SVM (nu-SVR)",
        kernel = LIBSVM.Kernel.Linear,
        verbose = false,
        )
    # set feature contrasts
    PredictMD.set_feature_contrasts!(nusvr_svmreg , feature_contrasts)
    # Train nu-SVR model
    PredictMD.fit!(nusvr_svmreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot true values versus predicted values for nu-SVR on training set
nusvr_svmreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    nusvr_svmreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )
PredictMD.open(nusvr_svmreg_plot_training)

# Plot true values versus predicted values for nu-SVR on testing set
nusvr_svmreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    nusvr_svmreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )
PredictMD.open(nusvr_svmreg_plot_testing)

# Evaluate performance of nu-SVR on training set
PredictMD.singlelabelregressionmetrics(
    nusvr_svmreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of nu-SVR on testing set
PredictMD.singlelabelregressionmetrics(
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

if get(ENV, "LOADTRAINEDMODELSFROMFILE", "") == "true"
    knetmlpreg = PredictMD.load(knetmlpreg_filename)
else
    # Randomly initialize model weights
    knetmlp_modelweights = Any[
        # input layer has dimension contrasts.num_array_columns
        #
        # hidden layer (10 neurons):
        Cfloat.(
            0.1f0*randn(Cfloat,10,feature_contrasts.num_array_columns) # weights
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
    knetmlpreg = PredictMD.singlelabeldataframeknetregression(
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
    # set feature contrasts
    PredictMD.set_feature_contrasts!(knetmlpreg , feature_contrasts)
    # Train multilayer perceptron model on training set
    PredictMD.fit!(knetmlpreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot learning curve: loss vs. epoch
knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsepoch;
    )
PredictMD.open(knet_learningcurve_lossvsepoch)

# Plot learning curve: loss vs. epoch, skip the first 10 epochs
knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsepoch;
    startat = 10,
    endat = :end,
    )
PredictMD.open(knet_learningcurve_lossvsepoch_skip10epochs)

# Plot learning curve: loss vs. iteration
knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    )
PredictMD.open(knet_learningcurve_lossvsiteration)

# Plot learning curve: loss vs. iteration, skip the first 100 iterations
knet_learningcurve_lossvsiteration_skip100iterations = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )
PredictMD.open(knet_learningcurve_lossvsiteration_skip100iterations)

# Plot true values versus predicted values for multilayer perceptron on training set
knetmlpreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knetmlpreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )
PredictMD.open(knetmlpreg_plot_training)

# Plot true values versus predicted values for multilayer perceptron on testing set
knetmlpreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knetmlpreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )
PredictMD.open(knetmlpreg_plot_testing)

# Evaluate performance of multilayer perceptron on training set
PredictMD.singlelabelregressionmetrics(
    knetmlpreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Evaluate performance of multilayer perceptron on testing set
PredictMD.singlelabelregressionmetrics(
    knetmlpreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

##############################################################################
##############################################################################
### Section 4: Compare performance of all models #############################
##############################################################################
##############################################################################

all_models = PredictMD.Fittable[
    linearreg,
    randomforestreg,
    epsilonsvr_svmreg,
    nusvr_svmreg,
    knetmlpreg,
    ]

# Compare performance of all five models on training set
showall(PredictMD.singlelabelregressionmetrics(
    all_models,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    ))

# Compare performance of all models on testing set
showall(PredictMD.singlelabelregressionmetrics(
    all_models,
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
    PredictMD.save_model(linearreg_filename, linearreg)
    PredictMD.save_model(randomforestreg_filename, randomforestreg)
    PredictMD.save_model(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)
    PredictMD.save_model(nusvr_svmreg_filename, nusvr_svmreg)
    PredictMD.save_model(knetmlpreg_filename, knetmlpreg)
end

##############################################################################
##############################################################################
## Appendix A: Directly access the output of regression models ###############
##############################################################################
##############################################################################

# We can use the PredictMD.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
PredictMD.predict(linearreg,trainingfeaturesdf,)
PredictMD.predict(randomforestreg,trainingfeaturesdf,)
PredictMD.predict(epsilonsvr_svmreg,trainingfeaturesdf,)
PredictMD.predict(nusvr_svmreg,trainingfeaturesdf,)
PredictMD.predict(knetmlpreg,trainingfeaturesdf,)

# Get real-valued predictions from each model for testing set
PredictMD.predict(linearreg,testingfeaturesdf,)
PredictMD.predict(randomforestreg,testingfeaturesdf,)
PredictMD.predict(epsilonsvr_svmreg,testingfeaturesdf,)
PredictMD.predict(nusvr_svmreg,testingfeaturesdf,)
PredictMD.predict(knetmlpreg,testingfeaturesdf,)
