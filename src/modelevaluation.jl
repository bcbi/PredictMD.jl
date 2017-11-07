using MLBase
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

struct ModelPerformance <: AbstractModelPerformance
    blobs::T where T <: Associative
end

function ModelPerformance(model::AbstractModel)
    error("Not yet implemented for this model type.")
end

function ModelPerformance(model::AbstractSingleLabelBinaryClassifier)
    blobs = Dict{Symbol, Any}()

    ytrue_training = model.blobs[:true_labels_training]
    ypredlabel_training = model.blobs[:predicted_labels_training]
    ypredproba_training = model.blobs[:predicted_proba_training]
    blobs[:accuracy_training] = accuracy_score(
        ytrue_training,
        ypredlabel_training,
        )

    ytrue_validation = model.blobs[:true_labels_validation]
    ypredlabel_validation = model.blobs[:predicted_labels_validation]
    ypredproba_validation = model.blobs[:predicted_proba_validation]
    blobs[:accuracy_validation] = accuracy_score(
        ytrue_validation,
        ypredlabel_validation,
        )

    ytrue_testing = model.blobs[:true_labels_testing]
    ypredlabel_testing = model.blobs[:predicted_labels_testing]
    ypredproba_testing = model.blobs[:predicted_proba_testing]
    blobs[:accuracy_testing] = accuracy_score(
        ytrue_testing,
        ypredlabel_testing,
        )

    return ModelPerformance(blobs)
end

function Base.show(io::IO, mp::ModelPerformance)
    println(io, "Training set:")
    println(io, "\tAccuracy: $(mp.blobs[:accuracy_training])")

    println(io, "Testing set:")
    println(io, "\tAccuracy: $(mp.blobs[:accuracy_validation])")

    println(io, "Validation set:")
    println(io, "\tAccuracy: $(mp.blobs[:accuracy_testing])")
end
