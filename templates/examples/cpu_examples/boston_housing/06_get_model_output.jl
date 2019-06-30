## %PREDICTMD_GENERATED_BY%

import PredictMDExtra
import PredictMD

### Begin project-specific settings

LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES = homedir()

PROJECT_OUTPUT_DIRECTORY = joinpath(
    LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
    "cpu_examples",
    "boston_housing",
    "output",
    )

mkpath(PROJECT_OUTPUT_DIRECTORY)
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "data"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "models"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "plots"))

# PREDICTMD IF INCLUDE TEST STATEMENTS
@debug("PROJECT_OUTPUT_DIRECTORY: ", PROJECT_OUTPUT_DIRECTORY,)
if PredictMD.is_travis_ci()
    PredictMD.cache_to_path!(
        ;
        from = ["cpu_examples", "boston_housing", "output",],
        to = [
            LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
            "cpu_examples", "boston_housing", "output",],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End project-specific settings

### Begin model output code

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_labels_df.csv",
    )
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
trainingandtuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )
testing_features_df = DataFrames.DataFrame(
    FileIO.load(
        testing_features_df_filename;
        type_detect_rows = 100,
        )
    )
testing_labels_df = DataFrames.DataFrame(
    FileIO.load(
        testing_labels_df_filename;
        type_detect_rows = 100,
        )
    )
training_features_df = DataFrames.DataFrame(
    FileIO.load(
        training_features_df_filename;
        type_detect_rows = 100,
        )
    )
training_labels_df = DataFrames.DataFrame(
    FileIO.load(
        training_labels_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )

linear_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "linear_regression.jld2",
    )
random_forest_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "random_forest_regression.jld2",
    )
knet_mlp_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "knet_mlp_regression.jld2",
    )

linear_regression =
    PredictMD.load_model(linear_regression_filename)
random_forest_regression =
    PredictMD.load_model(random_forest_regression_filename)
knet_mlp_regression =
    PredictMD.load_model(knet_mlp_regression_filename)
PredictMD.parse_functions!(knet_mlp_regression)

PredictMD.predict(linear_regression,training_features_df,)
PredictMD.predict(random_forest_regression,training_features_df,)
PredictMD.predict(knet_mlp_regression,training_features_df,)

PredictMD.predict(linear_regression,testing_features_df,)
PredictMD.predict(random_forest_regression,testing_features_df,)
PredictMD.predict(knet_mlp_regression,testing_features_df,)

### End model output code

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.path_to_cache!(
        ;
        to = ["cpu_examples", "boston_housing", "output",],
        from = [
            LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
            "cpu_examples", "boston_housing", "output",],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

## %PREDICTMD_GENERATED_BY%
