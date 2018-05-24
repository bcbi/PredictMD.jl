srand(999)

import CSV
import DataFrames
import Knet
import PredictMD

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
trainingandvalidation_features_df = CSV.read(
    trainingandvalidation_features_df_filename,
    DataFrames.DataFrame,
    )
trainingandvalidation_labels_df = CSV.read(
    trainingandvalidation_labels_df_filename,
    DataFrames.DataFrame,
    )
testing_features_df = CSV.read(
    testing_features_df_filename,
    DataFrames.DataFrame,
    )
testing_labels_df = CSV.read(
    testing_labels_df_filename,
    DataFrames.DataFrame,
    )
training_features_df = CSV.read(
    training_features_df_filename,
    DataFrames.DataFrame,
    )
training_labels_df = CSV.read(
    training_labels_df_filename,
    DataFrames.DataFrame,
    )
validation_features_df = CSV.read(
    validation_features_df_filename,
    DataFrames.DataFrame,
    )
validation_labels_df = CSV.read(
    validation_labels_df_filename,
    DataFrames.DataFrame,
    )

linear_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "linear_regression.jld2",
    )
random_forest_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "random_forest_regression.jld2",
    )
knet_mlp_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "knet_mlp_regression.jld2",
    )

linear_regression = PredictMD.load_model(linear_regression_filename)
random_forest_regression = PredictMD.load_model(random_forest_regression_filename)
knet_mlp_regression = PredictMD.load_model(knet_mlp_regression_filename)
PredictMD.parse_functions!(knet_mlp_regression)

all_models = PredictMD.Fittable[
    linear_regression,
    random_forest_regression,
    knet_mlp_regression,
    ]

singlelabelname = :MedV

showall(PredictMD.singlelabelregressionmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    ))

showall(PredictMD.singlelabelregressionmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    ))

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

