
# import required packages
import PredictMD
import CSV
import DataFrames
import GZip
import StatsBase

# set the seed of the global random number generator
# this makes the results reproducible
srand(999)

# Load and prepare data

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
featurenames = Symbol[
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

labelname = :MedV

# Put features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# Split data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    PredictMD.train_test_split(featuresdf,labelsdf;training = 0.7,testing = 0.3,);

# load pre-trained models
linearreg_filename = "./linearreg.jld2"

# Set up linear regression model
linearreg = PredictMD.singlelabeldataframelinearregression(
    featurenames,
    labelname;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Linear regression", # optional
    )
PredictMD.load!(linearreg_filename, linearreg)

# Set up random forest regression model
randomforestreg_filename = "./randomforestreg.jld2"

randomforestreg = PredictMD.singlelabeldataframerandomforestregression(
    featurenames,
    labelname;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )
PredictMD.load!(randomforestreg_filename, randomforestreg)

# Set up epsilon-SVR model
epsilonsvr_svmreg_filename = "./epsilonsvr_svmreg.jld2"

epsilonsvr_svmreg = PredictMD.singlelabeldataframesvmregression(
    featurenames,
    labelname;
    package = :LIBSVMjl,
    svmtype = LIBSVM.EpsilonSVR,
    name = "SVM (epsilon-SVR)",
    kernel = LIBSVM.Kernel.Linear,
    verbose = false,
    )
PredictMD.load!(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)

# Set up nu-SVR model
nusvr_svmreg_filename = "./nusvr_svmreg.jld2"
nusvr_svmreg = PredictMD.singlelabeldataframesvmregression(
    featurenames,
    labelname;
    package = :LIBSVMjl,
    svmtype = LIBSVM.NuSVR,
    name = "SVM (nu-SVR)",
    kernel = LIBSVM.Kernel.Linear,
    verbose = false,
    )
PredictMD.load!(nusvr_svmreg_filename, nusvr_svmreg)


# Set up multilayer perceptron model
knetmlpreg_filename = "./knetmlpreg.jld2"

#This should be defined somewhere else

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

knetmlp_modelweights = Any[]

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
PredictMD.load!(knetmlpreg_filename, knetmlpreg)

# Compare performance of all five models on training set
showall(PredictMD.singlelabelregressionmetrics(
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
showall(PredictMD.singlelabelregressionmetrics(
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
