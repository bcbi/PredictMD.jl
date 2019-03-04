##### Beginning of file

# This file was generated by PredictMD version 0.24.0
# For help, please visit https://predictmd.net

import PredictMD

### Begin project-specific settings

PredictMD.require_julia_version("v1.1.0")

PredictMD.require_predictmd_version("0.24.0")

# PredictMD.require_predictmd_version("0.24.0", "0.25.0-")

PROJECT_OUTPUT_DIRECTORY = PredictMD.project_directory(
    homedir(),
    "Desktop",
    "breast_cancer_biopsy_example",
    )



### End project-specific settings

### Begin model comparison code

import PredictMDFull

import Pkg
try Pkg.add("StatsBase") catch end
import StatsBase

import Statistics

Kernel = LIBSVM.Kernel

import LinearAlgebra
import Random
import Statistics
try Pkg.add("GLM") catch end
try Pkg.add("Distributions") catch end
try Pkg.add("StatsModels") catch end
import GLM
import Distributions
import StatsModels

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "trainingandtuning_labels_df.csv",
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
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = CSV.read(
    trainingandtuning_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
trainingandtuning_labels_df = CSV.read(
    trainingandtuning_labels_df_filename,
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
tuning_features_df = CSV.read(
    tuning_features_df_filename,
    DataFrames.DataFrame;
    rows_for_type_detect = 100,
    )
tuning_labels_df = CSV.read(
    tuning_labels_df_filename,
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

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"

single_label_levels = [negative_class, positive_class]

categorical_label_names = Symbol[single_label_name]
continuous_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

println(
    string(
        "Single label binary classification metrics, training set, ",
        "fix sensitivity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        ),
    allcols=true,
    )
println(
    string(
        "Single label binary classification metrics, training set, ",
        "fix specificity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        specificity = 0.95,
        ),
    allcols=true,
    )
println(
    string(
        "Single label binary classification metrics, training set, ",
        "maximize F1 score",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        maximize = :f1score,
        ),
    allcols=true,
    )
println(
    string(
        "Single label binary classification metrics, training set, ",
        "maximize Cohen's kappa",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        maximize = :cohen_kappa,
        ),
    allcols=true,
    )

println(
    string(
        "Single label binary classification metrics, testing set, ",
        "fix sensitivity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        ),
    allcols=true,
    )
println(
    string(
        "Single label binary classification metrics, testing set, ",
        "fix specificity",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        specificity = 0.95,
        ),
    allcols=true,
    )
println(
    string(
        "Single label binary classification metrics, testing set, ",
        "maximize F1 score",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        maximize = :f1score,
        ),
    allcols=true,
    )
println(
    string(
        "Single label binary classification metrics, testing set, ",
        "maximize Cohen's kappa",
        )
    )
show(
    PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        maximize = :cohen_kappa,
        ),
    allcols=true,
    )

rocplottesting = PredictMD.plotroccurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );



display(rocplottesting)

prplottesting = PredictMD.plotprcurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );



display(prplottesting)

### End model comparison code



##### End of file

# This file was generated using Literate.jl, https://github.com/fredrikekre/Literate.jl

