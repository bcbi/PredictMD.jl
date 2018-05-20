
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

randomforestreg_filename = "./randomforestreg.jld2";

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

# Set up random forest regression model
randomforestreg = PredictMD.singlelabeldataframerandomforestregression(
    featurenames,
    labelname;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )

if load_pretrained
    PredictMD.load!(randomforestreg_filename, randomforestreg)
else
    # set feature contrasts
    PredictMD.set_feature_contrasts!(randomforestreg , feature_contrasts)
    # Train random forest model on training set
    PredictMD.fit!(randomforestreg,training_features_df,traininglabels_df,)
end

# Plot true values versus predicted values for random forest on training set
randomforestreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    randomforestreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Plot true values versus predicted values for random forest on testing set
randomforestreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    randomforestreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

# Evaluate performance of random forest on training set
PredictMD.singlelabelregressionmetrics(
    randomforestreg,
    training_features_df,
    traininglabels_df,
    labelname,
    )

# Evaluate performance of random forest on testing set
PredictMD.singlelabelregressionmetrics(
    randomforestreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

if save_trained
    PredictMD.save(randomforestreg_filename, randomforestreg)
end

# We can use the PredictMD.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
PredictMD.predict(randomforestreg,training_features_df)

# Get real-valued predictions from each model for testing set
PredictMD.predict(randomforestreg,testing_features_df)


