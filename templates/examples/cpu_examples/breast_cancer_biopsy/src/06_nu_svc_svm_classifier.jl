## %PREDICTMD_GENERATED_BY%

import PredictMDExtra
PredictMDExtra.import_all()

import PredictMD
PredictMD.import_all()

# PREDICTMD IF INCLUDE TEST STATEMENTS
import CSVFiles
import DataFrames
import FileIO
import RDatasets
import Random
import Test
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

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

### Begin nu-SVC code

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

categorical_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
    "categorical_feature_names.jld2",
    )
continuous_feature_names_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "data",
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

nu_svc_svm_classifier =
    PredictMD.single_labelmulticlassdataframesvmclassifier(
        feature_names,
        single_label_name,
        single_label_levels;
        package = :LIBSVM,
        svmtype = LIBSVM.NuSVC,
        name = "SVM (nu-SVC)",
        verbose = false,
        feature_contrasts = feature_contrasts,
        )

PredictMD.fit!(
    nu_svc_svm_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    )

nu_svc_svm_classifier_hist_training =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        nu_svc_svm_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        single_label_name,
        single_label_levels,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "nu_svc_svm_classifier_hist_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, nu_svc_svm_classifier_hist_training)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(nu_svc_svm_classifier_hist_training)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "nu_svc_svm_classifier_hist_training.pdf",
        ),
    nu_svc_svm_classifier_hist_training,
    )

nu_svc_svm_classifier_hist_testing =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        nu_svc_svm_classifier,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        single_label_levels,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "nu_svc_svm_classifier_hist_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, nu_svc_svm_classifier_hist_testing)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(nu_svc_svm_classifier_hist_testing)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "nu_svc_svm_classifier_hist_testing.pdf",
        ),
    nu_svc_svm_classifier_hist_testing,
    )

show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        nu_svc_svm_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        single_label_name,
        positive_class;
        sensitivity = 0.95,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

show(
    logger_stream, PredictMD.singlelabelbinaryclassificationmetrics(
        nu_svc_svm_classifier,
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

nu_svc_svm_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "nu_svc_svm_classifier.jld2",
    )

PredictMD.save_model(
    nu_svc_svm_classifier_filename,
    nu_svc_svm_classifier,
    )

# PREDICTMD IF INCLUDE TEST STATEMENTS
nu_svc_svm_classifier = nothing
Test.@test isnothing(nu_svc_svm_classifier)
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End nu-SVC code

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
