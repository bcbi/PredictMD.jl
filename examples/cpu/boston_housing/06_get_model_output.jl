srand(999)

import CSV
import DataFrames
import Knet
import PredictMD

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
    "boston_housing_example",
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
training_labels_df = CSV.read(
    training_labels_df_filename,
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

linear_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "linear_regression.jld2",
    )
random_forest_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "random_forest_regression.jld2",
    )
knet_mlp_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "knet_mlp_regression.jld2",
    )

linear_regression = PredictMD.load_model(linear_regression_filename)
random_forest_regression = PredictMD.load_model(random_forest_regression_filename)

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
knet_mlp_regression = PredictMD.load_model(knet_mlp_regression_filename)

PredictMD.predict(linear_regression,training_features_df,)
PredictMD.predict(random_forest_regression,training_features_df,)
PredictMD.predict(knet_mlp_regression,training_features_df,)

PredictMD.predict(linear_regression,testing_features_df,)
PredictMD.predict(random_forest_regression,testing_features_df,)
PredictMD.predict(knet_mlp_regression,testing_features_df,)
