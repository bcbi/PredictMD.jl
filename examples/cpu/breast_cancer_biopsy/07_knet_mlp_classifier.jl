###### Beginning of file

import PredictMD

#### Begin project-specific settings

PROJECT_OUTPUT_DIRECTORY = PredictMD.directory(
    homedir(),
    "Desktop",
    "breast_cancer_biopsy_example",
    )

#### End project-specific settings

#### Begin Knet neural network classifier code

import CSV
import DataFrames
import Knet

srand(999)

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
        normalizedlogprobs = Knet.logp(unnormalizedlogprobs, 1)
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
        ytrue,
        1,
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
    featurenames,
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
knetmlp_maxepochs = 1_000

knet_mlp_classifier =
    PredictMD.singlelabelmulticlassdataframeknetclassifier(
        featurenames,
        singlelabelname,
        singlelabellevels;
        package = :Knetjl,
        name = "Knet MLP",
        predict_function_source = knet_mlp_predict_function_source,
        loss_function_source = knet_mlp_loss_function_source,
        losshyperparameters = knetmlp_losshyperparameters,
        optimizationalgorithm = knetmlp_optimizationalgorithm,
        optimizerhyperparameters = knetmlp_optimizerhyperparameters,
        minibatchsize = knetmlp_minibatchsize,
        modelweights = knetmlp_modelweights,
        printlosseverynepochs = 100,
        maxepochs = knetmlp_maxepochs,
        feature_contrasts = feature_contrasts,
        )

PredictMD.parse_functions!(knet_mlp_classifier)

PredictMD.fit!(
    knet_mlp_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    validation_features_df,
    validation_labels_df,
    )

knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knet_mlp_classifier,
    :loss_vs_epoch;
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch)

knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knet_mlp_classifier,
    :loss_vs_epoch;
    startat = 10,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch_skip10epochs)

knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knet_mlp_classifier,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration)

knet_learningcurve_lossvsiteration_skip100iterations =
    PredictMD.plotlearningcurve(
        knet_mlp_classifier,
        :loss_vs_iteration;
        window = 50,
        sampleevery = 10,
        startat = 100,
        endat = :end,
        )
PredictMD.open_plot(knet_learningcurve_lossvsiteration_skip100iterations)

knet_mlp_classifier_hist_training =
    PredictMD.plotsinglelabelbinaryclassifierhistogram(
        knet_mlp_classifier,
        smoted_training_features_df,
        smoted_training_labels_df,
        singlelabelname,
        singlelabellevels,
        )
PredictMD.open_plot(knet_mlp_classifier_hist_training)

knet_mlp_classifier_hist_testing =
        PredictMD.plotsinglelabelbinaryclassifierhistogram(
        knet_mlp_classifier,
        testing_features_df,
        testing_labels_df,
        singlelabelname,
        singlelabellevels,
        )
PredictMD.open_plot(knet_mlp_classifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    knet_mlp_classifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    knet_mlp_classifier,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    )

knet_mlp_classifier_filename = joinpath(
    PROJECT_OUTPUT_DIRECTORY,
    "knet_mlp_classifier.jld2",
    )

PredictMD.save_model(knet_mlp_classifier_filename, knet_mlp_classifier)

#### End Knet neural network classifier code

###### End of file
