## %PREDICTMD_GENERATED_BY%

import PredictMDExtra
PredictMDExtra.import_all()

import PredictMD
PredictMD.import_all()

# PREDICTMD IF INCLUDE TEST STATEMENTS
logger = Base.CoreLogging.current_logger_for_env(Base.CoreLogging.Debug, Symbol(splitext(basename(something(@__FILE__, "nothing")))[1]), something(@__MODULE__, "nothing"))
if isnothing(logger)
    logger_stream = devnull
else
    logger_stream = logger.stream
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### Begin project-specific settings

DIRECTORY_CONTAINING_THIS_FILE = @__DIR__
PROJECT_DIRECTORY = dirname(
    joinpath(splitpath(DIRECTORY_CONTAINING_THIS_FILE)...)
    )
PROJECT_OUTPUT_DIRECTORY = joinpath(
    PROJECT_DIRECTORY,
    "output",
    )
mkpath(PROJECT_OUTPUT_DIRECTORY)
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "data"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "models"))
mkpath(joinpath(PROJECT_OUTPUT_DIRECTORY, "plots"))

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.cache_to_path!(
        ;
        from = ["cpu_examples", "breast_cancer_biopsy", "output",],
        to = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

# PREDICTMD IF INCLUDE TEST STATEMENTS
@debug("PROJECT_OUTPUT_DIRECTORY: ", PROJECT_OUTPUT_DIRECTORY,)
if PredictMD.is_travis_ci()
    PredictMD.cache_to_path!(
        ;
        from = ["cpu_examples", "breast_cancer_biopsy", "output",],
        to = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End project-specific settings

### Begin model output code

Kernel = LIBSVM.Kernel

Random.seed!(999)

trainingandtuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_features_df.csv",
    )
trainingandtuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "trainingandtuning_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "training_labels_df.csv",
    )
tuning_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_features_df.csv",
    )
tuning_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "tuning_labels_df.csv",
    )
trainingandtuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
trainingandtuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        trainingandtuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )
testing_features_df = DataFrames.DataFrame(
    FileIO.load(
        testing_features_df_filename;
        type_detect_rows = 100,
        )
    )
testing_labels_df = DataFrames.DataFrame(
    FileIO.load(
        testing_labels_df_filename;
        type_detect_rows = 100,
        )
    )
training_features_df = DataFrames.DataFrame(
    FileIO.load(
        training_features_df_filename;
        type_detect_rows = 100,
        )
    )
training_labels_df = DataFrames.DataFrame(
    FileIO.load(
        training_labels_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_features_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_features_df_filename;
        type_detect_rows = 100,
        )
    )
tuning_labels_df = DataFrames.DataFrame(
    FileIO.load(
        tuning_labels_df_filename;
        type_detect_rows = 100,
        )
    )

smoted_training_features_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "smoted_training_labels_df.csv",
    )
smoted_training_features_df = DataFrames.DataFrame(
    FileIO.load(
        smoted_training_features_df_filename;
        type_detect_rows = 100,
        )
    )
smoted_training_labels_df = DataFrames.DataFrame(
    FileIO.load(
        smoted_training_labels_df_filename;
        type_detect_rows = 100,
        )
    )

logistic_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "logistic_classifier.jld2",
    )
random_forest_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "random_forest_classifier.jld2",
    )
c_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "c_svc_svm_classifier.jld2",
    )
nu_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "nu_svc_svm_classifier.jld2",
    )
knet_mlp_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
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

PredictMD.predict_proba(logistic_classifier, smoted_training_features_df)
PredictMD.predict_proba(random_forest_classifier, smoted_training_features_df)
PredictMD.predict_proba(c_svc_svm_classifier, smoted_training_features_df)
PredictMD.predict_proba(nu_svc_svm_classifier, smoted_training_features_df)
PredictMD.predict_proba(knet_mlp_classifier, smoted_training_features_df)

PredictMD.predict_proba(logistic_classifier,testing_features_df)
PredictMD.predict_proba(random_forest_classifier,testing_features_df)
PredictMD.predict_proba(c_svc_svm_classifier,testing_features_df)
PredictMD.predict_proba(nu_svc_svm_classifier,testing_features_df)
PredictMD.predict_proba(knet_mlp_classifier,testing_features_df)

PredictMD.predict(logistic_classifier,smoted_training_features_df)
PredictMD.predict(random_forest_classifier,smoted_training_features_df)
PredictMD.predict(c_svc_svm_classifier,smoted_training_features_df)
PredictMD.predict(nu_svc_svm_classifier,smoted_training_features_df)
PredictMD.predict(knet_mlp_classifier,smoted_training_features_df)

PredictMD.predict(logistic_classifier,testing_features_df)
PredictMD.predict(random_forest_classifier,testing_features_df)
PredictMD.predict(c_svc_svm_classifier,testing_features_df)
PredictMD.predict(nu_svc_svm_classifier,testing_features_df)
PredictMD.predict(knet_mlp_classifier,testing_features_df)

single_label_name = :Class
negative_class = "benign"
positive_class = "malignant"

PredictMD.predict(logistic_classifier,smoted_training_features_df, positive_class, 0.3)
PredictMD.predict(random_forest_classifier,smoted_training_features_df, positive_class, 0.3)
PredictMD.predict(c_svc_svm_classifier,smoted_training_features_df, positive_class, 0.3)
PredictMD.predict(nu_svc_svm_classifier,smoted_training_features_df, positive_class, 0.3)
PredictMD.predict(knet_mlp_classifier,smoted_training_features_df, positive_class, 0.3)

PredictMD.predict(logistic_classifier,testing_features_df, positive_class, 0.3)
PredictMD.predict(random_forest_classifier,testing_features_df, positive_class, 0.3)
PredictMD.predict(c_svc_svm_classifier,testing_features_df, positive_class, 0.3)
PredictMD.predict(nu_svc_svm_classifier,testing_features_df, positive_class, 0.3)
PredictMD.predict(knet_mlp_classifier,testing_features_df, positive_class, 0.3)

### End model output code

# PREDICTMD IF INCLUDE TEST STATEMENTS
PredictMD.get_underlying(logistic_classifier)
PredictMD.get_underlying(random_forest_classifier)
PredictMD.get_underlying(c_svc_svm_classifier)
PredictMD.get_underlying(nu_svc_svm_classifier)
PredictMD.get_underlying(knet_mlp_classifier)

PredictMD.get_history(logistic_classifier)
PredictMD.get_history(random_forest_classifier)
PredictMD.get_history(c_svc_svm_classifier)
PredictMD.get_history(nu_svc_svm_classifier)
PredictMD.get_history(knet_mlp_classifier)

PredictMD.parse_functions!(logistic_classifier)
PredictMD.parse_functions!(random_forest_classifier)
PredictMD.parse_functions!(c_svc_svm_classifier)
PredictMD.parse_functions!(nu_svc_svm_classifier)
PredictMD.parse_functions!(knet_mlp_classifier)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.path_to_cache!(
        ;
        to = ["cpu_examples", "breast_cancer_biopsy", "output",],
        from = [PROJECT_OUTPUT_DIRECTORY],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

## %PREDICTMD_GENERATED_BY%
