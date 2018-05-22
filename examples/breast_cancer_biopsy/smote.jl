srand(999)

import CSV
import DataFrames
import PredictMD
import StatsBase

trainingandvalidation_features_df_filename =
    ENV["trainingandvalidation_features_df_filename"]
trainingandvalidation_labels_df_filename =
    ENV["trainingandvalidation_labels_df_filename"]
testing_features_df_filename =
    ENV["testing_features_df_filename"]
testing_labels_df_filename =
    ENV["testing_labels_df_filename"]
training_features_df_filename =
    ENV["training_features_df_filename"]
training_labels_df_filename =
    ENV["training_labels_df_filename"]
validation_features_df_filename =
    ENV["validation_features_df_filename"]
validation_labels_df_filename =
    ENV["validation_labels_df_filename"]
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


DataFrames.describe(training_labels_df[labelname])
StatsBase.countmap(training_labels_df[labelname])

majorityclass = "benign"
minorityclass = "malignant"

smoted_training_features_df, smoted_training_labels_df = PredictMD.smote(
    training_features_df,
    training_labels_df,
    featurenames,
    labelname;
    majorityclass = majorityclass,
    minorityclass = minorityclass,
    pct_over = 100, # how much to oversample the minority class
    minority_to_majority_ratio = 1.0, # desired minority:majority ratio
    k = 5,
    )

DataFrames.describe(smoted_training_labels_df[labelname])
StatsBase.countmap(smoted_training_labels_df[labelname])

ENV["smoted_training_features_df_filename"] = string(
    tempname(),
    "_smoted_training_features_df.csv",
    )
ENV["smoted_training_labels_df_filename"] = string(
    tempname(),
    "_smoted_training_labels_df.csv",
    )
smoted_training_features_df_filename =
    ENV["smoted_training_features_df_filename"]
smoted_training_labels_df_filename =
    ENV["smoted_training_labels_df_filename"]
CSV.write(
    smoted_training_features_df_filename,
    smoted_training_features_df,
    )
CSV.write(
    smoted_training_labels_df_filename,
    smoted_training_labels_df,
    )
