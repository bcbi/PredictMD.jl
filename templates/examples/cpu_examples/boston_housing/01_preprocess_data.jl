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

### Begin data preprocessing code

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
    "data",
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "continuous_feature_names.jld2",
    )
@info("", categorical_feature_names_filename)
@info("", isfile(categorical_feature_names_filename))
@info("", dirname(categorical_feature_names_filename))
@info("", isdir(dirname(categorical_feature_names_filename)))
@info("", joinpath(PROJECT_OUTPUT_DIRECTORY, "data"))
@info("", isdir(joinpath(PROJECT_OUTPUT_DIRECTORY, "data")))
@info("", PROJECT_OUTPUT_DIRECTORY)
@info("", isdir(PROJECT_OUTPUT_DIRECTORY))

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
        to = ["cpu_examples", "boston_housing", "output",],
        from = [
            LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
            "cpu_examples", "boston_housing", "output",],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS
