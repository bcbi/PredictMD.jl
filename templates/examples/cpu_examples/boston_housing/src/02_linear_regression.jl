## %PREDICTMD_GENERATED_BY%

import PredictMDExtra
PredictMDExtra.import_all()

import PredictMD
PredictMD.import_all()

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

### Begin linear regression code

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

categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
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

# PREDICTMD IF INCLUDE TEST STATEMENTS
Test.@test(
    PredictMD.columns_are_linearly_independent(training_features_df)
    )
Test.@test(
    PredictMD.columns_are_linearly_independent(
        training_features_df,
        feature_names,
        )
    )
Test.@test(
    length(PredictMD.linearly_dependent_columns(df)) == 0
    )
Test.@test(
    length(
        PredictMD.linearly_dependent_columns(
            training_features_df,
            feature_names,
            ),
        ) == 0
    )
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

show(
    logger_stream, PredictMD.linearly_dependent_columns(df)
    )

show(
    logger_stream, PredictMD.linearly_dependent_columns(
        training_features_df,
        feature_names,
        )
    )

linear_regression = PredictMD.single_labeldataframelinearregression(
    feature_names,
    single_label_name;
    package = :GLM,
    intercept = true,
    interactions = 1,
    name = "Linear regression",
    )

PredictMD.fit!(linear_regression,training_features_df,training_labels_df) # TODO: fix this error

PredictMD.get_underlying(linear_regression) # TODO: fix this error

linear_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted( # TODO: fix this error
        linear_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "linear_regression_plot_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, linear_regression_plot_training)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(linear_regression_plot_training)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "linear_regression_plot_training.pdf",
        ),
    linear_regression_plot_training,
    )

linear_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        linear_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "linear_regression_plot_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, linear_regression_plot_testing)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(linear_regression_plot_testing)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "linear_regression_plot_testing.pdf",
        ),
    linear_regression_plot_testing,
    )

show(
    logger_stream, PredictMD.singlelabelregressionmetrics(
        linear_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

show(
    logger_stream, PredictMD.singlelabelregressionmetrics(
        linear_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

linear_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "linear_regression.jld2",
    )

PredictMD.save_model(linear_regression_filename, linear_regression)

# PREDICTMD IF INCLUDE TEST STATEMENTS
linear_regression_filename_bson = joinpath(
    PredictMD.maketempdir(),
    "linear_regression.bson",
    )
PredictMD.save_model(
    linear_regression_filename_bson,
    linear_regression,
    )
test_load_bson = PredictMD.load_model(
    linear_regression_filename_bson,
    )
Test.@test_throws(
    ErrorException,
    PredictMD.save_model("test.nonexistentextension", linear_regression)
    )
Test.@test_throws(
    ErrorException,
    PredictMD.save_model_jld2("test.nonexistentextension", linear_regression)
    )
Test.@test_throws(
    ErrorException,
    PredictMD.save_model_bson("test.nonexistentextension", linear_regression)
    )
Test.@test_throws(
    ErrorException,
    PredictMD.load_model("test.nonexistentextension")
    )
Test.@test_throws(
    ErrorException,
    PredictMD.load_model_jld2("test.nonexistentextension")
    )
Test.@test_throws(
    ErrorException,
    PredictMD.load_model_bson("test.nonexistentextension")
    )
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End linear regression code

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
