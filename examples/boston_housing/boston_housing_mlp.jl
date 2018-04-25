
# import required packages
import PredictMD
import CSV
import DataFrames
import GZip
import Knet
import StatsBase

# set the seed of the global random number generator
# this makes the results reproducible
srand(999)

load_pretrained = false
save_trained = true

# load_trained = true
# save_trained = false

knetmlpreg_filename = "./knetmlpreg.jld2"

# Import Boston housing data
df = CSV.read(
    GZip.gzopen(joinpath(Pkg.dir("RDatasets"),"data","MASS","Boston.csv.gz")),
    DataFrames.DataFrame,
    )

#take a quick look at file header and few rows
DataFrames.head(df)

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

if load_pretrained == "true"
else
    contrasts = PredictMD.contrasts(df, featurenames)
end

# Define labels
labelname = :MedV

# Put features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[[labelname]]

# Display for exploration
display(DataFrames.head(featuresdf))
display(DataFrames.head(labelsdf))

# View summary statistics for label variable (mean, quartiles, etc.)
DataFrames.describe(labelsdf[labelname])

# Split data into training set (70%) and testing set (30%)
trainingfeaturesdf,testingfeaturesdf,traininglabelsdf,testinglabelsdf =
    PredictMD.split_data(featuresdf,labelsdf,0.7);

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

if load_pretrained
    # No need to initialize weights since we are going to load them from file
    knetmlp_modelweights = Any[]
else
    # Randomly initialize model weights
    knetmlp_modelweights = Any[
        # input layer has dimension contrasts.num_array_columns
        #
        # hidden layer (10 neurons):
        Cfloat.(
            0.1f0*randn(Cfloat,10,contrasts.num_array_columns) # weights
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

if load_pretrained == "true"
    PredictMD.load!(knetmlpreg_filename, knetmlpreg)
else
    # set feature contrasts
    PredictMD.set_contrasts!(knetmlpreg, contrasts)
    # Train multilayer perceptron model on training set
    PredictMD.fit!(knetmlpreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot learning curve: loss vs. epoch
knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsepoch;
    )

# Plot learning curve: loss vs. epoch, skip the first 10 epochs
knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsepoch;
    startat = 10,
    endat = :end,
    )

# Plot learning curve: loss vs. iteration
knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    )

# Plot learning curve: loss vs. iteration, skip the first 100 iterations
knet_learningcurve_lossvsiteration_skip100iterations = PredictMD.plotlearningcurve(
    knetmlpreg,
    :lossvsiteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )

# Plot true values versus predicted values for multilayer perceptron on training set
knetmlpreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knetmlpreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Plot true values versus predicted values for multilayer perceptron on testing set
knetmlpreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knetmlpreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

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

if save_trained
    PredictMD.save(knetmlpreg_filename, knetmlpreg)
end

# We can use the PredictMD.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
PredictMD.predict(knetmlpreg,trainingfeaturesdf)

# Get real-valued predictions from each model for testing set
PredictMD.predict(knetmlpreg,testingfeaturesdf)
