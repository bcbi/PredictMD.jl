
# import required packages
import PredictMD
import CSV
import DataFrames
import GZip
import StatsBase

# set the seed of the global random number generator
# this makes the results reproducible
srand(999)

load_pretrained = false
save_trained = true

# load_pretrained = true
# save_trained = false

linearreg_filename = "./linearreg.jld2"
randomforestreg_filename = "./randomforestreg.jld2"
epsilonsvr_svmreg_filename = "./epsilonsvr_svmreg.jld2"
nusvr_svmreg_filename = "./nusvr_svmreg.jld2"
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

# Set up linear regression model
linearreg = PredictMD.singlelabeldataframelinearregression(
    featurenames,
    labelname;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Linear regression", # optional
    )

if load_pretrained
    PredictMD.load!(linearreg_filename, linearreg)
else
    # set feature contrasts
    PredictMD.set_feature_contrasts!(linearreg , feature_contrasts)
    # Train linear regression model
    PredictMD.fit!(linearreg,training_features_df,traininglabels_df,)
end

# View coefficients, p values, etc. for underlying linear regression
PredictMD.get_underlying(linearreg)

# Plot true values versus predicted values for linear regression on training set
linearreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linearreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )
# PredictMD.open(linearreg_plot_training)

# Plot true values versus predicted values for linear regression on testing set
linearreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linearreg,
    testing_features_df,
    testing_labels_df,
    labelname
    )
# PredictMD.open(linearreg_plot_testing)

# Evaluate performance of linear regression on training set
PredictMD.singlelabelregressionmetrics(
    linearreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Evaluate performance of linear regression on testing set
PredictMD.singlelabelregressionmetrics(
    linearreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

if save_trained
    PredictMD.save(linearreg_filename, linearreg)
end

# We can use the PredictMD.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
PredictMD.predict(linearreg,training_features_df,)

# Get real-valued predictions from each model for testing set
PredictMD.predict(linearreg,testing_features_df,)
