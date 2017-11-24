import DataFrames
import MLBase
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
    table::T
end

struct ModelPerformanceDataForPlots{M} <:
        AbstractModelPerformanceDataForPlots{M}
    blobs
end

struct ModelPerformancePlots{M} <:
        AbstractModelPerformancePlots{M}
    blobs
end

function performance{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    return ModelPerformanceTable(model; kwargs...)
end

function ModelPerformanceTable{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function ModelPerformanceDataForPlots{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function plot{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    return ModelPerformancePlots(model; kwargs...)
end

function ModelPerformancePlots{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function ModelPerformanceTable{M<:AbstractSingleLabelBinaryClassifier}(
        model::M;
        threshold::Real = 0.5,
        )
    table_training = DataFrames.DataFrame()
    if hastraining(model)
    end

    table_validation = DataFrames.DataFrame()
    if hasvalidation(model)
    end

    table_testing = DataFrames.DataFrame()
    if hastesting(model)
    end

    table = vcat(
        table_training,
        table_validation,
        table_testing,
        )
    return ModelPerformanceTable{M, DataFrames.DataFrame}(table)
end

function _modelperformancetablerow!(
        table_subset::DataFrames.DataFrame,
        model::M where M <: AbstractSingleLabelBinaryClassifier,
        subset::Symbol,
        threshold::Real,
        )
    if !(0 <== threshold <== 1)
        error("threshold must be >==0 and <==1")
    end
    threshold = max(threshold, 0+eps())
    threshold = min(threshold, 1-eps())
    numrows, ytrue, yscore = _get_numrow_sytrue_yscore(model, subset)
    @assert(
        all(
            [y in [0,1] for y in ytrue]
            )
        )
    @assert(
        all(
            0 .<= yscore .<= 1
            )
        )
    selected_threshold = threshold
    all_thresholds = sort(
        unique(
            vcat(
                setdiff(yscore, [0, 1]),
                0 + eps(),
                1 - eps(),
                selected_threshold,
                )
            )
        )
    @assert(
        typeof(all_thresholds) <: AbstractVector
        )
    num_thresholds = length(all_thresholds)
    all_rocnums = MLBase.roc(
        ytrue,
        yscore,
        all_thresholds,
        MLBase.Forward,
        )
    #
    all_accuracy = [accuracy(r) for r in all_rocnums]
    # replacenan!(all_accuracy, "NaN")
    all_sensitivity = [MLBase.true_positive_rate(r) for r in all_rocnums]
    # replacenan!(all_sensitivity, "NaN")
    all_specificity = [MLBase.true_negative_rate(r) for r in all_rocnums]
    # replacenan!(all_specificity, "NaN")
    all_ppv = [ppv(r) for r in all_rocnums]
    # replacenan!(all_ppv, "NaN")
    all_npv = [npv(r) for r in all_rocnums]
    # replacenan!(all_npv, "NaN")
    all_precision = [MLBase.precision(r) for r in all_rocnums]
    # replacenan!(all_precision, 1)
    all_recall = [MLBase.recall(r) for r in all_rocnums]
    # replacenan!(all_recall, "NaN")
    all_f1score_verify = [MLBase.f1score(r) for r in all_rocnums]
    # replacenan!(all_f1score_verify, "NaN")
    all_f1score = [fbetascore(r,1) for r in all_rocnums]
    # replacenan!(all_f1score, 0)
    @assert(
        all(
            all_f1score_verify .≈ all_f1score
            )
        )
    all_f2score = [fbetascore(r,2) for r in all_rocnums]
    # replacenan!(all_f2score, "NaN")
    all_f0point5score = [fbetascore(r,0.5) for r in all_rocnums]
    # replacenan!(all_f0point5score, "NaN")
    #
    selected_indexes = find(all_thresholds.==0.5)
    selected_index = selected_indexes[1]
    #
    selected_accuracy = all_accuracy[selected_index]
    selected_sensitivity = all_sensitivity[selected_index]
    selected_specificity = all_specificity[selected_index]
    selected_ppv = all_ppv[selected_index]
    selected_npv = all_npv[selected_index]
    selected_precision = all_precision[selected_index]
    selected_recall = all_recall[selected_index]
    selected_f1score = all_f1score[selected_index]
    selected_f2score = all_f2score[selected_index]
    selected_f0point5score = all_f0point5score[selected_index]
    #
    all_tpr = all_sensitivity
    all_fpr = 1 - all_specificity
    auroc = trapz(all_fpr, all_tpr)
    println("AUROC: $(auroc)")
    aupr = trapz(all_recall, all_precision)
    println("AUPR: $(aupr)")
end

# function performance(
        # model::M where M <: AbstractSingleLabelBinaryClassifier;
        # )
    # if hastraining(model)

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
    # end
    #
    # table_validation = DataFrame()
    # if hasvalidation(model)
    # end
    #
    # table_testing = DataFrame()
    # if hastesting(model)
    # end

    # table = vcat(table_training, table_validation, table_testing)

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

    # return ModelPerformanceTable{M}(table)

# end

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

function _get_numrows_ytrue_yscore(
        model::M where M <: AbstractSingleLabelBinaryClassifier,
        subset::Symbol,
        )
    if subset == :training
        numrows = numtraining(model)
        ytrue = model.blobs[:true_labels_training]
        yscore = model.blobs[:predicted_proba_training]
        return numrows, ytrue, yscore
    elseif subset == :validation
        numrows = numvalidation(model)
        ytrue = model.blobs[:true_labels_validation]
        yscore = model.blobs[:predicted_proba_validation]
        return numrows, ytrue, yscore
    elseif subset == :testing
        numrows = numtesting(model)
        ytrue = model.blobs[:true_labels_testing]
        yscore = model.blobs[:predicted_proba_testing]
        return numrows, ytrue, yscore
    else
        error("subset must be one of :training, :validation, :testing")
    end
end
