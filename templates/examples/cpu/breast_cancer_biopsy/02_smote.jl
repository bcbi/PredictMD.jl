##### Beginning of file

error(string("This file is not meant to be run. Use the `PredictMD.generate_examples()` function to generate examples that you can run."))

%PREDICTMD_GENERATED_BY%

import PredictMD

### Begin project-specific settings

PredictMD.require_julia_version("%PREDICTMD_MINIMUM_REQUIRED_JULIA_VERSION%")

PredictMD.require_predictmd_version("%PREDICTMD_CURRENT_VERSION%")

## PredictMD.require_predictmd_version("%PREDICTMD_CURRENT_VERSION%", "%PREDICTMD_NEXT_MINOR_VERSION%")

PROJECT_OUTPUT_DIRECTORY = PredictMD.project_directory(
    homedir(),
    "Desktop",
    "breast_cancer_biopsy_example",
    )

### End project-specific settings

### Begin SMOTE class-balancing code

# BEGIN TEST STATEMENTS
import Test
# END TEST STATEMENTS

import Pkg

try Pkg.add("CSV") catch end
try Pkg.add("DataFrames") catch end
try Pkg.add("FileIO") catch end
try Pkg.add("JLD2") catch end
try Pkg.add("StatsBase") catch end

import CSV
import DataFrames
import FileIO
import JLD2
import Random
import StatsBase

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandtuning_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "training_labels_df.csv",
    )
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = CSV.read(
    trainingandtuning_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
trainingandtuning_labels_df = CSV.read(
    trainingandtuning_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
testing_features_df = CSV.read(
    testing_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
testing_labels_df = CSV.read(
    testing_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
training_features_df = CSV.read(
    training_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
training_labels_df = CSV.read(
    training_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
tuning_features_df = CSV.read(
    tuning_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
tuning_labels_df = CSV.read(
    tuning_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )

categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "continuous_feature_names.jld2",
    )
categorical_feature_names = FileIO.load(
    categorical_feature_names_filename,
    "categorical_feature_names",
    )
continuous_feature_names = FileIO.load(
    continuous_feature_names_filename,
    "continuous_feature_names",
    )
feature_names = vcat(categorical_feature_names, continuous_feature_names)

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"
single_label_levels = [negative_class, positive_class]

categorical_label_names = Symbol[single_label_name]
continuous_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

DataFrames.describe(training_labels_df[single_label_name])
StatsBase.countmap(training_labels_df[single_label_name])

majorityclass = "benign"
minorityclass = "malignant"

(smoted_training_features_df, smoted_training_labels_df,) = PredictMD.smote(
    training_features_df,
    training_labels_df,
    feature_names,
    single_label_name;
    majorityclass = majorityclass,
    minorityclass = minorityclass,
    pct_over = 100,
    minority_to_majority_ratio = 1.0,
    k = 5,
    )

PredictMD.check_column_types(
    smoted_training_features_df;
    categorical_feature_names = categorical_feature_names,
    continuous_feature_names = continuous_feature_names,
    categorical_label_names = categorical_label_names,
    continuous_label_names = continuous_label_names,
    )
PredictMD.check_column_types(
    smoted_training_labels_df;
    categorical_feature_names = categorical_feature_names,
    continuous_feature_names = continuous_feature_names,
    categorical_label_names = categorical_label_names,
    continuous_label_names = continuous_label_names,
    )
PredictMD.check_no_constant_columns(smoted_training_features_df)
PredictMD.check_no_constant_columns(smoted_training_labels_df)

DataFrames.describe(smoted_training_labels_df[single_label_name])
StatsBase.countmap(smoted_training_labels_df[single_label_name])

smoted_training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
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

### End SMOTE class-balancing code

##### End of file
