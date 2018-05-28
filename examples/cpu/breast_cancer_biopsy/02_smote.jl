srand(999)

import CSV
import DataFrames
import PredictMD
import StatsBase

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

DataFrames.describe(training_labels_df[singlelabelname])
classes_before_smote = StatsBase.countmap(training_labels_df[singlelabelname])

majorityclass = "benign"
minorityclass = "malignant"

info(
    string(
        "Before SMOTE, in the training set, there are ",
        classes_before_smote[majorityclass],
        " instances in the majority class (\"",
        majorityclass,
        "\") and ",
        classes_before_smote[minorityclass],
        " instances in the minority class (\"",
        minorityclass,
        "\").",
        )
    )

smoted_training_features_df, smoted_training_labels_df = PredictMD.smote(
    training_features_df,
    training_labels_df,
    featurenames,
    singlelabelname;
    majorityclass = majorityclass,
    minorityclass = minorityclass,
    pct_over = 100,
    minority_to_majority_ratio = 1.0,
    k = 5,
    )

DataFrames.describe(smoted_training_labels_df[singlelabelname])
classes_after_smote = StatsBase.countmap(smoted_training_labels_df[singlelabelname])

info(
    string(
        "After SMOTE, in the smoted training set, there are ",
        classes_after_smote[majorityclass],
        " instances in the majority class (\"",
        majorityclass,
        "\") and ",
        classes_after_smote[minorityclass],
        " instances in the minority class (\"",
        minorityclass,
        "\").",
        )
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
CSV.write(
    smoted_training_features_df_filename,
    smoted_training_features_df,
    )
CSV.write(
    smoted_training_labels_df_filename,
    smoted_training_labels_df,
    )
