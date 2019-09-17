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

### Begin model comparison code

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

# PREDICTMD IF INCLUDE TEST STATEMENTS
logistic_classifier = nothing
Test.@test isnothing(logistic_classifier)

random_forest_classifier = nothing
Test.@test isnothing(random_forest_classifier)

c_svc_svm_classifier = nothing
Test.@test isnothing(c_svc_svm_classifier)

nu_svc_svm_classifier = nothing
Test.@test isnothing(nu_svc_svm_classifier)

knet_mlp_classifier = nothing
Test.@test isnothing(knet_mlp_classifier)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

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

PredictMD.parse_functions!(logistic_classifier)
PredictMD.parse_functions!(random_forest_classifier)
PredictMD.parse_functions!(c_svc_svm_classifier)
PredictMD.parse_functions!(nu_svc_svm_classifier)
PredictMD.parse_functions!(knet_mlp_classifier)

# PREDICTMD IF INCLUDE TEST STATEMENTS
PredictMD.parse_functions!(logistic_classifier)
PredictMD.parse_functions!(random_forest_classifier)
PredictMD.parse_functions!(c_svc_svm_classifier)
PredictMD.parse_functions!(nu_svc_svm_classifier)
PredictMD.parse_functions!(knet_mlp_classifier)

PredictMD.parse_functions!(logistic_classifier)
PredictMD.parse_functions!(random_forest_classifier)
PredictMD.parse_functions!(c_svc_svm_classifier)
PredictMD.parse_functions!(nu_svc_svm_classifier)
PredictMD.parse_functions!(knet_mlp_classifier)

PredictMD.parse_functions!(logistic_classifier)
PredictMD.parse_functions!(random_forest_classifier)
PredictMD.parse_functions!(c_svc_svm_classifier)
PredictMD.parse_functions!(nu_svc_svm_classifier)
PredictMD.parse_functions!(knet_mlp_classifier)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

all_models = PredictMD.AbstractFittable[
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
    logger_stream, string(
        "Single label binary classification metrics, training set, ",
        "fix sensitivity",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    logger_stream, string(
        "Single label binary classification metrics, training set, ",
        "fix specificity",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        specificity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    logger_stream, string(
        "Single label binary classification metrics, training set, ",
        "maximize F1 score",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        maximize = :f1score,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    logger_stream, string(
        "Single label binary classification metrics, training set, ",
        "maximize Cohen's kappa",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        training_features_df,
        training_labels_df,
        single_label_name,
        positive_class;
        maximize = :cohen_kappa,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    logger_stream, string(
        "Single label binary classification metrics, testing set, ",
        "fix sensitivity",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

# PREDICTMD IF INCLUDE TEST STATEMENTS
metrics = PredictMD.singlelabelbinaryclassificationmetrics(all_models,
                                                 testing_features_df,
                                                 testing_labels_df,
                                                 single_label_name,
                                                 positive_class;
                                                 sensitivity = 0.95)
auprc_row = first(
    findall(
        strip.(metrics[:metric]) .== "AUPRC"
        )
    )
Test.@test(
    strip(metrics[auprc_row, :metric]) == "AUPRC"
    )
Test.@test(
    metrics[auprc_row, Symbol("Logistic regression")] > 0.910
    )
Test.@test(
    metrics[auprc_row, Symbol("Random forest")] > 0.910
    )
Test.@test(
    metrics[auprc_row, Symbol("SVM (C-SVC)")] > 0.910
    )
Test.@test(
    metrics[auprc_row, Symbol("SVM (nu-SVC)")] > 0.910
    )
Test.@test(
    metrics[auprc_row, Symbol("Knet MLP")] > 0.910
    )
aurocc_row = first(
    findall(
        strip.(metrics[:metric]) .== "AUROCC"
        )
    )
Test.@test(
    metrics[aurocc_row, :metric] == "AUROCC"
    )
Test.@test(
    metrics[aurocc_row, Symbol("Logistic regression")] > 0.910
    )
Test.@test(
    metrics[aurocc_row, Symbol("Random forest")] > 0.910
    )
Test.@test(
    metrics[aurocc_row, Symbol("SVM (C-SVC)")] > 0.910
    )
Test.@test(
    metrics[aurocc_row, Symbol("SVM (nu-SVC)")] > 0.910
    )
Test.@test(
    metrics[aurocc_row, Symbol("Knet MLP")] > 0.910
    )
avg_precision_row = first(
    findall(
        strip.(metrics[:metric]) .== "Average precision"
        )
    )
Test.@test(
    strip(metrics[avg_precision_row, :metric]) == "Average precision"
    )
Test.@test(
    metrics[avg_precision_row, Symbol("Logistic regression")] > 0.910
    )
Test.@test(
    metrics[avg_precision_row, Symbol("Random forest")] > 0.910
    )
Test.@test(
    metrics[avg_precision_row, Symbol("SVM (C-SVC)")] > 0.910
    )
Test.@test(
    metrics[avg_precision_row, Symbol("SVM (nu-SVC)")] > 0.910
    )
Test.@test(
    metrics[avg_precision_row, Symbol("Knet MLP")] > 0.910
    )
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

println(
    logger_stream, string(
        "Single label binary classification metrics, testing set, ",
        "fix specificity",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        specificity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    logger_stream, string(
        "Single label binary classification metrics, testing set, ",
        "maximize F1 score",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        maximize = :f1score,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

println(
    logger_stream, string(
        "Single label binary classification metrics, testing set, ",
        "maximize Cohen's kappa",
        )
    )
show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        all_models,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        positive_class;
        maximize = :cohen_kappa,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

rocplottesting = PredictMD.plotroccurve(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "rocplottesting",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, rocplottesting)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(rocplottesting)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "rocplottesting.pdf",
        ),
    rocplottesting,
    )

prplottesting = PredictMD.plotprcurve(
    all_models,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class,
    );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "prplottesting",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, prplottesting)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(prplottesting)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "prplottesting.pdf",
        ),
    prplottesting,
    )

### End model comparison code

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
