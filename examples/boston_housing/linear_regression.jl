srand(999)

import PredictMD
import CSV
import DataFrames

trainingandvalidation_features_df_filename =
    ENV["trainingandvalidation_features_df_filename"]
trainingandvalidation_labels_df_filename =
    ENV["trainingandvalidation_labels_df_filename"]
testing_features_df_filename =
    ENV["testing_features_df_filename"]
testing_labels_df_filename =
    ENV["testing_labels_df_filename"]
training_features_df_filename =
    ENV["training_features_df_filename"]
training_labels_df_filename =
    ENV["training_labels_df_filename"]
validation_features_df_filename =
    ENV["validation_features_df_filename"]
validation_labels_df_filename =
    ENV["validation_labels_df_filename"]
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

ENV["linear_regression_filename"] = string(
    tempname(),
    "_linear_regression.jld2",
    )
Base.Test.@test(!isfile(ENV["linear_regression_filename"]))
linear_regression_filename = ENV["linear_regression_filename"]

linear_regression = PredictMD.singlelabeldataframelinear_regressionression(
    featurenames,
    labelname;
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
    labelname,
    )
PredictMD.open_plot(linear_regression_plot_training)

linear_regression_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    linear_regression,
    testing_features_df,
    testing_labels_df,
    labelname
    )
PredictMD.open_plot(linear_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    linear_regression,
    training_features_df,
    training_labels_df,
    labelname,
    )

PredictMD.singlelabelregressionmetrics(
    linear_regression,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

PredictMD.save_model(linear_regression_filename, linear_regression)
