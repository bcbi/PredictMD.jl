###### Beginning of file

import PredictMD

#### Begin project-specific settings

PROJECT_OUTPUT_DIRECTORY = PredictMD.directory(
    homedir(),
    "Desktop",
    "breast_cancer_biopsy_example",
    )

#### End project-specific settings

#### Begin C-SVC code

import CSV
import DataFrames
import LIBSVM

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

c_svc_svm_classifier =
    PredictMD.singlelabelmulticlassdataframesvmclassifier(
        featurenames,
        singlelabelname,
        singlelabellevels;
        package = :LIBSVMjl,
        svmtype = LIBSVM.SVC,
        name = "SVM (C-SVC)",
        verbose = false,
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(
    c_svc_svm_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

c_svc_svm_classifier_hist_training =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        c_svc_svm_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        singlelabelname,
        singlelabellevels,
        )
PredictMD.open_plot(c_svc_svm_classifier_hist_training)

c_svc_svm_classifier_hist_testing =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        c_svc_svm_classifier,
        testing_features_df,
        testing_labels_df,
        singlelabelname,
        singlelabellevels,
        )
PredictMD.open_plot(c_svc_svm_classifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    c_svc_svm_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    c_svc_svm_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

c_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "c_svc_svm_classifier.jld2",
    )

PredictMD.save_model(c_svc_svm_classifier_filename, c_svc_svm_classifier)

#### End C-SVC code

###### End of file
