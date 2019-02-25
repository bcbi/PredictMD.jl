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

# PREDICTMD IF INCLUDE TEST STATEMENTS
@debug("PROJECT_OUTPUT_DIRECTORY: ", PROJECT_OUTPUT_DIRECTORY,)
if PredictMD.is_travis_ci()
    PredictMD.cache_to_homedir!("Desktop", "breast_cancer_biopsy_example",)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End project-specific settings

### Begin logistic classifier code

# PREDICTMD IF INCLUDE TEST STATEMENTS
import PredictMDExtra
import Test
# PREDICTMD ELSE
import PredictMDFull
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

import Pkg
try Pkg.add("StatsBase") catch end
import StatsBase

import Statistics

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

categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "continuous_feature_names.jld2",
    )
categorical_feature_names = FileIO.load(
    categorical_feature_names_filename,
    "categorical_feature_names",
    )
continuous_feature_names = FileIO.load(
    continuous_feature_names_filename,
    "continuous_feature_names",
    )
feature_names = vcat(categorical_feature_names, continuous_feature_names)

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"
single_label_levels = [negative_class, positive_class]

categorical_label_names = Symbol[single_label_name]
continuous_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

feature_contrasts = PredictMD.generate_feature_contrasts(
    smoted_training_features_df,
    feature_names,
    )

logistic_classifier =
        PredictMD.singlelabelbinaryclassdataframelogisticclassifier(
        feature_names,
        single_label_name,
        single_label_levels;
        package = :GLM,
        intercept = true,
        interactions = 1,
        name = "Logistic regression",
        )

PredictMD.fit!(
    logistic_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

PredictMD.get_underlying(logistic_classifier)

logistic_hist_training =
        PredictMD.plotsinglelabelbinaryclassifierhistogram(
        logistic_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        single_label_name,
        single_label_levels,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "logistic_hist_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, logistic_hist_training)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(logistic_hist_training)

logistic_hist_testing =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        logistic_classifier,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        single_label_levels,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "logistic_hist_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, logistic_hist_testing)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(logistic_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    logistic_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    single_label_name,
    positive_class;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class;
    sensitivity = 0.95,
    )

logistic_calibration_curve =
    PredictMD.plot_probability_calibration_curve(
        logistic_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        single_label_name,
        positive_class;
        window = 0.2,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(logistic_calibration_curve)

PredictMD.probability_calibration_metrics(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class;
    window = 0.1,
    )

logistic_cutoffs, logistic_risk_group_prevalences =
    PredictMD.risk_score_cutoff_values(
        logistic_classifier,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        average_function = Statistics.mean,
        )
@info(
    string(
        "Low risk: 0 to $(logistic_cutoffs[1]).",
        " Medium risk: $(logistic_cutoffs[1]) to $(logistic_cutoffs[2]).",
        " High risk: $(logistic_cutoffs[2]) to 1.",
        )
    )
@info(logistic_risk_group_prevalences)
logistic_cutoffs, logistic_risk_group_prevalences =
    PredictMD.risk_score_cutoff_values(
        logistic_classifier,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        average_function = Statistics.median,
        )
@info(
    string(
        "Low risk: 0 to $(logistic_cutoffs[1]).",
        " Medium risk: $(logistic_cutoffs[1]) to $(logistic_cutoffs[2]).",
        " High risk: $(logistic_cutoffs[2]) to 1.",
        )
    )
@info(logistic_risk_group_prevalences)

logistic_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "logistic_classifier.jld2",
    )

PredictMD.save_model(logistic_classifier_filename, logistic_classifier)

### End logistic classifier code

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.homedir_to_cache!("Desktop", "breast_cancer_biopsy_example",)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

##### End of file
