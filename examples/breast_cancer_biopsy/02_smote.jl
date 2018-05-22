srand(999)

import CSV
import DataFrames
import PredictMD
import StatsBase

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
    "validation_labels_df.csv",
    )
trainingandvalidation_features_df = CSV.read(
    trainingandvalidation_features_df_filename,
    DataFrames.DataFrame,
    )
trainingandvalidation_labels_df = CSV.read(
    trainingandvalidation_labels_df_filename,
    DataFrames.DataFrame,
    )
testing_features_df = CSV.read(
    testing_features_df_filename,
    DataFrames.DataFrame,
    )
testing_labels_df = CSV.read(
    testing_labels_df_filename,
    DataFrames.DataFrame,
    )
training_features_df = CSV.read(
    training_features_df_filename,
    DataFrames.DataFrame,
    )
training_features_df = CSV.read(
    training_features_df_filename,
    DataFrames.DataFrame,
    )
validation_features_df = CSV.read(
    validation_features_df_filename,
    DataFrames.DataFrame,
    )
validation_labels_df = CSV.read(
    validation_labels_df_filename,
    DataFrames.DataFrame,
    )

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
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)

singlelabelname = :Class
negativeclass = "benign"
positiveclass = "malignant"
singlelabellevels = [negativeclass, positiveclass]

DataFrames.describe(training_labels_df[singlelabelname])
StatsBase.countmap(training_labels_df[singlelabelname])

majorityclass = "benign"
minorityclass = "malignant"

smoted_training_features_df, smoted_training_labels_df = PredictMD.smote(
    training_features_df,
    training_labels_df,
    featurenames,
    singlelabelname;
    majorityclass = majorityclass,
    minorityclass = minorityclass,
    pct_over = 100, # how much to oversample the minority class
    minority_to_majority_ratio = 1.0, # desired minority:majority ratio
    k = 5,
    )

DataFrames.describe(smoted_training_labels_df[singlelabelname])
StatsBase.countmap(smoted_training_labels_df[singlelabelname])


smoted_training_features_df_filename = joinpath(
    tempdir(),
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    tempdir(),
    "smoted_training_labels_df.csv",
    )
CSV.write(
    smoted_training_features_df_filename,
    smoted_training_features_df,
    )
CSV.write(
    smoted_training_labels_df_filename,
    smoted_training_labels_df,
    )
