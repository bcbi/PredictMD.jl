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
    "boston_housing_example",
    )

### End project-specific settings

### Begin data preprocessing code

# BEGIN TEST STATEMENTS
import Test
# END TEST STATEMENTS

import Pkg

try Pkg.add("CSV") catch end
try Pkg.add("CSVFiles") catch end
try Pkg.add("DataFrames") catch end
try Pkg.add("FileIO") catch end
try Pkg.add("GZip") catch end
try Pkg.add("JLD2") catch end
try Pkg.add("RDatasets") catch end
try Pkg.add("StatsBase") catch end

import CSV
import CSVFiles
import DataFrames
import FileIO
import GZip
import JLD2
import RDatasets
import Random
import StatsBase

Random.seed!(999)

df = DataFrames.DataFrame(
    CSVFiles.load(
        CSVFiles.Stream(
            CSVFiles.format"CSV",
            GZip.gzopen(
                joinpath(
                    dirname(pathof(RDatasets)),
                    "..",
                    "data",
                    "MASS",
                    "Boston.csv.gz",
                    )
                ),
            ),
        ),
    )

categorical_feature_names = Symbol[]
continuous_feature_names = Symbol[
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
categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "continuous_feature_names.jld2",
    )
FileIO.save(
    categorical_feature_names_filename,
    "categorical_feature_names",
    categorical_feature_names,
    )
FileIO.save(
    continuous_feature_names_filename,
    "continuous_feature_names",
    continuous_feature_names,
    )
feature_names = vcat(categorical_feature_names, continuous_feature_names)

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

df = df[:, vcat(feature_names, label_names)]
DataFrames.dropmissing!(df)
PredictMD.shuffle_rows!(df)

PredictMD.fix_column_types!(
    df;
    categorical_feature_names = categorical_feature_names,
    continuous_feature_names = continuous_feature_names,
    categorical_label_names = categorical_label_names,
    continuous_label_names = continuous_label_names,
    )
PredictMD.check_column_types(
    df;
    categorical_feature_names = categorical_feature_names,
    continuous_feature_names = continuous_feature_names,
    categorical_label_names = categorical_label_names,
    continuous_label_names = continuous_label_names,
    )
PredictMD.check_no_constant_columns(df)

features_df = df[feature_names]
labels_df = df[label_names]

DataFrames.describe(labels_df[single_label_name])

(trainingandtuning_features_df,
    trainingandtuning_labels_df,
    testing_features_df,
    testing_labels_df,) = PredictMD.split_data(
        features_df,
        labels_df,
        0.75,
        )
(training_features_df,
    training_labels_df,
    tuning_features_df,
    tuning_labels_df,) = PredictMD.split_data(
        trainingandtuning_features_df,
        trainingandtuning_labels_df,
        2/3,
        )

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
CSV.write(
    trainingandtuning_features_df_filename,
    trainingandtuning_features_df,
    )
CSV.write(
    trainingandtuning_labels_df_filename,
    trainingandtuning_labels_df,
    )
CSV.write(
    testing_features_df_filename,
    testing_features_df,
    )
CSV.write(
    testing_labels_df_filename,
    testing_labels_df,
    )
CSV.write(
    training_features_df_filename,
    training_features_df,
    )
CSV.write(
    training_labels_df_filename,
    training_labels_df,
    )
CSV.write(
    tuning_features_df_filename,
    tuning_features_df,
    )
CSV.write(
    tuning_labels_df_filename,
    tuning_labels_df,
    )

### End data preprocessing code

##### End of file
