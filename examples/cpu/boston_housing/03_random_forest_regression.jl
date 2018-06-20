###### Beginning of file

import PredictMD

#### Begin project-specific settings

PROJECT_OUTPUT_DIRECTORY = PredictMD.directory(
    homedir(),
    "Desktop",
    "boston_housing_example",
    )

#### End project-specific settings

#### Begin random forest regression code

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

feature_contrasts = PredictMD.generate_feature_contrasts(
    training_features_df,
    featurenames,
    )

random_forest_regression =
    PredictMD.singlelabeldataframerandomforestregression(
        featurenames,
        singlelabelname;
        nsubfeatures = 2,
        ntrees = 20,
        package = :DecisionTreejl,
        name = "Random forest",
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(
    random_forest_regression,
    training_features_df,
    training_labels_df,
    )

random_forest_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        random_forest_regression,
        training_features_df,
        training_labels_df,
        singlelabelname,
        )
PredictMD.open_plot(random_forest_regression_plot_training)

random_forest_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        random_forest_regression,
        testing_features_df,
        testing_labels_df,
        singlelabelname,
        )
PredictMD.open_plot(random_forest_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    random_forest_regression,
    training_features_df,
    training_labels_df,
    singlelabelname,
    )

PredictMD.singlelabelregressionmetrics(
    random_forest_regression,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    )

random_forest_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "random_forest_regression.jld2",
    )

PredictMD.save_model(
    random_forest_regression_filename,
    random_forest_regression
    )

#### End random forest regression code

###### End of file
