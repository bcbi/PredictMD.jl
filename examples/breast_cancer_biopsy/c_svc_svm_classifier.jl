srand(999)

import CSV
import DataFrames
import LIBSVM
import PredictMD

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

smoted_training_features_df_filename =
    ENV["smoted_training_features_df_filename"]
smoted_training_labels_df_filename =
    ENV["smoted_training_labels_df_filename"]
smoted_training_features_df = CSV.read(
    smoted_training_features_df_filename,
    DataFrames.DataFrame,
    )
smoted_training_labels_df = CSV.read(
    smoted_training_features_df_filename,
    DataFrames.DataFrame,
    )

ENV["c_svc_svm_classifier_filename"] = string(
    tempname(),
    "c_svc_svm_classifier.jld2",
    )
c_svc_svm_classifier_filename = ENV["c_svc_svm_classifier_filename"]

csvc_svmclassifier = PredictMD.singlelabelmulticlassdataframesvmclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :LIBSVMjl,
    svmtype = LIBSVM.SVC,
    name = "SVM (C-SVC)",
    verbose = false,
    feature_contrasts = feature_contrasts,
    )

PredictMD.fit!(
    csvc_svmclassifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

csvc_svmclassifier_hist_training = PredictMD.plotsinglelabelbinaryclassifierhistogram(
    csvc_svmclassifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    labelname,
    labellevels,
    )
PredictMD.open_plot(csvc_svmclassifier_hist_training)

csvc_svmclassifier_hist_testing = PredictMD.plotsinglelabelbinaryclassifierhistogram(
    csvc_svmclassifier,
    testing_features_df,
    testing_labels_df,
    labelname,
    labellevels,
    )
PredictMD.open_plot(csvc_svmclassifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    csvc_svmclassifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    csvc_svmclassifier,
    testing_features_df,
    testing_labels_df,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.save_model(csvc_svmclassifier_filename, csvc_svmclassifier)
