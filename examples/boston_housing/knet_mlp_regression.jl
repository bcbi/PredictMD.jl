srand(999)

import PredictMD
import CSV
import DataFrames
import Knet

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

ENV["knet_mlp_regression_filename"] = string(
    tempname(),
    "_knet_mlp_regression.jld2",
    )
Base.Test.@test(!isfile(ENV["knet_mlp_regression_filename"]))
knet_mlp_regression = ENV["knet_mlp_regression_filename"]

function knetmlp_predict(
        w, # don't put a type annotation on this
        x0::AbstractArray,
        )
    # x0 = input layer
    # x1 = hidden layer
    x1 = Knet.relu.( w[1]*x0 .+ w[2] ) # w[1] = weights, w[2] = biases
    # x2 = output layer
    x2 = w[3]*x1 .+ w[4] # w[3] = weights, w[4] = biases
    return x2
end

function knetmlp_loss(
        predict_function::Function,
        modelweights, # don't put a type annotation on this
        x::AbstractArray,
        ytrue::AbstractArray;
        L1::Real = Cfloat(0),
        L2::Real = Cfloat(0),
        )
    loss = mean(
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

knetmlp_modelweights = Any[
    # input layer has dimension contrasts.num_array_columns
    #
    # hidden layer (10 neurons):
    Cfloat.(
        0.1f0*randn(Cfloat,10,feature_contrasts.num_array_columns) # weights
        ),
    Cfloat.(
        zeros(Cfloat,10,1) # biases
        ),
    #
    # output layer (regression nets have exactly 1 neuron in output layer):
    Cfloat.(
        0.1f0*randn(Cfloat,1,10) # weights
        ),
    Cfloat.(
        zeros(Cfloat,1,1) # biases
        ),
    ]

knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.0)
knetmlp_losshyperparameters[:L2] = Cfloat(0.0)
knetmlp_optimizationalgorithm = :Adam
knetmlp_optimizerhyperparameters = Dict()
knetmlp_minibatchsize = 48
knetmlp_maxepochs = 1_000
knetmlpreg = PredictMD.singlelabeldataframeknetregression(
    featurenames,
    labelname;
    package = :Knetjl,
    name = "Knet MLP",
    predict = knetmlp_predict,
    loss = knetmlp_loss,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = knetmlp_maxepochs,
    printlosseverynepochs = 100, # if 0, will not print at all
    feature_contrasts = feature_contrasts,
    )

PredictMD.fit!(
    knetmlpreg,
    training_features_df,
    training_labels_df,
    validation_features_df,
    validation_labels_df,
    )


knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knetmlpreg,
    :loss_vs_epoch;
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch)

knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knetmlpreg,
    :loss_vs_epoch;
    startat = 10,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch_skip10epochs)

knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knetmlpreg,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration)

knet_learningcurve_lossvsiteration_skip100iterations = PredictMD.plotlearningcurve(
    knetmlpreg,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration_skip100iterations)

knetmlpreg_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knetmlpreg,
    training_features_df,
    training_labels_df,
    labelname,
    )
PredictMD.open_plot(knetmlpreg_plot_training)

knetmlpreg_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knetmlpreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )
PredictMD.open_plot(knetmlpreg_plot_testing)

PredictMD.singlelabelregressionmetrics(
    knetmlpreg,
    training_features_df,
    training_labels_df,
    labelname,
    )

PredictMD.singlelabelregressionmetrics(
    knetmlpreg,
    testing_features_df,
    testing_labels_df,
    labelname,
    )

PredictMD.save_model(knet_mlp_regression, knetmlpreg)
