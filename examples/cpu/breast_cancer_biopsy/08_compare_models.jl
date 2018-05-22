srand(999)

import CSV
import DataFrames
import Knet
import PredictMD

mkpath(
    joinpath(
        tempdir(),
        "breast_cancer_biopsy_example",
        ),
    )

trainingandvalidation_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "trainingandvalidation_features_df.csv",
    )
trainingandvalidation_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "trainingandvalidation_labels_df.csv",
    )
testing_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "testing_features_df.csv",
    )
testing_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "testing_labels_df.csv",
    )
training_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "training_features_df.csv",
    )
training_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "training_labels_df.csv",
    )
validation_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "validation_features_df.csv",
    )
validation_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
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

smoted_training_features_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "smoted_training_features_df.csv",
    )
smoted_training_labels_df_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
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
    "breast_cancer_biopsy_example",
    "logistic_classifier.jld2",
    )
random_forest_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "random_forest_classifier.jld2",
    )
c_svc_svm_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "c_svc_svm_classifier.jld2",
    )
nu_svc_svm_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "nu_svc_svm_classifier.jld2",
    )
knet_mlp_classifier_filename = joinpath(
    tempdir(),
    "breast_cancer_biopsy_example",
    "knet_mlp_classifier.jld2",
    )

logistic_classifier = PredictMD.load_model(logistic_classifier_filename)
random_forest_classifier = PredictMD.load_model(random_forest_classifier_filename)
c_svc_svm_classifier = PredictMD.load_model(c_svc_svm_classifier_filename)
nu_svc_svm_classifier = PredictMD.load_model(nu_svc_svm_classifier_filename)

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
knet_mlp_classifier = PredictMD.load_model(knet_mlp_classifier_filename)

all_models = PredictMD.Fittable[
    logistic_classifier,
    random_forest_classifier,
    c_svc_svm_classifier,
    nu_svc_svm_classifier,
    knet_mlp_classifier,
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
