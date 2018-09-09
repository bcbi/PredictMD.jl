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

### Begin linear regression code

import Pkg

Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("FileIO")
Pkg.add("JLD2")
Pkg.add("PGFPlotsX")

import CSV
import DataFrames
import FileIO
import JLD2
import PGFPlotsX
import Random

Random.seed!(999)

trainingandvalidation_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandvalidation_labels_df.csv",
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
validation_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "validation_labels_df.csv",
    )
trainingandvalidation_features_df = CSV.read(
    trainingandvalidation_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
trainingandvalidation_labels_df = CSV.read(
    trainingandvalidation_labels_df_filename,
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
validation_features_df = CSV.read(
    validation_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
validation_labels_df = CSV.read(
    validation_labels_df_filename,
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

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

linear_regression = PredictMD.single_labeldataframelinearregression(
    feature_names,
    single_label_name;
    package = :GLM,
    intercept = true,
    interactions = 1,
    name = "Linear regression",
    )

PredictMD.fit!(linear_regression,training_features_df,training_labels_df,)

PredictMD.get_underlying(linear_regression)

linear_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        linear_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempfile(),
    "_",
    "linear_regression_plot_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, linear_regression_plot_training)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(linear_regression_plot_training)

linear_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        linear_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempfile(),
    "_",
    "linear_regression_plot_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, linear_regression_plot_testing)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(linear_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    linear_regression,
    training_features_df,
    training_labels_df,
    single_label_name,
    )

PredictMD.singlelabelregressionmetrics(
    linear_regression,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    )

linear_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "linear_regression.jld2",
    )

PredictMD.save_model(linear_regression_filename, linear_regression)

### End linear regression code

##### End of file
