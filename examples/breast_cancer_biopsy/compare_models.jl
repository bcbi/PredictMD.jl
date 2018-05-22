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

logisticclassifier = PredictMD.load_model(logisticclassifier_filename)
rfclassifier = PredictMD.load_model(rfclassifier_filename)
csvc_svmclassifier = PredictMD.load_model(csvc_svmclassifier_filename)
nusvc_svmclassifier = PredictMD.load_model(nusvc_svmclassifier_filename)

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

knetmlpclassifier = PredictMD.load_model(knetmlp_filename)

all_models = PredictMD.Fittable[
    logisticclassifier,
    rfclassifier,
    csvc_svmclassifier,
    nusvc_svmclassifier,
    knetmlpclassifier,
    ]

singlelabelname = :Class
negativeclass = "benign"
positiveclass = "malignant"

showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :f1score,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    training_features_df,
    training_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :cohen_kappa,
    ))

showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    sensitivity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    specificity = 0.95,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :f1score,
    ))
showall(PredictMD.singlelabelbinaryclassificationmetrics(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass;
    maximize = :cohen_kappa,
    ))

rocplottesting = PredictMD.plotroccurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass,
    )
PredictMD.open_plot(rocplottesting)

prplottesting = PredictMD.plotprcurves(
    all_models,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    positiveclass,
    )
PredictMD.open_plot(prplottesting)
