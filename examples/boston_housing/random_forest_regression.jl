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

ENV["random_forest_regression_filename"] = string(
    tempname(),
    "_random_forest_regression.jld2",
    )
Base.Test.@test(!isfile(ENV["random_forest_regression_filename"]))
random_forest_regression_filename = ENV["random_forest_regression_filename"]

random_forest_regression = PredictMD.singlelabeldataframerandom_forest_regressionression(
    featurenames,
    labelname;
    nsubfeatures = 2, # number of subfeatures; defaults to 2
    ntrees = 20, # number of trees; defaults to 10
    package = :DecisionTreejl,
    name = "Random forest", # optional
    feature_contrasts = feature_contrasts,
    )

PredictMD.fit!(random_forest_regression,training_features_df,training_labels_df,)

random_forest_regression_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    random_forest_regression,
    training_features_df,
    training_labels_df,
    labelname,
    )
PredictMD.open_plot(random_forest_regression_plot_training)

random_forest_regression_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    random_forest_regression,
    testing_features_df,
    testing_labels_df,
    labelname,
    )
PredictMD.open_plot(random_forest_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    random_forest_regression,
    training_features_df,
    training_labels_df,
    labelname,
    )

PredictMD.singlelabelregressionmetrics(
    random_forest_regression,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

PredictMD.save_model(random_forest_regression_filename, random_forest_regression)
