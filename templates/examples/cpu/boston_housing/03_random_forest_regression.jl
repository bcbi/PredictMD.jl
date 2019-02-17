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

# BEGIN TEST STATEMENTS
@debug("PROJECT_OUTPUT_DIRECTORY: ", PROJECT_OUTPUT_DIRECTORY,)
if PredictMD.is_travis_ci()
    PredictMD.cache_to_homedir!("Desktop", "boston_housing_example",)
end
# END TEST STATEMENTS

### End project-specific settings

### Begin random forest regression code

# BEGIN TEST STATEMENTS
import Test
# END TEST STATEMENTS

import Pkg

try Pkg.add("CSV") catch end
try Pkg.add("DataFrames") catch end
try Pkg.add("FileIO") catch end
try Pkg.add("JLD2") catch end
try Pkg.add("PGFPlotsX") catch end

import CSV
import DataFrames
import FileIO
import JLD2
import PGFPlotsX
import Random

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

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

feature_contrasts = PredictMD.generate_feature_contrasts(
    training_features_df,
    feature_names,
    )

random_forest_regression =
    PredictMD.single_labeldataframerandomforestregression(
        feature_names,
        single_label_name;
        nsubfeatures = 2,
        ntrees = 20,
        package = :DecisionTree,
        name = "Random forest",
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(
    random_forest_regression,
    training_features_df,
    training_labels_df,
    )

random_forest_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        random_forest_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "random_forest_regression_plot_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, random_forest_regression_plot_training)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(random_forest_regression_plot_training)

random_forest_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        random_forest_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "random_forest_regression_plot_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, random_forest_regression_plot_testing)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(random_forest_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    random_forest_regression,
    training_features_df,
    training_labels_df,
    single_label_name,
    )

PredictMD.singlelabelregressionmetrics(
    random_forest_regression,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    )

random_forest_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "random_forest_regression.jld2",
    )

PredictMD.save_model(
    random_forest_regression_filename,
    random_forest_regression
    )

### End random forest regression code

# BEGIN TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.homedir_to_cache!("Desktop", "boston_housing_example",)
end
# END TEST STATEMENTS

##### End of file
