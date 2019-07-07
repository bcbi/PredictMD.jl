## %PREDICTMD_GENERATED_BY%

import PredictMDExtra
PredictMDExtra.import_all()

import PredictMD
PredictMD.import_all()

### Begin project-specific settings

LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES = homedir()

PROJECT_OUTPUT_DIRECTORY = joinpath(
    LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
    "cpu_examples",
    "boston_housing",
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
        from = ["cpu_examples", "boston_housing", "output",],
        to = [
            LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
            "cpu_examples", "boston_housing", "output",],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

### End project-specific settings

### Begin Knet neural network regression code

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

single_label_name = :MedV

continuous_label_names = Symbol[single_label_name]
categorical_label_names = Symbol[]
label_names = vcat(categorical_label_names, continuous_label_names)

knet_mlp_predict_function_source = """
function knetmlp_predict(
        w,
        x0::AbstractArray,
        )
    x1 = Knet.relu.( w[1]*x0 .+ w[2] )
    x2 = w[3]*x1 .+ w[4]
    return x2
end
"""

knet_mlp_loss_function_source = """
function knetmlp_loss(
        predict_function::Function,
        modelweights,
        x::AbstractArray,
        ytrue::AbstractArray;
        L1::Real = Float64(0),
        L2::Real = Float64(0),
        )
    loss = Statistics.mean(
        abs2,
        ytrue - predict_function(
            modelweights,
            x,
            ),
        )
    if L1 != 0
        loss += L1 * sum(sum(abs, w_i) for w_i in modelweights[1:2:end])
    end
    if L2 != 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in modelweights[1:2:end])
    end
    return loss
end
"""

feature_contrasts =
    PredictMD.generate_feature_contrasts(training_features_df, feature_names)

knetmlp_modelweights = Any[
    Float64.(
        0.1f0*randn(Float64,10,feature_contrasts.num_array_columns_without_intercept)
        ),
    Float64.(
        fill(Float64(0),10,1)
        ),
    Float64.(
        0.1f0*randn(Float64,1,10)
        ),
    Float64.(
        fill(Float64(0),1,1),
        ),
    ]

knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Float64(0.0)
knetmlp_losshyperparameters[:L2] = Float64(0.0)
knetmlp_optimizationalgorithm = :Adam
knetmlp_optimizerhyperparameters = Dict()
knetmlp_minibatchsize = 48

knet_mlp_regression = PredictMD.single_labeldataframeknetregression(
    feature_names,
    single_label_name;
    package = :Knet,
    name = "Knet MLP",
    predict_function_source = knet_mlp_predict_function_source,
    loss_function_source = knet_mlp_loss_function_source,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = 100,
    printlosseverynepochs = 10,
    feature_contrasts = feature_contrasts,
    )

PredictMD.parse_functions!(knet_mlp_regression)

PredictMD.fit!(
    knet_mlp_regression,
    training_features_df,
    training_labels_df,
    tuning_features_df,
    tuning_labels_df,
    )

PredictMD.set_max_epochs!(knet_mlp_regression, 200)

PredictMD.fit!(
    knet_mlp_regression,
    training_features_df,
    training_labels_df,
    tuning_features_df,
    tuning_labels_df,
    )

# PREDICTMD IF INCLUDE TEST STATEMENTS
test_knet_mlp_regression = PredictMD.single_labeldataframeknetregression(
    feature_names,
    single_label_name;
    package = :Knet,
    name = "Knet MLP",
    predict_function_source = knet_mlp_predict_function_source,
    loss_function_source = knet_mlp_loss_function_source,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = 5,
    printlosseverynepochs = 1,
    feature_contrasts = feature_contrasts,
    )
# PredictMD.fit!(
#     knet_mlp_regression,
#     training_features_df,
#     training_labels_df,
#     nothing,
#     nothing,
#     )

test_knet_mlp_regression = PredictMD.single_labeldataframeknetregression(
    feature_names,
    single_label_name;
    package = :Knet,
    name = "Knet MLP",
    predict_function_source = knet_mlp_predict_function_source,
    loss_function_source = knet_mlp_loss_function_source,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = 5,
    printlosseverynepochs = 1,
    feature_contrasts = feature_contrasts,
    )
# PredictMD.fit!(
#     knet_mlp_regression,
#     training_features_df,
#     training_labels_df,
#     nothing,
#     tuning_labels_df,
#     )

test_knet_mlp_regression = PredictMD.single_labeldataframeknetregression(
    feature_names,
    single_label_name;
    package = :Knet,
    name = "Knet MLP",
    predict_function_source = knet_mlp_predict_function_source,
    loss_function_source = knet_mlp_loss_function_source,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = 5,
    printlosseverynepochs = 1,
    feature_contrasts = feature_contrasts,
    )
# PredictMD.fit!(
#     knet_mlp_regression,
#     training_features_df,
#     training_labels_df,
#     tuning_features_df,
#     nothing,
#     )

PredictMD.get_underlying(test_knet_mlp_regression)

# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_epoch;
    );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsepoch",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, knet_learningcurve_lossvsepoch)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(knet_learningcurve_lossvsepoch)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "knet_learningcurve_lossvsepoch.pdf",
        ),
    knet_learningcurve_lossvsepoch,
    )

knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_epoch;
    startat = 10,
    endat = :end,
    );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsepoch_skip10epochs",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, knet_learningcurve_lossvsepoch_skip10epochs)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(knet_learningcurve_lossvsepoch_skip10epochs)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "knet_learningcurve_lossvsepoch_skip10epochs.pdf",
        ),
    knet_learningcurve_lossvsepoch_skip10epochs,
    )

knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsiteration",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, knet_learningcurve_lossvsiteration)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(knet_learningcurve_lossvsiteration)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "knet_learningcurve_lossvsiteration.pdf",
        ),
    knet_learningcurve_lossvsiteration,
    )

knet_learningcurve_lossvsiteration_skip100iterations =
    PredictMD.plotlearningcurve(
        knet_mlp_regression,
        :loss_vs_iteration;
        window = 50,
        sampleevery = 10,
        startat = 100,
        endat = :end,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsiteration_skip100iterations",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, knet_learningcurve_lossvsiteration_skip100iterations)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(knet_learningcurve_lossvsiteration_skip100iterations)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "knet_learningcurve_lossvsiteration_skip100iterations.pdf",
        ),
    knet_learningcurve_lossvsiteration_skip100iterations,
    )

knet_mlp_regression_plot_training =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        knet_mlp_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_mlp_regression_plot_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, knet_mlp_regression_plot_training)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(knet_mlp_regression_plot_training)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "knet_mlp_regression_plot_training.pdf",
        ),
    knet_mlp_regression_plot_training,
    )

knet_mlp_regression_plot_testing =
    PredictMD.plotsinglelabelregressiontrueversuspredicted(
        knet_mlp_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );

# PREDICTMD IF INCLUDE TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_mlp_regression_plot_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
@debug("Attempting to test that the file does not exist...", filename,)
Test.@test(!isfile(filename))
@debug("The file does not exist.", filename, isfile(filename),)
PredictMD.save_plot(filename, knet_mlp_regression_plot_testing)
if PredictMD.is_force_test_plots()
    @debug("Attempting to test that the file exists...", filename,)
    Test.@test(isfile(filename))
    @debug("The file does exist.", filename, isfile(filename),)
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

display(knet_mlp_regression_plot_testing)
PredictMD.save_plot(
    joinpath(
        PROJECT_OUTPUT_DIRECTORY,
        "plots",
        "knet_mlp_regression_plot_testing.pdf",
        ),
    knet_mlp_regression_plot_testing,
    )

show(
    PredictMD.singlelabelregressionmetrics(
        knet_mlp_regression,
        training_features_df,
        training_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

show(
    PredictMD.singlelabelregressionmetrics(
        knet_mlp_regression,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        );
    allrows = true,
    allcols = true,
    splitcols = false,
    )

knet_mlp_regression_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "models",
    "knet_mlp_regression.jld2",
    )

PredictMD.save_model(knet_mlp_regression_filename, knet_mlp_regression)

### End Knet neural network regression code

# PREDICTMD IF INCLUDE TEST STATEMENTS
if PredictMD.is_travis_ci()
    PredictMD.path_to_cache!(
        ;
        to = ["cpu_examples", "boston_housing", "output",],
        from = [
            LOCATION_OF_PREDICTMD_GENERATED_EXAMPLE_FILES,
            "cpu_examples", "boston_housing", "output",],
        )
end
# PREDICTMD ELSE
# PREDICTMD ENDIF INCLUDE TEST STATEMENTS

## %PREDICTMD_GENERATED_BY%
