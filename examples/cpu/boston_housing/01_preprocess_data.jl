srand(999)

import CSV
import DataFrames
import GZip
import PredictMD
import StatsBase

df = CSV.read(
    GZip.gzopen(
        joinpath(
            Pkg.dir("RDatasets"),
            "data",
            "MASS",
            "Boston.csv.gz",
            ),
        ),
    DataFrames.DataFrame,
    )

DataFrames.dropmissing!(df)

PredictMD.shuffle_rows!(df)

categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
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
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)

singlelabelname = :MedV
labelnames = [singlelabelname]

features_df = df[featurenames]
labels_df = df[labelnames]

DataFrames.describe(labels_df[singlelabelname])

trainingandvalidation_features_df,
    trainingandvalidation_labels_df,
    testing_features_df,
    testing_labels_df = PredictMD.split_data(
        features_df,
        labels_df,
        0.75, 
        )
training_features_df,
    training_labels_df,
    validation_features_df,
    validation_labels_df = PredictMD.split_data(
        trainingandvalidation_features_df,
        trainingandvalidation_labels_df,
        2/3, 
        )

mkpath(
    joinpath(
        tempdir(),
        "boston_housing_example",
        ),
    )

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "validation_labels_df.csv",
    )
CSV.write(
    trainingandvalidation_features_df_filename,
    trainingandvalidation_features_df,
    )
CSV.write(
    trainingandvalidation_labels_df_filename,
    trainingandvalidation_labels_df,
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
    validation_features_df_filename,
    validation_features_df,
    )
CSV.write(
    validation_labels_df_filename,
    validation_labels_df,
    )
