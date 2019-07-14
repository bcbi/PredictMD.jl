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
        from = ["cpu_examples", "breast_cancer_biopsy", "output",],
        to = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End project-specific settings

### Begin data preprocessing code

Random.seed!(999)

df = RDatasets.dataset("MASS", "biopsy")

## If your data are in a CSV file, load them with:
## df = DataFrames.DataFrame(CSVFiles.load("data.csv"; type_detect_rows = 10_000))

## If your data are in a gzipped CSV file, load them with:
## df = DataFrames.DataFrame(CSVFiles.load(CSVFiles.File(CSVFiles.format"CSV", "data.csv.gz"); type_detect_rows = 10_000))

# PREDICTMD IF INCLUDE TEST STATEMENTS
df1 = DataFrames.DataFrame()
df1[:x] = randn(5)
df1_filename = joinpath(PredictMD.maketempdir(), "df1.csv")
CSVFiles.save(df1_filename, df1)
df2 = DataFrames.DataFrame(CSVFiles.load(df1_filename; type_detect_rows = 10_000))
Test.@test( all(df1[:x] .== df2[:x]) )
df3 = DataFrames.DataFrame()
df3[:y] = randn(5)
df3_filename = joinpath(PredictMD.maketempdir(), "df3.csv.gz")
CSVFiles.save(CSVFiles.File(CSVFiles.format"CSV", df3_filename), df3)
df4 = DataFrames.DataFrame(CSVFiles.load(CSVFiles.File(CSVFiles.format"CSV", df3_filename); type_detect_rows = 10_000))
Test.@test( all(df3[:y] .== df4[:y]) )
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

categorical_feature_names = Symbol[]
continuous_feature_names = Symbol[
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

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"
single_label_levels = [negative_class, positive_class]

categorical_label_names = Symbol[single_label_name]
continuous_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

df = df[:, vcat(feature_names, label_names)]
DataFrames.dropmissing!(df; disallowmissing=true,)
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

# PREDICTMD IF INCLUDE TEST STATEMENTS
Test.@test PredictMD.check_no_constant_columns(df)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

features_df = df[feature_names]
labels_df = df[label_names]

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

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.path_to_cache!(
        ;
        to = ["cpu_examples", "breast_cancer_biopsy", "output",],
        from = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

## %PREDICTMD_GENERATED_BY%
