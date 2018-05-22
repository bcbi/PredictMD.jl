srand(999)

import PredictMD
import CSV
import DataFrames
import Knet

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

linear_regression_filename = ENV["linear_regression_filename"]
random_forest_regression_filename = ENV["random_forest_regression_filename"]
knetmlpreg_filename = ENV["knet_mlp_regression_filename"]

linearreg = PredictMD.load_model(linearreg_filename)
randomforestreg = PredictMD.load_model(randomforestreg_filename)
knetmlpreg = PredictMD.load_model(knetmlpreg_filename)

all_models = PredictMD.Fittable[
    linearreg,
    randomforestreg,
    knetmlpreg,
    ]

showall(PredictMD.singlelabelregressionmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    labelname,
    ))

showall(PredictMD.singlelabelregressionmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    labelname,
    ))
