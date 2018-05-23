srand(999)

import CSV
import DataFrames
import Knet
import PredictMD

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
    DataFrames.DataFrame,
    )
smoted_training_labels_df = CSV.read(
    smoted_training_labels_df_filename,
    DataFrames.DataFrame,
    )

logistic_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "logistic_classifier.jld2",
    )
random_forest_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "random_forest_classifier.jld2",
    )
c_svc_svm_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "c_svc_svm_classifier.jld2",
    )
nu_svc_svm_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "nu_svc_svm_classifier.jld2",
    )
knet_mlp_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "knet_mlp_classifier.jld2",
    )

logistic_classifier = PredictMD.load_model(logistic_classifier_filename)
random_forest_classifier = PredictMD.load_model(random_forest_classifier_filename)
c_svc_svm_classifier = PredictMD.load_model(c_svc_svm_classifier_filename)
nu_svc_svm_classifier = PredictMD.load_model(nu_svc_svm_classifier_filename)
knet_mlp_classifier = PredictMD.load_model(knet_mlp_classifier_filename)
PredictMD.parse_functions!(knet_mlp_classifier)

PredictMD.predict_proba(logistic_classifier,smoted_training_features_df,)
PredictMD.predict_proba(random_forest_classifier,smoted_training_features_df,)
PredictMD.predict_proba(c_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict_proba(nu_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict_proba(knet_mlp_classifier,smoted_training_features_df,)

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

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

