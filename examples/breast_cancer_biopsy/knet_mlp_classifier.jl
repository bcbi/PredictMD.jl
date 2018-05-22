srand(999)

import CSV
import DataFrames
import Knet
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

ENV["knet_mlp_classifier_filename"] = string(
    tempname(),
    "knet_mlp_classifier.jld2",
    )
knet_mlp_classifier_filename = ENV["knet_mlp_classifier_filename"]

function knetmlp_predict(
        w, # don't put a type annotation on this
        x0::AbstractArray;
        probabilities::Bool = true,
        )
    # x0 = input layer
    # x1 = first hidden layer
    x1 = Knet.relu.( w[1]*x0 .+ w[2] ) # w[1] = weights, w[2] = biases
    # x2 = second hidden layer
    x2 = Knet.relu.( w[3]*x1 .+ w[4] ) # w[3] = weights, w[4] = biases
    # x3 = output layer
    x3 = w[5]*x2 .+ w[6] # w[5] = weights, w[6] = biases
    unnormalizedlogprobs = x3
    if probabilities
        normalizedlogprobs = Knet.logp(unnormalizedlogprobs, 1)
        normalizedprobs = exp.(normalizedlogprobs)
        return normalizedprobs
    else
        return unnormalizedlogprobs
    end
end

function knetmlp_loss(
        predict::Function,
        modelweights, # don't put a type annotation on this
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
        1, # d = 1 means that instances are in columns
        )
    if L1 != 0
        loss += L1 * sum(sum(abs, w_i) for w_i in modelweights[1:2:end])
    end
    if L2 != 0
        loss += L2 * sum(sum(abs2, w_i) for w_i in modelweights[1:2:end])
    end
    return loss
end

knetmlp_modelweights = Any[
    # input layer has dimension contrasts.num_array_columns
    #
    # first hidden layer (64 neurons):
    Cfloat.(
        0.1f0*randn(Cfloat,64,feature_contrasts.num_array_columns) # weights
        ),
    Cfloat.(
        zeros(Cfloat,64,1) # biases
        ),
    #
    # second hidden layer (32 neurons):
    Cfloat.(
        0.1f0*randn(Cfloat,32,64) # weights
        ),
    Cfloat.(
        zeros(Cfloat,32,1) # biases
        ),
    #
    # output layer (number of neurons == number of classes):
    Cfloat.(
        0.1f0*randn(Cfloat,2,32) # weights
        ),
    Cfloat.(
        zeros(Cfloat,2,1) # biases
        ),
    ]

knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.0)
knetmlp_losshyperparameters[:L2] = Cfloat(0.0)

knetmlp_optimizationalgorithm = :Momentum
knetmlp_optimizerhyperparameters = Dict()
knetmlp_minibatchsize = 48
knetmlp_maxepochs = 1_000

knetmlpclassifier = PredictMD.singlelabelmulticlassdataframeknetclassifier(
    featurenames,
    labelname,
    labellevels;
    package = :Knetjl,
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    printlosseverynepochs = 100, # if 0, will not print at all
    maxepochs = knetmlp_maxepochs,
    feature_contrasts = feature_contrasts,
    )

PredictMD.fit!(
    knetmlpclassifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    validation_features_df,
    validation_labels_df,
    )

knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knetmlpclassifier,
    :loss_vs_epoch;
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch)

knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knetmlpclassifier,
    :loss_vs_epoch;
    startat = 10,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch_skip10epochs)

knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knetmlpclassifier,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration)

knet_learningcurve_lossvsiteration_skip100iterations = PredictMD.plotlearningcurve(
    knetmlpclassifier,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration_skip100iterations)

knetmlpclassifier_hist_training = PredictMD.plotsinglelabelbinaryclassifierhistogram(
    knetmlpclassifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    labelname,
    labellevels,
    )
PredictMD.open_plot(knetmlpclassifier_hist_training)

knetmlpclassifier_hist_testing = PredictMD.plotsinglelabelbinaryclassifierhistogram(
    knetmlpclassifier,
    testing_features_df,
    testing_labels_df,
    labelname,
    labellevels,
    )
PredictMD.open_plot(knetmlpclassifier_hist_testing)

PredictMD.singlelabelbinaryclassificationmetrics(
    knetmlpclassifier,
    smoted_training_features_df,
    smoted_training_labels_df,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.singlelabelbinaryclassificationmetrics(
    knetmlpclassifier,
    testing_features_df,
    testing_labels_df,
    labelname,
    positiveclass;
    sensitivity = 0.95,
    )

PredictMD.save_model(knetmlp_filename, knetmlpclassifier)
