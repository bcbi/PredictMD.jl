import DataFrames
# import ScikitLearn

# ScikitLearn.@sk_import metrics: accuracy_score
# ScikitLearn.@sk_import metrics: auc
# ScikitLearn.@sk_import metrics: average_precision_score
# ScikitLearn.@sk_import metrics: brier_score_loss
# ScikitLearn.@sk_import metrics: f1_score
# ScikitLearn.@sk_import metrics: precision_recall_curve
# ScikitLearn.@sk_import metrics: precision_score
# ScikitLearn.@sk_import metrics: recall_score
# ScikitLearn.@sk_import metrics: roc_auc_score
# ScikitLearn.@sk_import metrics: roc_curve

struct ModelPerformanceTable{M, T} <:
        AbstractModelPerformanceTable{M, T}
    model::M
    table::T
end

struct ModelPerformanceDataForPlots{M} <:
        AbstractModelPerformanceDataForPlots{M}
    model::M
    blobs
end

struct ModelPerformancePlots{M} <:
        AbstractModelPerformancePlots{M}
    model::M
end

function performance(
        model::AbstractModel;
        kwargs...
        )
    error("Not yet implemented for this model type.")
end

function performance(
        model::AbstractSingleLabelBinaryClassifier;
        )
    if hastraining(model)
        # numtrainingrows = numtraining(model)
        # ytrue_training = model.blobs[:true_labels_training]
        # ypredlabel_training = model.blobs[:predicted_labels_training]
        # ypredproba_training = model.blobs[:predicted_proba_training]
        # accuracy_training = accuracy_score(
        #     convert(Array, ytrue_training),
        #     convert(Array, ypredlabel_training),
        #     )
        # auroc_training = roc_auc_score(
        #     convert(Array, ytrue_training),
        #     convert(Array, ypredproba_training),
        #     )
        # f1_training = f1_score(
        #     convert(Array, ytrue_training),
        #     convert(Array, ypredlabel_training),
        #     )
        # precision_training, recall_training, thresholds_training =
        #     precisionrecalltraining(model)
        # aupr_training = auc(
        #     recall_training,
        #     precision_training,
        #     )
        # averageprecision_training = average_precision_score(
        #     convert(Array, ytrue_training),
        #     convert(Array, ypredproba_training),
        #     )
    end

    table_validation = DataFrame()
    if hasvalidation(model)
    end

    table_testing = DataFrame()
    if hastesting(model)
    end

    table = vcat(table_training, table_validation, table_testing)

    # table = DataFrames.DataFrame()
    # model_name = model.blobs[:model_name]
    # table[:Model] = [model_name, model_name, model_name]
    # table[:Subset] = ["Training", "Validation", "Testing"]
    # table[:N] = [numtrainingrows, numvalidationrows, numtestingrows]
    # table[:Accuracy] = [
    #     accuracy_training,
    #     accuracy_validation,
    #     accuracy_testing
    #     ]
    # table[:AUROC] = [auroc_training, auroc_validation, auroc_testing]
    # table[:F1_score] = [f1_training, f1_validation, f1_testing]
    # table[:AUPR] = [aupr_training, aupr_validation, aupr_testing]
    # table[:Average_precision] = [
    #     averageprecision_training,
    #     averageprecision_validation,
    #     averageprecision_testing,
    #     ]

    return ModelPerformanceTable(model, table)

end

# function roctraining(model::AbstractSingleLabelBinaryClassifier)
#     if !hastraining(model)
#         error("model has no training data")
#     end
#     y_true = Int.(model.blobs[:true_labels_training])
#     y_score = model.blobs[:predicted_proba_training_onecol]
#     fpr, tpr, thresholds = roc_curve(y_true, y_score)
#     return fpr, tpr, thresholds
# end

# function precisionrecalltraining(model::AbstractSingleLabelBinaryClassifier)
#     if !hastraining(model)
#         error("model has no training data")
#     end
#     y_true = Int.(model.blobs[:true_labels_training])
#     probas_pred = model.blobs[:predicted_proba_training_onecol]
#     precision, recall, thresholds = precision_recall_curve(
#         y_true,
#         probas_pred,
#         )
# end
