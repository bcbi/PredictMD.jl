import DataFrames
import MLBase
import StatsBase

"""
"""
function singlelabelbinaryytrue(
        labels::AbstractVector,
        positive_class::AbstractString;
        inttype::Type=Int,
        )
    if !(inttype<:Integer)
        error("!(inttype<:Integer)")
    end
    result = inttype.(labels .== positive_class)
    return result
end

"""
"""
function singlelabelbinaryyscore(
        single_labelprobabilities::AbstractDict,
        positive_class::AbstractString;
        float_type::Type{<:AbstractFloat} = Float64,
        )
    result = float_type.(single_labelprobabilities[positive_class])
    return result
end

"""
"""
function singlelabelbinaryclassificationmetrics_tunableparam(
        kwargsassoc::AbstractDict,
        )
    tunableparams = [
        :threshold,
        :sensitivity,
        :specificity,
        :maximize,
        ]
    maximizableparams = [
        :f1score,
        :cohen_kappa,
        ]
    kwargshastunableparam = [
        haskey(kwargsassoc, x) for x in tunableparams
        ]
    if sum(kwargshastunableparam) != 1
        msg = "you must specify one (and only one) of the following: " *
            join(tunableparams, ", ")
        error(msg)
    end
    if length(tunableparams[kwargshastunableparam]) != 1
        error("oh boy you definitely should never see this error message")
    end
    selectedtunableparam =
        tunableparams[kwargshastunableparam][1]
    if selectedtunableparam == :maximize
        selectedparamtomax = kwargsassoc[:maximize]
        if !in(selectedparamtomax, maximizableparams)
            msg = "Cannot max $(selectedparamtomax). Select one " *
                "of the following: " * join(maximizableparams, ", ")
            error(msg)
        end
    else
        selectedparamtomax = :notapplicable
    end
    #
    metricdisplaynames = Dict()
    metricdisplaynames[:AUPRC] = string("AUPRC")
    metricdisplaynames[:AUROCC] = string("AUROCC")
    metricdisplaynames[:AveragePrecision] = string("Average precision")
    if selectedtunableparam == :threshold
        metricdisplaynames[:threshold] = string("[fix] * Threshold")
    else
        metricdisplaynames[:threshold] = string("* Threshold")
    end
    metricdisplaynames[:accuracy] = string("* Accuracy")
    if selectedtunableparam == :maximize && selectedparamtomax ==
            :cohen_kappa
        metricdisplaynames[:cohen_kappa] =
            string("[max] * Cohen's Kappa statistic")
    else
        metricdisplaynames[:cohen_kappa] =
            string("* Cohen's Kappa statistic")
    end
    if selectedtunableparam == :maximize && selectedparamtomax ==
            :f1score
        metricdisplaynames[:f1score] = string("[max] * F1 score")
    else
        metricdisplaynames[:f1score] = string("* F1 Score")
    end
    metricdisplaynames[:precision] =
        string("* Precision (positive predictive value)")
    metricdisplaynames[:negative_predictive_value] =
        string("* Negative predictive value")
    metricdisplaynames[:recall] =
        string("* Recall (sensitivity, true positive rate)")
    if selectedtunableparam == :sensitivity
        metricdisplaynames[:sensitivity] =
            string("[fix] * Sensitivity (recall, true positive rate)")
    else
        metricdisplaynames[:sensitivity] =
            string("* Sensitivity (recall, true positive rate)")
    end
    if selectedtunableparam == :specificity
        metricdisplaynames[:specificity] =
            string("[fix] * Specificity (true negative rate)")
    else
        metricdisplaynames[:specificity] =
            string("* Specificity (true negative rate)")
    end
    metricdisplaynames = fix_type(metricdisplaynames)
    return selectedtunableparam, selectedparamtomax, metricdisplaynames
end

"""
"""
function singlelabelbinaryclassificationmetrics_resultdict(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        kwargs...
        )
    #
    kwargsdict = Dict(kwargs)
    kwargsdict = fix_type(kwargsdict)
    selectedtunableparam, selectedparamtomax, metricdisplaynames =
        singlelabelbinaryclassificationmetrics_tunableparam(kwargsdict)
    #
    predictedprobabilitiesalllabels = predict_proba(estimator, features_df)
    yscore = Float64.(
        singlelabelbinaryyscore(
            predictedprobabilitiesalllabels[single_label_name],
            positive_class,
            )
        )
    ytrue = Int.(
        singlelabelbinaryytrue(
            labels_df[single_label_name],
            positive_class,
            )
        )
    results = Dict()
    results[:ytrue] = ytrue
    results[:yscore] = yscore
    results[:AUROCC] = aurocc(ytrue, yscore)
    results[:AUPRC] = auprc(ytrue, yscore)
    results[:AveragePrecision] = averageprecisionscore(ytrue, yscore)
    if selectedtunableparam == :threshold
        additionalthreshold = kwargsdict[:threshold]
    else
        additionalthreshold = 0.5
    end
    allrocnums, allthresholds = getallrocnums(
        ytrue,
        yscore;
        additionalthreshold = additionalthreshold,
        )
    if selectedtunableparam == :threshold
        selectedthreshold = kwargsdict[:threshold]
        bestindex = argmin(abs.(allthresholds .- selectedthreshold))
    elseif selectedtunableparam == :sensitivity
        selectedsensitivity = kwargsdict[:sensitivity]
        allsensitivity = [sensitivity(x) for x in allrocnums]
        bestindex = argmin(abs.(allsensitivity .- selectedsensitivity))
    elseif selectedtunableparam == :specificity
        selectedspecificity = kwargsdict[:specificity]
        allspecificity = [specificity(x) for x in allrocnums]
        bestindex = argmin(abs.(allspecificity .- selectedspecificity))
    elseif selectedtunableparam == :maximize
        selectedparamtomax = kwargsdict[:maximize]
        if selectedparamtomax == :f1score
            allf1score = [fbetascore(x, 1) for x in allrocnums]
            bestindex = argmin(allf1score)
        elseif selectedparamtomax == :cohen_kappa
            allcohen_kappa = [cohen_kappa(x) for x in allrocnums]
            bestindex = argmin(allcohen_kappa)
        else
            error("this is an error that should never happen")
        end
    else
        error("this is another error that should never happen")
    end

    results[:allrocnums] = allrocnums
    results[:allthresholds] = allthresholds
    results[:bestindex] = bestindex
    bestrocnums = allrocnums[bestindex]
    bestthreshold = allthresholds[bestindex]
    results[:threshold] = bestthreshold
    results[:accuracy] = accuracy(bestrocnums)
    results[:sensitivity] = sensitivity(bestrocnums)
    results[:specificity] = specificity(bestrocnums)
    results[:precision] = precision(bestrocnums)
    results[:negative_predictive_value] =
        negative_predictive_value(bestrocnums)
    results[:recall] = recall(bestrocnums)
    results[:f1score] = f1score(bestrocnums)
    results[:cohen_kappa] = cohen_kappa(bestrocnums)
    results = fix_type(results)
    return results
end

"""
"""
function singlelabelbinaryclassificationmetrics(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        kwargs...
        )
    vectorofestimators = Fittable[estimator]
    result = singlelabelbinaryclassificationmetrics(
        vectorofestimators,
        features_df,
        labels_df,
        single_label_name,
        positive_class;
        kwargs...
        )
    return result
end

"""
"""
function singlelabelbinaryclassificationmetrics(
        vectorofestimators::AbstractVector{Fittable},
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        kwargs...
        )
    kwargsdict = Dict(kwargs)
    kwargsdict = fix_type(kwargsdict)
    selectedtunableparam, selectedparamtomax, metricdisplaynames =
        singlelabelbinaryclassificationmetrics_tunableparam(kwargsdict)
    metricsforeachestimator = [
        singlelabelbinaryclassificationmetrics_resultdict(
            est,
            features_df,
            labels_df,
            single_label_name,
            positive_class;
            kwargs...
            )
            for est in vectorofestimators
        ]
    result = DataFrames.DataFrame()
    result[:metric] = [
        metricdisplaynames[:AUPRC],
        metricdisplaynames[:AUROCC],
        metricdisplaynames[:AveragePrecision],
        metricdisplaynames[:threshold],
        metricdisplaynames[:accuracy],
        metricdisplaynames[:cohen_kappa],
        metricdisplaynames[:f1score],
        metricdisplaynames[:precision],
        metricdisplaynames[:negative_predictive_value],
        metricdisplaynames[:recall],
        metricdisplaynames[:sensitivity],
        metricdisplaynames[:specificity],
        ]
    for i = 1:length(vectorofestimators)
        result[Symbol(vectorofestimators[i].name)] = [
            metricsforeachestimator[i][:AUPRC],
            metricsforeachestimator[i][:AUROCC],
            metricsforeachestimator[i][:AveragePrecision],
            metricsforeachestimator[i][:threshold],
            metricsforeachestimator[i][:accuracy],
            metricsforeachestimator[i][:cohen_kappa],
            metricsforeachestimator[i][:f1score],
            metricsforeachestimator[i][:precision],
            metricsforeachestimator[i][:negative_predictive_value],
            metricsforeachestimator[i][:recall],
            metricsforeachestimator[i][:sensitivity],
            metricsforeachestimator[i][:specificity],
            ]
    end
    return result
end

