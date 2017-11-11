using MLBase
using NamedArrays
using ScikitLearn

@sk_import metrics: accuracy_score
@sk_import metrics: auc
@sk_import metrics: average_precision_score
@sk_import metrics: brier_score_loss
@sk_import metrics: f1_score
@sk_import metrics: precision_recall_curve
@sk_import metrics: precision_score
@sk_import metrics: recall_score
@sk_import metrics: roc_auc_score
@sk_import metrics: roc_curve

function performance(
        model::AbstractModel;
        kwargs...,
        )
    performance(
        STDOUT,
        model;
        kwargs...
        )
end

function performance(
        io::IO,
        model::AbstractModel;
        kwargs...
        )
    error("Not yet implemented for this model type.")
end

function performance(
        io::IO,
        model::AbstractSingleLabelBinaryClassifier;
        )
    if hastraining(model)
        numtrainingrows = numtraining(model)
        ytrue_training = model.blobs[:true_labels_training]
        ypredlabel_training = model.blobs[:predicted_labels_training]
        ypredproba_training = model.blobs[:predicted_proba_training]
        accuracy_training = accuracy_score(
            convert(Array, ytrue_training),
            convert(Array, ypredlabel_training),
            )
        auroc_training = roc_auc_score(
            convert(Array, ytrue_training),
            convert(Array, ypredproba_training),
            )
    else
        numtrainingrows = 0
        accuracy_training = "N/A"
        auroc_training = "N/A"
    end

    if hasvalidation(model)
        numvalidationrows = numvalidation(model)
        ytrue_validation = model.blobs[:true_labels_validation]
        ypredlabel_validation = model.blobs[:predicted_labels_validation]
        ypredproba_validation = model.blobs[:predicted_proba_validation]
        accuracy_validation = accuracy_score(
            convert(Array, ytrue_validation),
            convert(Array, ypredlabel_validation),
            )
        auroc_validation = roc_auc_score(
            convert(Array, ytrue_validation),
            convert(Array, ypredproba_validation),
            )
    else
        numvalidationrows = 0
        accuracy_validation = "N/A"
        auroc_validation = "N/A"
    end

    if hastesting(model)
        numtestingrows = numtesting(model)
        ytrue_testing = model.blobs[:true_labels_testing]
        ypredlabel_testing = model.blobs[:predicted_labels_testing]
        ypredproba_testing = model.blobs[:predicted_proba_testing]
        accuracy_testing = accuracy_score(
            convert(Array, ytrue_testing),
            convert(Array, ypredlabel_testing),
            )
        auroc_testing = roc_auc_score(
            convert(Array, ytrue_testing),
            convert(Array, ypredproba_testing),
            )
    else
        numvalidationrows = 0
        accuracy_testing = "N/A"
        auroc_testing = "N/A"
    end

    table_array = [
        accuracy_training auroc_training;
        accuracy_validation auroc_validation;
        accuracy_testing auroc_testing;
        ]
    table_namedarray = NamedArray(table_array)
    setdimnames!(
        table_namedarray,
        "Data subset",
        1,
        )
    setdimnames!(
        table_namedarray,
        "Metric",
        2,
        )
    setnames!(
        table_namedarray,
        [
            "Training (n=$(numtrainingrows))",
            "Validation (n=$(numvalidationrows))",
            "Testing (n=$(numtestingrows))",
            ],
        1,
        )
    setnames!(
        table_namedarray,
        [
            "Accuracy¹",
            "AUROC",
            ],
        2,
        )
    println(io, "Classification metrics:")
    println(io, "=======================")
    println(io, table_namedarray)
    println(io, "¹ = calculated at threshold=0.5")
    println(io, TAGLINE)

end
