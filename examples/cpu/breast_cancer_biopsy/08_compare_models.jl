###### Beginning of file

#### Begin project-specific settings

PROJECT_OUTPUT_DIRECTORY = joinpath(tempdir(), "breast_cancer_biopsy_example")
# PROJECT_OUTPUT_DIRECTORY = "/Users/dilum/Desktop/breast_cancer_biopsy_example"

#### End project-specific settings

#### Begin model comparison code

mkpath(PROJECT_OUTPUT_DIRECTORY)

import CSV
import DataFrames
import Knet
import PredictMD

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

all_models = PredictMD.Fittable[
    logistic_classifier,
    random_forest_classifier,
    c_svc_svm_classifier,
    nu_svc_svm_classifier,
    knet_mlp_classifier,
    ]

singlelabelname = :Class
negativeclass = "benign"
positiveclass = "malignant"

showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :f1score,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :cohen_kappa,
    ))

showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :f1score,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :cohen_kappa,
    ))

rocplottesting = PredictMD.plotroccurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass,
    )
PredictMD.open_plot(rocplottesting)

prplottesting = PredictMD.plotprcurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass,
    )
PredictMD.open_plot(prplottesting)

#### End model comparison code

###### End of file
