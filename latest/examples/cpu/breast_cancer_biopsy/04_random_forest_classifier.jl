# Beginning of file

import CSV
import DataFrames
import PredictMD

srand(999)

mkpath(
    joinpath(
        tempdir(),
        "breast_cancer_biopsy_example",
        ),
    )

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
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

smoted_training_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "smoted_training_labels_df.csv",
    )
smoted_training_features_df = CSV.read(
    smoted_training_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
smoted_training_labels_df = CSV.read(
    smoted_training_labels_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )

categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
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
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)

singlelabelname = :Class
negativeclass = "benign"
positiveclass = "malignant"
singlelabellevels = [negativeclass, positiveclass]

feature_contrasts = PredictMD.generate_feature_contrasts(
    smoted_training_features_df,
    featurenames,
    )

random_forest_classifier =
    PredictMD.singlelabelmulticlassdataframerandomforestclassifier(
        featurenames,
        singlelabelname,
        singlelabellevels;
        nsubfeatures = 4,
        ntrees = 200,
        package = :DecisionTreejl,
        name = "Random forest",
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(
    random_forest_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

random_forest_classifier_hist_training =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        random_forest_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        singlelabelname,
        singlelabellevels,
        )
PredictMD.open_plot(random_forest_classifier_hist_training)

random_forest_classifier_hist_testing =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        random_forest_classifier,
        testing_features_df,
        testing_labels_df,
        singlelabelname,
        singlelabellevels,
        )
PredictMD.open_plot(random_forest_classifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    random_forest_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    random_forest_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

random_forest_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "random_forest_classifier.jld2",
    )

PredictMD.save_model(
    random_forest_classifier_filename,
    random_forest_classifier,
    )

# End of file

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

