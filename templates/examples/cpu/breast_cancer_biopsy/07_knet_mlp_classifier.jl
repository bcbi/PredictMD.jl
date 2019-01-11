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

### Begin Knet neural network classifier code

# BEGIN TEST STATEMENTS
import Test
# END TEST STATEMENTS

import Pkg

try Pkg.add("CSV") catch end
try Pkg.add("DataFrames") catch end
try Pkg.add("FileIO") catch end
try Pkg.add("JLD2") catch end
try Pkg.add("Knet") catch end
try Pkg.add("PGFPlotsX") catch end

import CSV
import DataFrames
import FileIO
import JLD2
import Knet
import PGFPlotsX
import Random

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

knet_mlp_predict_function_source = """
function knetmlp_predict(
        w,
        x0::AbstractArray;
        probabilities::Bool = true,
        )
    x1 = Knet.relu.( w[1]*x0 .+ w[2] )
    x2 = Knet.relu.( w[3]*x1 .+ w[4] )
    x3 = w[5]*x2 .+ w[6]
    unnormalizedlogprobs = x3
    if probabilities
        normalizedlogprobs = Knet.logp(unnormalizedlogprobs; dims = 1)
        normalizedprobs = exp.(normalizedlogprobs)
        return normalizedprobs
    else
        return unnormalizedlogprobs
    end
end
"""

knet_mlp_loss_function_source = """
function knetmlp_loss(
        predict::Function,
        modelweights,
        x::AbstractArray,
        ytrue::AbstractArray;
        L1::Real = Cfloat(0),
        L2::Real = Cfloat(0),
        )
    loss = Knet.nll(
        predict(
            modelweights,
            x;
            probabilities = false,
            ),
        ytrue;
        dims = 1,
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

feature_contrasts = PredictMD.generate_feature_contrasts(
    smoted_training_features_df,
    feature_names,
    )

knetmlp_modelweights = Any[
    Cfloat.(
        0.1f0*randn(Cfloat,64,feature_contrasts.num_array_columns)
        ),
    Cfloat.(
        zeros(Cfloat,64,1)
        ),
    Cfloat.(
        0.1f0*randn(Cfloat,32,64)
        ),
    Cfloat.(
        zeros(Cfloat,32,1)
        ),
    Cfloat.(
        0.1f0*randn(Cfloat,2,32)
        ),
    Cfloat.(
        zeros(Cfloat,2,1)
        ),
    ]

knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.0)
knetmlp_losshyperparameters[:L2] = Cfloat(0.0)

knetmlp_optimizationalgorithm = :Momentum
knetmlp_optimizerhyperparameters = Dict()
knetmlp_minibatchsize = 48

knet_mlp_classifier =
    PredictMD.single_labelmulticlassdataframeknetclassifier(
        feature_names,
        single_label_name,
        single_label_levels;
        package = :Knet,
        name = "Knet MLP",
        predict_function_source = knet_mlp_predict_function_source,
        loss_function_source = knet_mlp_loss_function_source,
        losshyperparameters = knetmlp_losshyperparameters,
        optimizationalgorithm = knetmlp_optimizationalgorithm,
        optimizerhyperparameters = knetmlp_optimizerhyperparameters,
        minibatchsize = knetmlp_minibatchsize,
        modelweights = knetmlp_modelweights,
        printlosseverynepochs = 100,
        maxepochs = 200,
        feature_contrasts = feature_contrasts,
        )

PredictMD.parse_functions!(knet_mlp_classifier)

PredictMD.fit!(
    knet_mlp_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    tuning_features_df,
    tuning_labels_df,
    )

PredictMD.set_max_epochs!(knet_mlp_classifier, 1_000)

PredictMD.fit!(
    knet_mlp_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    tuning_features_df,
    tuning_labels_df,
    )

knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knet_mlp_classifier,
    :loss_vs_epoch;
    );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsepoch",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, knet_learningcurve_lossvsepoch)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(knet_learningcurve_lossvsepoch)

knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knet_mlp_classifier,
    :loss_vs_epoch;
    startat = 10,
    endat = :end,
    );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsepoch_skip10epochs",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, knet_learningcurve_lossvsepoch_skip10epochs)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(knet_learningcurve_lossvsepoch_skip10epochs)

knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knet_mlp_classifier,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsiteration",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, knet_learningcurve_lossvsiteration)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(knet_learningcurve_lossvsiteration)

knet_learningcurve_lossvsiteration_skip100iterations =
    PredictMD.plotlearningcurve(
        knet_mlp_classifier,
        :loss_vs_iteration;
        window = 50,
        sampleevery = 10,
        startat = 100,
        endat = :end,
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_learningcurve_lossvsiteration_skip100iterations",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, knet_learningcurve_lossvsiteration_skip100iterations)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(knet_learningcurve_lossvsiteration_skip100iterations)

knet_mlp_classifier_hist_training =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        knet_mlp_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        single_label_name,
        single_label_levels,
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_mlp_classifier_hist_training",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, knet_mlp_classifier_hist_training)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(knet_mlp_classifier_hist_training)

knet_mlp_classifier_hist_testing =
        PredictMD.plotsinglelabelbinaryclassifierhistogram(
        knet_mlp_classifier,
        testing_features_df,
        testing_labels_df,
        single_label_name,
        single_label_levels,
        );

# BEGIN TEST STATEMENTS
filename = string(
    tempname(),
    "_",
    "knet_mlp_classifier_hist_testing",
    ".pdf",
    )
rm(filename; force = true, recursive = true,)
Test.@test(!isfile(filename))
PGFPlotsX.save(filename, knet_mlp_classifier_hist_testing)
if PredictMD.is_force_test_plots()
    Test.@test(isfile(filename))
end
# END TEST STATEMENTS

display(knet_mlp_classifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    knet_mlp_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    single_label_name,
    positive_class;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    knet_mlp_classifier,
    testing_features_df,
    testing_labels_df,
    single_label_name,
    positive_class;
    sensitivity = 0.95,
    )

knet_mlp_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "knet_mlp_classifier.jld2",
    )

PredictMD.save_model(knet_mlp_classifier_filename, knet_mlp_classifier)

### End Knet neural network classifier code

##### End of file
