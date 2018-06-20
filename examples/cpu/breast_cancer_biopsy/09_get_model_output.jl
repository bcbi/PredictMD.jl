###### Beginning of file

import PredictMD

#### Begin project-specific settings

PROJECT_OUTPUT_DIRECTORY = PredictMD.directory(
    homedir(),
    "Desktop",
    "breast_cancer_biopsy_example",
    )

#### End project-specific settings

#### Begin model output code

import CSV
import DataFrames
import Knet

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

smoted_training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
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

logistic_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "logistic_classifier.jld2",
    )
random_forest_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "random_forest_classifier.jld2",
    )
c_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "c_svc_svm_classifier.jld2",
    )
nu_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "nu_svc_svm_classifier.jld2",
    )
knet_mlp_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "knet_mlp_classifier.jld2",
    )

logistic_classifier =
    PredictMD.load_model(logistic_classifier_filename)
random_forest_classifier =
    PredictMD.load_model(random_forest_classifier_filename)
c_svc_svm_classifier =
    PredictMD.load_model(c_svc_svm_classifier_filename)
nu_svc_svm_classifier =
    PredictMD.load_model(nu_svc_svm_classifier_filename)
knet_mlp_classifier =
    PredictMD.load_model(knet_mlp_classifier_filename)
PredictMD.parse_functions!(knet_mlp_classifier)

PredictMD.predict_proba(
    logistic_classifier,
    smoted_training_features_df,
    )
PredictMD.predict_proba(
    random_forest_classifier,
    smoted_training_features_df,
    )
PredictMD.predict_proba(
    c_svc_svm_classifier,
    smoted_training_features_df,
    )
PredictMD.predict_proba(
    nu_svc_svm_classifier,
    smoted_training_features_df,
    )
PredictMD.predict_proba(
    knet_mlp_classifier,
    smoted_training_features_df,
    )

PredictMD.predict_proba(logistic_classifier,testing_features_df,)
PredictMD.predict_proba(random_forest_classifier,testing_features_df,)
PredictMD.predict_proba(c_svc_svm_classifier,testing_features_df,)
PredictMD.predict_proba(nu_svc_svm_classifier,testing_features_df,)
PredictMD.predict_proba(knet_mlp_classifier,testing_features_df,)

PredictMD.predict(logistic_classifier,smoted_training_features_df,)
PredictMD.predict(random_forest_classifier,smoted_training_features_df,)
PredictMD.predict(c_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict(nu_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict(knet_mlp_classifier,smoted_training_features_df,)

PredictMD.predict(logistic_classifier,testing_features_df,)
PredictMD.predict(random_forest_classifier,testing_features_df,)
PredictMD.predict(c_svc_svm_classifier,testing_features_df,)
PredictMD.predict(nu_svc_svm_classifier,testing_features_df,)
PredictMD.predict(knet_mlp_classifier,testing_features_df,)

#### End model output code

###### End of file
