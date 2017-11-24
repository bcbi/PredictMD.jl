import DataFrames
import MLBase
import Plots

#############################################################################

struct ModelPerformance{M} <:
        AbstractModelPerformance{M}
    blobs::A where A <: Associative
end

function ModelPerformance{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function ModelPerformance{M<:AbstractSingleLabelBinaryClassifier}(
        model::M;
        kwargs...
        )
    subsetblobs = Dict()
    #
    if hastraining(model)
        table_training, blobs_training = _modelperformancetablerow(
            model,
            :Training;
            kwargs...
            )
        subsetblobs[:training] = blobs_training
    else
        table_training = DataFrames.DataFrame()
    end
    #
    if hasvalidation(model)
        table_validation, blobs_validation = _modelperformancetablerow(
            model,
            :Validation;
            kwargs...
            )
        subsetblobs[:validation] = blobs_validation
    else
        table_validation = DataFrames.DataFrame()
    end
    #
    if hastesting(model)
        table_testing, blobs_testing = _modelperformancetablerow(
            model,
            :Testing;
            kwargs...
            )
        subsetblobs[:testing] = blobs_testing
    else
        table_testing = DataFrames.DataFrame()
    end
    #
    table = vcat(
        table_training,
        table_validation,
        table_testing,
        )
    #
    blobs = Dict()
    blobs[:table] = table
    blobs[:subsetblobs] = subsetblobs
    return ModelPerformance{M}(blobs)
end

function _modelperformancetablerow(
        model::M where M <: AbstractSingleLabelBinaryClassifier,
        subset::Symbol;
        kwargs...
        )
    table_subset = DataFrames.DataFrame()
    numrows, y_true, y_score = _get_numrows_y_true_y_score(model, subset)
    metricblobs = _binaryclassifiermetrics(
        ensurevector(y_true),
        ensurevector(y_score);
        kwargs...
        )
    table_subset[:Subset] = string(subset)
    table_subset[:N] = numrows
    table_subset[:AUROCC] = metricblobs[:AUROCC]
    table_subset[:AUPRC] = metricblobs[:AUPRC]
    threshold, ind = _selectbinaryclassifierthreshold(
        metricblobs;
        kwargs...
        )
    @assert(threshold == metricblobs[:all_thresholds][ind])
    table_subset[:Threshold] = threshold
    table_subset[:Accuracy] = metricblobs[:all_accuracy][ind]
    table_subset[:Sensitivity] = metricblobs[:all_sensitivity][ind]
    table_subset[:Specificity] = metricblobs[:all_specificity][ind]
    table_subset[:Precision] = metricblobs[:all_precision][ind]
    table_subset[:Recall] = metricblobs[:all_recall][ind]
    table_subset[:F1_Score] = metricblobs[:all_f1score][ind]
    table_subset[:F2_Score] = metricblobs[:all_f2score][ind]
    table_subset[:F0pt5_Score] = metricblobs[:all_f0pt5score][ind]
    return table_subset
end

function _get_numrows_y_true_y_score(
        model::M where M <: AbstractSingleLabelBinaryClassifier,
        subset::Symbol,
        )
    if subset == :Training
        if hastraining(model)
            numrows = numtraining(model)
            y_true = model.blobs[:true_labels_training]
            y_score = model.blobs[:predicted_proba_training]
            return numrows, y_true, y_score
        else
            error("model does not have a training subset")
        end
    elseif subset == :Validation
        if hasvalidation(model)
            numrows = numvalidation(model)
            y_true = model.blobs[:true_labels_validation]
            y_score = model.blobs[:predicted_proba_validation]
            return numrows, y_true, y_score
        else
            error("model does not have a validation subset")
        end
    elseif subset == :Testing
        if hastesting(model)
            numrows = numtesting(model)
            y_true = model.blobs[:true_labels_testing]
            y_score = model.blobs[:predicted_proba_testing]
            return numrows, y_true, y_score
        else
            error("model does not have a testing subset")
        end
    else
        error("subset must be one of :Training, :Validation, :Testing")
    end
end

function _binaryclassifiermetrics(
        y_true::StatsBase.IntegerVector,
        y_score::StatsBase.RealVector;
        kwargs...
        )
    kwargs_dict = Dict(kwargs)
    if haskey(kwargs_dict, :threshold)
        additional_threshold = kwargs_dict[:threshold]
    else
        additional_threshold = 0
    end
    metricblobs = Dict()
    if length(y_true) != length(y_score)
        error("y_true and y_score must have the same length")
    end
    if length(y_true) == 0
        error("y_true must be non-empy")
    end
    y_true_uniqueset = Set(y_true)
    if y_true_uniqueset != Set([0, 1])
        if y_true_uniqueset == Set([0])
            warn("only one class (0) is present in y_true")
        elseif y_true_uniqueset == Set([1])
            warn("only one class (1) is present in y_true")
        else
            error("y_true contains values other than 0 and 1")
        end
    end
    if !all( 0 .<= y_score .<= 1  )
        error("every element in y_score must be >=0 and <=1")
    end
    #
    all_thresholds = sort(
        unique(
            vcat(
                y_score,
                additional_threshold,
                DEFAULTBINARYTHRESHOLD,
                0 - eps(),
                0,
                0 + eps(),
                1 - eps(),
                1,
                1 + eps(),
                )
            )
        )
    metricblobs[:all_thresholds] = all_thresholds
    #
    all_rocnums = MLBase.roc(
        y_true,
        y_score,
        all_thresholds,
        MLBase.Forward,
        )
    metricblobs[:all_rocnums] = all_rocnums
    #
    all_accuracy =
        [accuracy_nanfixed(r) for r in all_rocnums]
    metricblobs[:all_accuracy] = all_accuracy
    #
    all_sensitivity =
        [true_positive_rate_nanfixed(r) for r in all_rocnums]
    metricblobs[:all_sensitivity] = all_sensitivity
    #
    all_specificity =
        [true_negative_rate_nanfixed(r) for r in all_rocnums]
    metricblobs[:all_specificity] = all_specificity
    #
    all_precision =
        [precision_nanfixed(r) for r in all_rocnums]
    metricblobs[:all_precision] = all_precision
    #
    all_recall =
        [recall_nanfixed(r) for r in all_rocnums]
    metricblobs[:all_recall] =all_recall
    #
    @assert( all( all_sensitivity .== all_recall ) )
    #
    all_f1score = fbetascore(all_precision, all_recall, 1)
    metricblobs[:all_f1score] = all_f1score
    #
    all_f2score = fbetascore(all_precision, all_recall, 2)
    metricblobs[:all_f2score] = all_f2score
    #
    all_f0pt5score = fbetascore(all_precision, all_recall, 0.5)
    metricblobs[:all_f0pt5score] = all_f0pt5score
    #
    all_fpr = 1 - all_specificity
    all_tpr = all_sensitivity
    aurocc = trapz(all_fpr, all_tpr)
    metricblobs[:AUROCC] = aurocc
    #
    auprc = trapz(all_recall, all_precision)
    metricblobs[:AUPRC] = auprc
    #
    return metricblobs
end

function _getparametertouseforselectingthreshold(
        ;
        kwargs...
        )
    kwargs_dict = Dict(kwargs)
    possible_parameters = [
        :maximize,
        :threshold,
        :sensitivity,
        :specificity,
        :precision,
        :recall,
        :f1score,
        :f0pt5score,
        ]
    num_possible_parameters = length(possible_parameters)
    parameters_provided = trues(num_possible_parameters)
    for i = 1:num_possible_parameters
        parameters_provided[i] = haskey(kwargs_dict, possible_parameters[i])
    end
    num_parameters_actuallyprovided = sum(parameters_provided)
    if num_parameters_actuallyprovided == 0
        return :threshold, DEFAULTBINARYTHRESHOLD
    elseif num_parameters_actuallyprovided == 1
        sel_param_index = find(parameters_provided)[1]
        sel_param = possible_parameters[sel_param_index]
        sel_param_val = kwargs_dict[sel_param]
        possible_to_maximize = [
            :precision,
            :f1score,
            :f2score,
            :f0pt5score,
            ]
        if sel_param==:maximize && !(sel_param_val in possible_to_maximize)
            error("$(sel_param_val) is not a valid value for :maximize")
        end
        return sel_param, sel_param_val
    else
        error("you cannot provide more than one threshold-tuning param.")
    end
end

function _selectbinaryclassifierthreshold(
        metricblobs;
        kwargs...
        )
    parameter, parameter_value = _getparametertouseforselectingthreshold(
        ;
        kwargs...
        )
    if parameter == :maximize
        if parameter_value == :precision
            ind = indmax(metricblobs[:all_precision])
        elseif parameter_value == :f1score
            ind = indmax(metricblobs[:all_f1score])
        elseif parameter_value == :f2score
            ind = indmax(metricblobs[:all_f2score])
        elseif parameter_value == :f0pt5score
            ind = indmax(metricblobs[:all_f0pt5score])
        else
            error("whoops something bad happened")
        end
    elseif parameter == :threshold
        ind = findnearest(metricblobs[:all_thresholds], parameter_value)[1]
    elseif parameter == :sensitivity
        ind = findnearest(metricblobs[:all_sensitivity], parameter_value)[1]
    elseif parameter == :specificity
        ind = findnearest(metricblobs[:all_specificity], parameter_value)[1]
    elseif parameter == :precision
        ind = findnearest(metricblobs[:all_precision], parameter_value)[1]
    elseif parameter == :recall
        ind = findnearest(metricblobs[:all_recall], parameter_value)[1]
    elseif parameter == :f1score
        ind = findnearest(metricblobs[:all_f1score], parameter_value)[1]
    else
        error("oh no something bad happened")
    end
    threshold = metricblobs[:all_thresholds][ind]
    return threshold, ind
end

function performance{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    return ModelPerformance(model; kwargs...).blobs[:table]
end

function hastraining(
        mp::ModelPerformance{M<:AbstractSingleLabelBinaryClassifier}
        )
    return haskey(mp.blobs.subsetblobs, :training)
end

function hasvalidation(
        mp::ModelPerformance{M<:AbstractSingleLabelBinaryClassifier}
        )
    return haskey(mp.blobs.subsetblobs, :validation)
end

function hastesting(
        mp::ModelPerformance{M<:AbstractSingleLabelBinaryClassifier}
        )
    return haskey(mp.blobs.subsetblobs, :testing)
end

#############################################################################

struct ModelPerformanceDataForPlots{M} <:
        AbstractModelPerformanceDataForPlots{M}
    blobs::A where A <: Associative
end

function ModelPerformanceDataForPlots{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    return ModelPerformanceDataForPlots(
        ModelPerformance(model);
        kwargs...
        )
end

function ModelPerformanceDataForPlots{M<:AbstractModelly}(
        mp::ModelPerformance{M};
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function ModelPerformanceDataForPlots{M<:AbstractSingleLabelBinaryClassifier}(
        mp::ModelPerformance{M};
        kwargs...
        )
    blobs = Dict()
    if hastraining(mp)
        training_blobs = Dict()
        training_blobs[:fpr] = mp.blobs.subsetblobs[:training][:all_fpr]
        training_blobs[:tpr] = mp.blobs.subsetblobs[:training][:all_ftr]
        blobs[:training] = training_blobs
    end
    if hasvalidation(mp)
        validation_blobs = Dict()
        validation_blobs[:fpr] = mp.blobs.subsetblobs[:validation][:all_fpr]
        validation_blobs[:tpr] = mp.blobs.subsetblobs[:validation][:all_ftr]
        blobs[:validation] = validation_blobs
    end
    if hastesting(mp)
        testing_blobs = Dict()
        testing_blobs[:fpr] = mp.blobs.subsetblobs[:validation][:all_fpr]
        testing_blobs[:tpr] = mp.blobs.subsetblobs[:validation][:all_ftr]
        blobs[:testing] = testing_blobs
    end
    return ModelPerformanceDataForPlots{M}(blobs)
end

#############################################################################

struct ModelPerformancePlots{M} <:
        AbstractModelPerformancePlots{M}
    blobs::A where A <: Associative
end

function ModelPerformancePlots{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function ModelPerformancePlots{M<:AbstractSingleLabelBinaryClassifier}(
        model::M;
        kwargs...
        )
    mpdfp = ModelPerformanceDataForPlots(model; kwargs...)
    println("hello 3")
end

function plot{M<:AbstractModelly}(
        model::M;
        kwargs...
        )
    return plot(
        ModelPerformancePlots(model; kwargs...);
        kwargs...
        )
end

function plot{M<:AbstractModelly}(
        mpp::ModelPerformancePlots{M};
        kwargs...
        )
    error("Not yet implemented for model type $(M)")
end

function plot{M<:AbstractSingleLabelBinaryClassifier}(
        mpp::ModelPerformancePlots{M};
        kwargs...
        )
    println("hello 2")
end

#############################################################################
