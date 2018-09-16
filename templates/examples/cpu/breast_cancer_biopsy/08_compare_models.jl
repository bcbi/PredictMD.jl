##### Beginning of file

error(string("This file is not meant to be run. Use the `PredictMD.generate_examples()` function to generate examples that you can run."))

%PREDICTMD_GENERATED_BY%

import PredictMD

### Begin project-specific settings

PredictMD.require_julia_version("%PREDICTMD_MINIMUM_REQUIRED_JULIA_VERSION%")

PredictMD.require_predictmd_version("%PREDICTMD_CURRENT_VERSION%")

## PredictMD.require_predictmd_version("%PREDICTMD_CURRENT_VERSION%", "%PREDICTMD_NEXT_MINOR_VERSION%")

PROJECT_OUTPUT_DIRECTORY = PredictMD.project_directory(
    homedir(),
    "Desktop",
    "breast_cancer_biopsy_example",
    )

### End project-specific settings

### Begin model comparison code

Pkg.add("CSV")
Pkg.add("DataFrames")
Pkg.add("DecisionTree")
Pkg.add("Distributions")
Pkg.add("FileIO")
Pkg.add("GLM")
Pkg.add("JLD2")
Pkg.add("Knet")
Pkg.add("LIBSVM")
Pkg.add("PGFPlotsX")
Pkg.add("StatsModels")
Pkg.add("ValueHistories")

import CSV
import DataFrames
import DecisionTree
import Distributions
import FileIO
import GLM
import JLD2
import Knet
import LIBSVM
Kernel = LIBSVM.Kernel
import LinearAlgebra
import PGFPlotsX
import Random
import StatsModels
import ValueHistories

Random.seed!(999)

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
    true,
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
    true,
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
    true,
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
    true,
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
    true,
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
    true,
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
    true,
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
    true,
    )

rocplottesting = PredictMD.plotroccurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "rocplottesting",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, rocplottesting)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(rocplottesting)

prplottesting = PredictMD.plotprcurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "prplottesting",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, prplottesting)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(prplottesting)

### End model comparison code

##### End of file
