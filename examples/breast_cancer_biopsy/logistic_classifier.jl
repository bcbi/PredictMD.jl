srand(999)

import CSV
import DataFrames
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
    smoted_training_labels_df_filename,
    DataFrames.DataFrame,
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
ENV["logistic_classifier_filename"] = string(
    tempname(),
    "logistic_classifier.jld2",
    )
logistic_classifier_filename = ENV["logistic_classifier_filename"]

feature_contrasts = PredictMD.generate_feature_contrasts(
    smoted_training_features_df,
    featurenames,
    )

logistic_classifier = PredictMD.singlelabelbinaryclassdataframelogistic_classifier(
    featurenames,
    singlelabelname,
    singlelabellevels;
    package = :GLMjl,
    intercept = true, # optional, defaults to true
    interactions = 1, # optional, defaults to 1
    name = "Logistic regression", # optional
    )

PredictMD.fit!(
    logistic_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

PredictMD.get_underlying(logistic_classifier)

logistic_hist_training = PredictMD.plotsinglelabelbinaryclassifierhistogram(
    logistic_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    singlelabelname,
    singlelabellevels,
    )
PredictMD.open_plot(logistic_hist_training)

logistic_hist_testing = PredictMD.plotsinglelabelbinaryclassifierhistogram(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    singlelabellevels,
    )
PredictMD.open_plot(logistic_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

logistic_calibration_curve = PredictMD.plot_probability_calibration_curve(
    logistic_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    singlelabelname,
    positiveclass;
    window = 0.2,
    )
PredictMD.open_plot(logistic_calibration_curve)

PredictMD.probability_calibration_metrics(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    window = 0.1,
    )

logistic_cutoffs, logistic_risk_group_prevalences = PredictMD.risk_score_cutoff_values(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    average_function = mean,
    )
println(
    string(
        "Low risk: 0 to $(logistic_cutoffs[1]).",
        " Medium risk: $(logistic_cutoffs[1]) to $(logistic_cutoffs[2]).",
        " High risk: $(logistic_cutoffs[2]) to 1.",
        )
    )
showall(logistic_risk_group_prevalences)
logistic_cutoffs, logistic_risk_group_prevalences = PredictMD.risk_score_cutoff_values(
    logistic_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    average_function = median,
    )
println(
    string(
        "Low risk: 0 to $(logistic_cutoffs[1]).",
        " Medium risk: $(logistic_cutoffs[1]) to $(logistic_cutoffs[2]).",
        " High risk: $(logistic_cutoffs[2]) to 1.",
        )
    )
showall(logistic_risk_group_prevalences)

PredictMD.save_model(logistic_classifier_filename, logistic_classifier)
