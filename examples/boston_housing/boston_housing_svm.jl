
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

load_pretrained = false
save_trained = true

# load_pretrained = true
# save_trained = false

epsilonsvr_svmreg_filename = "./epsilonsvr_svmreg.jld2"
nusvr_svmreg_filename = "./nusvr_svmreg.jld2"

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

if load_pretrained
else
    featurecontrasts = PredictMD.featurecontrasts(df, featurenames)
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
    PredictMD.train_test_split(featuresdf,labelsdf;training = 0.7,testing = 0.3,);

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

if load_pretrained
    PredictMD.load!(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)
else
    # set feature contrasts
    PredictMD.setfeaturecontrasts!(epsilonsvr_svmreg, featurecontrasts)
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

# Plot true values versus predicted values for epsilon-SVR on testing set
epsilonsvr_svmreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    epsilonsvr_svmreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

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

if load_pretrained
    PredictMD.load!(nusvr_svmreg_filename, nusvr_svmreg)
else
    # set feature contrasts
    PredictMD.setfeaturecontrasts!(nusvr_svmreg, featurecontrasts)
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

# Plot true values versus predicted values for nu-SVR on testing set
nusvr_svmreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    nusvr_svmreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

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

if save_trained
    PredictMD.save(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)
    PredictMD.save(nusvr_svmreg_filename, nusvr_svmreg)
end

# We can use the PredictMD.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
PredictMD.predict(epsilonsvr_svmreg,trainingfeaturesdf)
PredictMD.predict(nusvr_svmreg,trainingfeaturesdf)

# Get real-valued predictions from each model for testing set
PredictMD.predict(epsilonsvr_svmreg,testingfeaturesdf)
PredictMD.predict(nusvr_svmreg,testingfeaturesdf)
