## Beginning of file

import CSV
import DataFrames
import Knet
import PredictMD

srand(999)

mkpath(
    joinpath(
        tempdir(),
        "boston_housing_example",
        ),
    )

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

categoricalfeaturenames = Symbol[]
continuousfeaturenames = Symbol[
    :Crim,
    :Zn,
    :Indus,
    :Chas,
    :NOx,
    :Rm,
    :Age,
    :Dis,
    :Rad,
    :Tax,
    :PTRatio,
    :Black,
    :LStat,
    ]
featurenames = vcat(categoricalfeaturenames, continuousfeaturenames)

singlelabelname = :MedV
labelnames = [singlelabelname]

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
"""

feature_contrasts = PredictMD.generate_feature_contrasts(training_features_df, featurenames)

knetmlp_modelweights = Any[
    Cfloat.(
        0.1f0*randn(Cfloat,10,feature_contrasts.num_array_columns)
        ),
    Cfloat.(
        zeros(Cfloat,10,1)
        ),
    Cfloat.(
        0.1f0*randn(Cfloat,1,10)
        ),
    Cfloat.(
        zeros(Cfloat,1,1),
        ),
    ]

knetmlp_losshyperparameters = Dict()
knetmlp_losshyperparameters[:L1] = Cfloat(0.0)
knetmlp_losshyperparameters[:L2] = Cfloat(0.0)
knetmlp_optimizationalgorithm = :Adam
knetmlp_optimizerhyperparameters = Dict()
knetmlp_minibatchsize = 48
knetmlp_maxepochs = 1_000

knet_mlp_regression = PredictMD.singlelabeldataframeknetregression(
    featurenames,
    singlelabelname;
    package = :Knetjl,
    name = "Knet MLP",
    predict_function_source = knet_mlp_predict_function_source,
    loss_function_source = knet_mlp_loss_function_source,
    losshyperparameters = knetmlp_losshyperparameters,
    optimizationalgorithm = knetmlp_optimizationalgorithm,
    optimizerhyperparameters = knetmlp_optimizerhyperparameters,
    minibatchsize = knetmlp_minibatchsize,
    modelweights = knetmlp_modelweights,
    maxepochs = knetmlp_maxepochs,
    printlosseverynepochs = 100,
    feature_contrasts = feature_contrasts,
    )

PredictMD.parse_functions!(knet_mlp_regression)

PredictMD.fit!(
    knet_mlp_regression,
    training_features_df,
    training_labels_df,
    validation_features_df,
    validation_labels_df,
    )

knet_learningcurve_lossvsepoch = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_epoch;
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch)

knet_learningcurve_lossvsepoch_skip10epochs = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_epoch;
    startat = 10,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsepoch_skip10epochs)

knet_learningcurve_lossvsiteration = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration)

knet_learningcurve_lossvsiteration_skip100iterations = PredictMD.plotlearningcurve(
    knet_mlp_regression,
    :loss_vs_iteration;
    window = 50,
    sampleevery = 10,
    startat = 100,
    endat = :end,
    )
PredictMD.open_plot(knet_learningcurve_lossvsiteration_skip100iterations)

knet_mlp_regression_plot_training = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knet_mlp_regression,
    training_features_df,
    training_labels_df,
    singlelabelname,
    )
PredictMD.open_plot(knet_mlp_regression_plot_training)

knet_mlp_regression_plot_testing = PredictMD.plotsinglelabelregressiontrueversuspredicted(
    knet_mlp_regression,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    )
PredictMD.open_plot(knet_mlp_regression_plot_testing)

PredictMD.singlelabelregressionmetrics(
    knet_mlp_regression,
    training_features_df,
    training_labels_df,
    singlelabelname,
    )

PredictMD.singlelabelregressionmetrics(
    knet_mlp_regression,
    testing_features_df,
    testing_labels_df,
    singlelabelname,
    )

knet_mlp_regression_filename = joinpath(
    tempdir(),
    "boston_housing_example",
    "knet_mlp_regression.jld2",
    )

PredictMD.save_model(knet_mlp_regression_filename, knet_mlp_regression)

## End of file
