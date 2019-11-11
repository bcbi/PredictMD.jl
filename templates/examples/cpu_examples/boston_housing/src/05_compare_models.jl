## %PREDICTMD_GENERATED_BY%

import PredictMDExtra
PredictMDExtra.import_all()

import PredictMD
PredictMD.import_all()

# PREDICTMD IF INCLUDE TEST STATEMENTS
import CSVFiles
import DataFrames
import FileIO
import RDatasets
import Random
import Test
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

# PREDICTMD IF INCLUDE TEST STATEMENTS
logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if isnothing(logger)
    logger_stream = devnull
else
    logger_stream = logger.stream
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### Begin project-specific settings

DIRECTORY_CONTAINING_THIS_FILE = @__DIR__
PROJECT_DIRECTORY = dirname(
    joinpath(splitpath(DIRECTORY_CONTAINING_THIS_FILE)...)
    )
PROJECT_OUTPUT_DIRECTORY = joinpath(
    PROJECT_DIRECTORY,
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
        to = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End project-specific settings

### Begin model comparison code

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

# PREDICTMD IF INCLUDE TEST STATEMENTS
linear_regression = nothing
Test.@test isnothing(linear_regression)

random_forest_regression = nothing
Test.@test isnothing(random_forest_regression)

knet_mlp_regression = nothing
Test.@test isnothing(knet_mlp_regression)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

linear_regression =
    PredictMD.load_model(linear_regression_filename)
random_forest_regression =
    PredictMD.load_model(random_forest_regression_filename)
knet_mlp_regression =
    PredictMD.load_model(knet_mlp_regression_filename)

PredictMD.parse_functions!(linear_regression)
PredictMD.parse_functions!(random_forest_regression)
PredictMD.parse_functions!(knet_mlp_regression)

# PREDICTMD IF INCLUDE TEST STATEMENTS
PredictMD.parse_functions!(linear_regression)
PredictMD.parse_functions!(random_forest_regression)
PredictMD.parse_functions!(knet_mlp_regression)

PredictMD.parse_functions!(linear_regression)
PredictMD.parse_functions!(random_forest_regression)
PredictMD.parse_functions!(knet_mlp_regression)

PredictMD.parse_functions!(linear_regression)
PredictMD.parse_functions!(random_forest_regression)
PredictMD.parse_functions!(knet_mlp_regression)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

all_models = PredictMD.AbstractFittable[
    linear_regression,
    random_forest_regression,
    knet_mlp_regression,
    ]

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

println(logger_stream, "Single label regression metrics, training set: ")
show(
    logger_stream, PredictMD.singlelabelregressionmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(logger_stream, "Single label regression metrics, testing set: ")
show(
    logger_stream, PredictMD.singlelabelregressionmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

### End model comparison code

# PREDICTMD IF INCLUDE TEST STATEMENTS
metrics = PredictMD.singlelabelregressionmetrics(all_models,
                                                 testing_features_df,
                                                 testing_labels_df,
                                                 single_label_name)
r2_row = first(
    findall(
        strip.(metrics[:metric]) .== "R^2 (coefficient of determination)"
        )
    )
Test.@test(
    strip(metrics[r2_row, :metric]) == "R^2 (coefficient of determination)"
    )
Test.@test(
    metrics[r2_row, Symbol("Linear regression")] > 0.550
    )
Test.@test(
    metrics[r2_row, Symbol("Random forest")] > 0.550
    )
Test.@test(
    metrics[r2_row, Symbol("Knet MLP")] > 0.300
    )
mse_row = first(
    findall(
        strip.(metrics[:metric]) .== "Mean squared error (MSE)"
        )
    )
Test.@test(
    strip(metrics[mse_row, :metric]) == "Mean squared error (MSE)"
    )
Test.@test(
    metrics[mse_row, Symbol("Linear regression")] < 40.000
    )
Test.@test(
    metrics[mse_row, Symbol("Random forest")] < 40.000
    )
Test.@test(
    metrics[mse_row, Symbol("Knet MLP")] < 65.000
    )
rmse_row = first(
    findall(
        strip.(metrics[:metric]) .== "Root mean square error (RMSE)"
        )
    )
Test.@test(
    strip(metrics[rmse_row, :metric]) == "Root mean square error (RMSE)"
    )
Test.@test(
    metrics[rmse_row, Symbol("Linear regression")] < 6.500
    )
Test.@test(
    metrics[rmse_row, Symbol("Random forest")] < 6.500
    )
Test.@test(
    metrics[rmse_row, Symbol("Knet MLP")] < 8.000
    )
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.path_to_cache!(
        ;
        to = ["cpu_examples", "boston_housing", "output",],
        from = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

## %PREDICTMD_GENERATED_BY%
