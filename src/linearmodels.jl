using DataFrames
using GLM
using MLBase
using IterableTables
using StatsBase

struct SingleLabelBinaryLogisticClassifier <:
        AbstractSingleLabelBinaryClassifier
    blobs::T where T <: Associative
end

function SingleLabelBinaryLogisticClassifier(
        dataset::AbstractHoldoutTabularDataset,
        label_variable::Symbol;
        intercept::Bool = true,
        )

    blobs = Dict{Symbol, Any}()

    feature_variables = get_feature_variables(dataset)
    model_formula = generate_formula(
        label_variable,
        feature_variables,
        intercept = intercept,
        )
    blobs[:model_formula] = model_formula

    data_training_labelandfeatures, recordids_training =
        getdata(
            dataset;
            training = true,
            single_label = true,
            label_variable = label_variable,
            label_type = :integer,
            features = true,
            )

    blobs[:data_training_labelandfeatures] = data_training_labelandfeatures

    data_training_features =
        data_training_labelandfeatures[:, feature_variables]
    data_validation_features, recordids_validation =
        getdata(
            dataset;
            validation = true,
            features = true,
            )
    data_testing_features, recordids_testing =
        getdata(
            dataset;
            testing = true,
            features = true,
            )
    blobs[:recordids_training] = recordids_training
    blobs[:recordids_validation] = recordids_validation
    blobs[:recordids_testing] = recordids_testing

    model = glm(
        model_formula,
        data_training_labelandfeatures,
        Binomial(),
        LogitLink(),
        )

    blobs[:model] = model

    predicted_proba_training = predict(model)
    # predicted_proba_training_verify = predict(
    #     model,
    #     data_training_features,
    #     )
    # @assert(all(predicted_proba_training .≈ predicted_proba_training_verify))
    # predicted_proba_validation = predict(
    #     model,
    #     data_validation_features,
    #     )
    # predicted_proba_testing = predict(
    #     model,
    #     data_testing_features,
    #     )
    blobs[:predicted_proba_training] = predicted_proba_training
    # blobs[:predicted_proba_validation] = predicted_proba_validation
    # blobs[:predicted_proba_testing] = predicted_proba_testing
    #
    predicted_labels_training = classify(predicted_proba_training')-1
    # predicted_labels_validation = classify(predicted_proba_validation')-1
    # predicted_labels_testing = classify(predicted_proba_testing')-1
    # blobs[:predicted_labels_training] = predicted_labels_training
    # blobs[:predicted_labels_validation] = predicted_labels_validation
    # blobs[:predicted_labels_testing] = predicted_labels_testing

    return SingleLabelBinaryLogisticClassifier(blobs)
end
