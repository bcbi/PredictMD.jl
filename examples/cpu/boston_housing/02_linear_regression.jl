###### Beginning of file

import PredictMD

#### Begin project-specific settings

PredictMD.require_version(:Julia, "v0.6")

PredictMD.require_version(:PredictMD, "PREDICTMD_CURRENT_VERSION")

PROJECT_OUTPUT_DIRECTORY = PredictMD.directory(
    homedir(),
    "Desktop",
    "boston_housing_example",
    )

#### End project-specific settings

#### Begin linear regression code

import CSV
import DataFrames

srand(999)

trainingandvalidation_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "validation_labels_df.csv",
    )
trainingandvalidation_features_df = CSV.read(
    trainingandvalidation_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
trainingandvalidation_labels_df = CSV.read(
    trainingandvalidation_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
testing_features_df = CSV.read(
    testing_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
testing_labels_df = CSV.read(
    testing_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
training_features_df = CSV.read(
    training_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
training_labels_df = CSV.read(
    training_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
validation_features_df = CSV.read(
    validation_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
validation_labels_df = CSV.read(
    validation_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
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

linear_regression = PredictMD.singlelabeldataframelinearregression(
    featurenames,
    singlelabelname;
    package = :GLMjl,
    intercept = true,
    interactions = 1,
    name = "Linear regression",
    )

PredictMD.fit!(linear_regression,training_features_df,training_labels_df,)

PredictMD.get_underlying(linear_regression)

linear_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        linear_regression,
        training_features_df,
        training_labels_df,
        singlelabelname,
        )
PredictMD.open_plot(linear_regression_plot_training)

linear_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
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

linear_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "linear_regression.jld2",
    )

PredictMD.save_model(linear_regression_filename, linear_regression)

#### End linear regression code

###### End of file
