srand(999)

import CSV
import DataFrames
import Knet
import PredictMD

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
    "validation_labels_df.csv",
    )
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

smoted_training_features_df_filename = joinpath(
    tempdir(),
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    tempdir(),
    "smoted_training_labels_df.csv",
    )
smoted_training_features_df = CSV.read(
    smoted_training_features_df_filename,
    DataFrames.DataFrame,
    )
smoted_training_labels_df = CSV.read(
    smoted_training_labels_df_filename,
    DataFrames.DataFrame,
    )

logistic_classifier_filename = joinpath(
    tempdir(),
    "logistic_classifier.jld2",
    )
random_forest_classifier_filename = joinpath(
    tempdir(),
    "random_forest_classifier.jld2",
    )
c_svc_svm_classifier_filename = joinpath(
    tempdir(),
    "c_svc_svm_classifier.jld2",
    )
nu_svc_svm_classifier_filename = joinpath(
    tempdir(),
    "nu_svc_svm_classifier.jld2",
    )
knet_mlp_classifier_filename = joinpath(
    tempdir(),
    "knet_mlp_classifier.jld2",
    )

logistic_classifier = PredictMD.load_model(logistic_classifier_filename)
random_forest_classifier = PredictMD.load_model(random_forest_classifier_filename)
c_svc_svm_classifier = PredictMD.load_model(c_svc_svm_classifier_filename)
nu_svc_svm_classifier = PredictMD.load_model(nu_svc_svm_classifier_filename)

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
knet_mlp_classifier = PredictMD.load_model(knet_mlp_classifier_filename)

PredictMD.predict_proba(logistic_classifier,smoted_training_features_df,)
PredictMD.predict_proba(random_forest_classifier,smoted_training_features_df,)
PredictMD.predict_proba(c_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict_proba(nu_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict_proba(knet_mlp_classifier,smoted_training_features_df,)

PredictMD.predict_proba(logistic_classifier,testing_features_df,)
PredictMD.predict_proba(random_forest_classifier,testing_features_df,)
PredictMD.predict_proba(c_svc_svm_classifier,testing_features_df,)
PredictMD.predict_proba(nu_svc_svm_classifier,testing_features_df,)
PredictMD.predict_proba(knet_mlp_classifier,testing_features_df,)

PredictMD.predict(logistic_classifier,smoted_training_features_df,)
PredictMD.predict(random_forest_classifier,smoted_training_features_df,)
PredictMD.predict(c_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict(nu_svc_svm_classifier,smoted_training_features_df,)
PredictMD.predict(knet_mlp_classifier,smoted_training_features_df,)

PredictMD.predict(logistic_classifier,testing_features_df,)
PredictMD.predict(random_forest_classifier,testing_features_df,)
PredictMD.predict(c_svc_svm_classifier,testing_features_df,)
PredictMD.predict(nu_svc_svm_classifier,testing_features_df,)
PredictMD.predict(knet_mlp_classifier,testing_features_df,)
