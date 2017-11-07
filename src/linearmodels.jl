using DataFrames
using DataTables
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

    feature_variables = dataset.blobs[:feature_variables]

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
    predicted_proba_training_verify_nullable = predict(
        model,
        DataTable(data_training_features),
        )
    predicted_proba_training_verify = convert(
        Vector,
        predicted_proba_training_verify_nullable,
        )
    @assert(all(predicted_proba_training .≈ predicted_proba_training_verify))
    predicted_proba_validation_nullable = predict(
        model,
        DataTable(data_validation_features),
        )
    predicted_proba_validation = convert(
        Vector,
        predicted_proba_validation_nullable,
        )
    predicted_proba_testing_nullable = predict(
        model,
        DataTable(data_testing_features),
        )
    predicted_proba_testing = convert(
        Vector,
        predicted_proba_testing_nullable
        )
    blobs[:predicted_proba_training] = predicted_proba_training
    blobs[:predicted_proba_validation] = predicted_proba_validation
    blobs[:predicted_proba_testing] = predicted_proba_testing

    predicted_labels_training = classify(predicted_proba_training')-1
    predicted_labels_validation = classify(predicted_proba_validation')-1
    predicted_labels_testing = classify(predicted_proba_testing')-1
    blobs[:predicted_labels_training] = predicted_labels_training
    blobs[:predicted_labels_validation] = predicted_labels_validation
    blobs[:predicted_labels_testing] = predicted_labels_testing

    data_labels_integer_thislabel =
        dataset.blobs[:data_labels_integer][label_variable]
    @assert(typeof(data_labels_integer_thislabel) <: StatsBase.IntegerVector)

    rows_training = dataset.blobs[:rows_training]
    rows_validation = dataset.blobs[:rows_validation]
    rows_testing = dataset.blobs[:rows_testing]
    @assert(typeof(rows_training) <: StatsBase.IntegerVector)
    @assert(typeof(rows_validation) <: StatsBase.IntegerVector)
    @assert(typeof(rows_testing) <: StatsBase.IntegerVector)

    blobs[:true_labels_training] =
        data_labels_integer_thislabel[rows_training]
    blobs[:true_labels_validation] =
        data_labels_integer_thislabel[rows_validation]
    blobs[:true_labels_testing] =
        data_labels_integer_thislabel[rows_testing]

    return SingleLabelBinaryLogisticClassifier(blobs)
end
