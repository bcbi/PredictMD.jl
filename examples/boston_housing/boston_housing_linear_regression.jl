
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

# D&S What are we doing here???
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

# Set up linear regression model
linearreg = asb.singlelabeldataframelinearregression(
    featurenames,
    labelname;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Linear regression", # optional
    )

if load_pretrained
    asb.load!(linearreg_filename, linearreg)
else
    # set feature contrasts
    asb.setfeaturecontrasts!(linearreg, featurecontrasts)
    # Train linear regression model
    asb.fit!(linearreg,trainingfeaturesdf,traininglabelsdf,)
end

# View coefficients, p values, etc. for underlying linear regression
asb.getunderlying(linearreg)

# Plot true values versus predicted values for linear regression on training set
linearreg_plot_training = asb.plotsinglelabelregressiontrueversuspredicted(
    linearreg,
    trainingfeaturesdf,
    traininglabelsdf,
    labelname,
    )
# asb.open(linearreg_plot_training)

# Plot true values versus predicted values for linear regression on testing set
linearreg_plot_testing = asb.plotsinglelabelregressiontrueversuspredicted(
    linearreg,
    testingfeaturesdf,
    testinglabelsdf,
    labelname
    )
# asb.open(linearreg_plot_testing)

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

if save_trained
    asb.save(linearreg_filename, linearreg)
end

# We can use the asb.predict() function to get the real-valued predictions
# output by each of regression models.

# Get real-valued predictions from each model for training set
asb.predict(linearreg,trainingfeaturesdf,)

# Get real-valued predictions from each model for testing set
asb.predict(linearreg,testingfeaturesdf,)
