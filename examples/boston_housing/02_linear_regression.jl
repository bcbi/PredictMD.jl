srand(999)

import CSV
import DataFrames
import PredictMD

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
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
training_features_df = CSV.read(
    training_features_df_filename,
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

linear_regression_filename = joinpath(
    tempdir(),
    "linear_regression.jld2",
    )

linear_regression = PredictMD.singlelabeldataframelinearregression(
    featurenames,
    singlelabelname;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    interactions = 2, # optional, defaults to 1
    name = "Linear regression", # optional
    )

PredictMD.fit!(linear_regression,training_features_df,training_labels_df,)

PredictMD.get_underlying(linear_regression)

linear_regression_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linear_regression,
    training_features_df,
    training_labels_df,
    singlelabelname,
    )
PredictMD.open_plot(linear_regression_plot_training)

linear_regression_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linear_regression,
    testing_features_df,
    testing_labels_df,
    singlelabelname
    )
PredictMD.open_plot(linear_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    linear_regression,
    training_features_df,
    training_labels_df,
    singlelabelname,
    )

PredictMD.singlelabelregressionmetrics(
    linear_regression,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    )

PredictMD.save_model(linear_regression_filename, linear_regression)
