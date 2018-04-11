
# import required packages
import AluthgeSinhaBase
const asb = AluthgeSinhaBase
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

if load_pretrained
else
    featurecontrasts = asb.featurecontrasts(df, featurenames)
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
    asb.train_test_split(featuresdf,labelsdf;training = 0.7,testing = 0.3,);

# Set up random forest regression model
randomforestreg = asb.singlelabeldataframerandomforestregression(
    featurenames,
    labelname;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest" # optional
    )

if load_pretrained
    asb.load!(randomforestreg_filename, randomforestreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(randomforestreg, featurecontrasts)
    # Train random forest model on training set
    asb.fit!(randomforestreg,trainingfeaturesdf,traininglabelsdf,)
end

# Plot true values versus predicted values for random forest on training set
randomforestreg_plot_training = asb.plotsinglelabelregressiontrueversuspredicted(
    randomforestreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )

# Plot true values versus predicted values for random forest on testing set
randomforestreg_plot_testing = asb.plotsinglelabelregressiontrueversuspredicted(
    randomforestreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname,
    )

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

if save_trained
    asb.save(randomforestreg_filename, randomforestreg)
end

# We can use the asb.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
asb.predict(randomforestreg,trainingfeaturesdf)

# Get real-valued predictions from each model for testing set
asb.predict(randomforestreg,testingfeaturesdf)


