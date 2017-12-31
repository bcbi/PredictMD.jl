import AluthgeSinhaBase
const asb = AluthgeSinhaBase
import DataFrames
import RDatasets
import StatsBase

# Import breast cancer biopsy data
df = RDatasets.dataset("MASS", "biopsy")

# Remove rows with missing data
DataFrames.dropmissing!(df)

# Shuffle the rows
asb.shufflerows!(df)

# Define features and labels
categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
    :V1,
    :V2,
    :V3,
    :V4,
    :V5,
    :V6,
    :V7,
    :V8,
    :V9,
    ]
featurenames = vcat(
    categoricalfeaturenames,
    continuousfeaturenames,
    )
singlelabelname = :Class
negativeclass = "benign"
positiveclass = "malignant"
levels = [negativeclass, positiveclass]
labelnames = [singlelabelname]

# Examine the counts of each level
StatsBase.countmap(df[singlelabelname])

# Put the features and labels in separate dataframes
featuresdf = df[featurenames]
labelsdf = df[labelnames]

# Split the data into training set (70%) and testing set (30%)
trainingfeaturesdf,
    testingfeaturesdf,
    traininglabelsdf,
    testinglabelsdf = asb.train_test_split(
        featuresdf,
        labelsdf;
        training = 0.7,
        testing = 0.3,
        )

# Set up and train a binary logistic classifier
logistic = asb.binarylogisticclassifier(
    featurenames,
    singlelabelname,
    positiveclass;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    name = "Logistic classifier", # optional
    )
asb.fit!(
    logistic,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# Evaluate the performance of the logistic on the testing set
asb.binaryclassificationmetrics(
    logistic,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass;
    sensitivity = 0.99,
    )

# Set up and train a random forest
randomforest = asb.randomforestclassifier(
    featurenames,
    singlelabelname,
    levels,
    trainingfeaturesdf;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest classifier" # optional
    )
asb.fit!(
    randomforest,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# Evaluate the performance of the random forest on the testing set
asb.binaryclassificationmetrics(
    randomforest,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass;
    sensitivity = 0.99,
    )

# Set up and train an SVM
svm = asb.svmclassifier(
    featurenames,
    singlelabelname,
    levels,
    trainingfeaturesdf;
    package = :LIBSVMjl,
    name = "SVM classifier",
    )
asb.fit!(
    svm,
    trainingfeaturesdf,
    traininglabelsdf,
    )
# # Evaluate the performance of the SVM on the testing set
asb.binaryclassificationmetrics(
    svm,
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass;
    sensitivity = 0.99,
    )

# # Set up and train a multilayer perceptron (i.e. a fully connected feedforward neural network)
# knetmlp = asb.XXXXXXrandomforestclassifierXXXXX(
#     featurenames,
#     singlelabelname,
#     levels,
#     trainingfeaturesdf;
#     XXXXXnsubfeatures = 2, # number of subfeatures; defaults to 2
#     XXXXXntrees = 20, # number of trees; defaults to 10
#     package = :Knetjl,
#     name = "XXXXXlayerneuralnetwork" # optional
#     )
# asb.fit!(
#     knetmlp,
#     trainingfeaturesdf,
#     traininglabelsdf,
#     )
# # Evaluate the performance of the multilayer perceptron on the testing set
# asb.binaryclassificationmetrics(
#     knetmlp,
#     testingfeaturesdf,
#     testinglabelsdf,
#     singlelabelname,
#     positiveclass;
#     sensitivity = 0.99,
#     )


# Compare the performance of all four models on the testing set
showall(asb.binaryclassificationmetrics(
    [logistic, randomforest, svm],
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass;
    sensitivity = 0.99,
    ))

# Plot receiver operating characteristic curves for all four models
rocplot = asb.plotroccurves(
    [logistic, randomforest, svm],
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass,
    )
asb.open(rocplot)

# Plot precision-recall curves for all four models
prplot = asb.plotprcurves(
    [logistic, randomforest, svm],
    testingfeaturesdf,
    testinglabelsdf,
    singlelabelname,
    positiveclass,
    )
asb.open(prplot)
