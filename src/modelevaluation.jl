import DataFrames
import ScikitLearn

ScikitLearn.@sk_import metrics: accuracy_score
ScikitLearn.@sk_import metrics: auc
ScikitLearn.@sk_import metrics: average_precision_score
ScikitLearn.@sk_import metrics: brier_score_loss
ScikitLearn.@sk_import metrics: f1_score
ScikitLearn.@sk_import metrics: precision_recall_curve
ScikitLearn.@sk_import metrics: precision_score
ScikitLearn.@sk_import metrics: recall_score
ScikitLearn.@sk_import metrics: roc_auc_score
ScikitLearn.@sk_import metrics: roc_curve

const notapplicable = "---"

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
        f1_training = f1_score(
            convert(Array, ytrue_training),
            convert(Array, ypredlabel_training),
            )
        precision_training, recall_training, thresholds_training =
            precisionrecalltraining(model)
        aupr_training = auc(
            recall_training,
            precision_training,
            )
        averageprecision_training = average_precision_score(
            convert(Array, ytrue_training),
            convert(Array, ypredproba_training),
            )
    else
        numtrainingrows = notapplicable
        accuracy_training = notapplicable
        auroc_training = notapplicable
        f1_training = notapplicable
        aupr_training = notapplicable
        averageprecision_training = notapplicable
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
        f1_validation = f1_score(
            convert(Array, ytrue_validation),
            convert(Array, ypredlabel_validation),
            )
        precision_validation, recall_validation, thresholds_validation =
            precisionrecallvalidation(model)
        aupr_validation = auc(
            recall_validation,
            precision_validation,
            )
        averageprecision_validation = average_precision_score(
            convert(Array, ytrue_validation),
            convert(Array, ypredproba_validation),
            )
    else
        numvalidationrows = notapplicable
        accuracy_validation = notapplicable
        auroc_validation = notapplicable
        f1_validation = notapplicable
        aupr_validation = notapplicable
        averageprecision_validation = notapplicable
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
        f1_testing = f1_score(
            convert(Array, ytrue_testing),
            convert(Array, ypredlabel_testing),
            )
        precision_testing, recall_testing, thresholds_testing =
            precisionrecalltesting(model)
        aupr_testing = auc(
            recall_testing,
            precision_testing,
            )
        averageprecision_testing = average_precision_score(
            convert(Array, ytrue_testing),
            convert(Array, ypredproba_testing),
            )
    else
        numtestingrows = notapplicable
        accuracy_testing = notapplicable
        auroc_testing = notapplicable
        f1_testing = notapplicable
        aupr_testing = notapplicable
        averageprecision_testing = notapplicable
    end

    results = DataFrames.DataFrame()
    model_name = model.blobs[:model_name]
    results[:Model] = [model_name, model_name, model_name]
    results[:Subset] = ["Training", "Validation", "Testing"]
    results[:N] = [numtrainingrows, numvalidationrows, numtestingrows]
    results[:Accuracy] = [
        accuracy_training,
        accuracy_validation,
        accuracy_testing
        ]
    results[:AUROC] = [auroc_training, auroc_validation, auroc_testing]
    results[:F1_score] = [f1_training, f1_validation, f1_testing]
    results[:AUPR] = [aupr_training, aupr_validation, aupr_testing]
    results[:Average_precision] = [
        averageprecision_training,
        averageprecision_validation,
        averageprecision_testing,
        ]

    return results

end

function roctraining(model::AbstractSingleLabelBinaryClassifier)
    if !hastraining(model)
        error("model has no training data")
    end
    y_true = Int.(model.blobs[:true_labels_training])
    y_score = model.blobs[:predicted_proba_training_onecol]
    fpr, tpr, thresholds = roc_curve(y_true, y_score)
    return fpr, tpr, thresholds
end

function rocvalidation(model::AbstractSingleLabelBinaryClassifier)
    if !hasvalidation(model)
        error("model has no validation data")
    end
    y_true = Int.(model.blobs[:true_labels_validation])
    y_score = model.blobs[:predicted_proba_validation_onecol]
    fpr, tpr, thresholds = roc_curve(y_true, y_score)
    return fpr, tpr, thresholds
end

function roctesting(model::AbstractSingleLabelBinaryClassifier)
    if !hastesting(model)
        error("model has no testing data")
    end
    y_true = Int.(model.blobs[:true_labels_testing])
    y_score = model.blobs[:predicted_proba_testing_onecol]
    fpr, tpr, thresholds = roc_curve(y_true, y_score)
    return fpr, tpr, thresholds
end

function precisionrecalltraining(model::AbstractSingleLabelBinaryClassifier)
    if !hastraining(model)
        error("model has no training data")
    end
    y_true = Int.(model.blobs[:true_labels_training])
    probas_pred = model.blobs[:predicted_proba_training_onecol]
    precision, recall, thresholds = precision_recall_curve(
        y_true,
        probas_pred,
        )
end

function precisionrecallvalidation(model::AbstractSingleLabelBinaryClassifier)
    if !hasvalidation(model)
        error("model has no validation data")
    end
    y_true = Int.(model.blobs[:true_labels_validation])
    probas_pred = model.blobs[:predicted_proba_validation_onecol]
    precision, recall, thresholds = precision_recall_curve(
        y_true,
        probas_pred,
        )
end

function precisionrecalltesting(model::AbstractSingleLabelBinaryClassifier)
    if !hastesting(model)
        error("model has no testing data")
    end
    y_true = Int.(model.blobs[:true_labels_testing])
    probas_pred = model.blobs[:predicted_proba_testing_onecol]
    precision, recall, thresholds = precision_recall_curve(
        y_true,
        probas_pred,
        )
end
