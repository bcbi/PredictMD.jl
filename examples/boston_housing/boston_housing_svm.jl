
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
    contrasts = PredictMD.contrasts(df, featurenames)
end

# Define labels
labelname = :MedV

# Put features and labels in separate dataframes
features_df = df[featurenames]
labels_df = df[[labelname]]

# Display for exploration
display(DataFrames.head(features_df))
display(DataFrames.head(labels_df))

# View summary statistics for label variable (mean, quartiles, etc.)
DataFrames.describe(labels_df[labelname])

# Split data into training set (70%) and testing set (30%)
training_features_df,testing_features_df,traininglabels_df,testing_labels_df =
    PredictMD.split_data(features_df,labels_df,0.7);

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
    PredictMD.set_feature_contrasts!(epsilonsvr_svmreg , feature_contrasts)
    # Train epsilon-SVR model on training set
    PredictMD.fit!(epsilonsvr_svmreg,training_features_df,traininglabels_df,)
end

# Plot true values versus predicted values for epsilon-SVR on training set
epsilonsvr_svmreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    epsilonsvr_svmreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Plot true values versus predicted values for epsilon-SVR on testing set
epsilonsvr_svmreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    epsilonsvr_svmreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

# Evaluate performance of epsilon-SVR on training set
PredictMD.singlelabelregressionmetrics(
    epsilonsvr_svmreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Evaluate performance of epsilon-SVR on testing set
PredictMD.singlelabelregressionmetrics(
    epsilonsvr_svmreg,
    testing_features_df,
    testing_labels_df,
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
    PredictMD.set_feature_contrasts!(nusvr_svmreg , feature_contrasts)
    # Train nu-SVR model
    PredictMD.fit!(nusvr_svmreg,training_features_df,traininglabels_df,)
end

# Plot true values versus predicted values for nu-SVR on training set
nusvr_svmreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    nusvr_svmreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Plot true values versus predicted values for nu-SVR on testing set
nusvr_svmreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    nusvr_svmreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

# Evaluate performance of nu-SVR on training set
PredictMD.singlelabelregressionmetrics(
    nusvr_svmreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Evaluate performance of nu-SVR on testing set
PredictMD.singlelabelregressionmetrics(
    nusvr_svmreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

if save_trained
    PredictMD.save(epsilonsvr_svmreg_filename, epsilonsvr_svmreg)
    PredictMD.save(nusvr_svmreg_filename, nusvr_svmreg)
end

# We can use the PredictMD.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
PredictMD.predict(epsilonsvr_svmreg,training_features_df)
PredictMD.predict(nusvr_svmreg,training_features_df)

# Get real-valued predictions from each model for testing set
PredictMD.predict(epsilonsvr_svmreg,testing_features_df)
PredictMD.predict(nusvr_svmreg,testing_features_df)
