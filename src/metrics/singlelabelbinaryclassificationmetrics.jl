import DataFrames
import MLBase
import StatsBase

function singlelabelbinaryytrue(
        labels::AbstractVector,
        positiveclass::AbstractString;
        inttype::Type = Int,
        )
    if !(inttype <: Integer)
        error("!(inttype <: Integer)")
    end
    result = inttype.(labels .== positiveclass)
    return result
end

function singlelabelbinaryyscore(
        singlelabelprobabilities::Associative,
        positiveclass::AbstractString;
        floattype::Type = Cfloat,
        )
    if !(floattype <: AbstractFloat)
        error("!(floattype <: AbstractFloat)")
    end
    result = floattype.(singlelabelprobabilities[positiveclass])
    return result
end

function _singlelabelbinaryclassclassificationmetrics_tunableparam(
        kwargsassoc::Associative,
        )
    tunableparams = [
        :threshold,
        :sensitivity,
        :specificity,
        :maximize,
        ]
    maximizableparams = [
        :f1score,
        :cohenkappa,
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
    metricprintnames = Dict()
    metricprintnames[:AUPRC] = string("AUPRC")
    metricprintnames[:AUROCC] = string("AUROCC")
    metricprintnames[:AveragePrecision] = string("Average precision")
    if selectedtunableparam == :threshold
        metricprintnames[:threshold] = string("[fix] * Threshold")
    else
        metricprintnames[:threshold] = string("* Threshold")
    end
    metricprintnames[:accuracy] = string("* Accuracy")
    if selectedtunableparam == :maximize && selectedparamtomax == :cohenkappa
        metricprintnames[:cohenkappa] =
            string("[max] * Cohen's Kappa statistic")
    else
        metricprintnames[:cohenkappa] =
            string("* Cohen's Kappa statistic")
    end
    if selectedtunableparam == :maximize && selectedparamtomax == :f1score
        metricprintnames[:f1score] = string("[max] * F1 score")
    else
        metricprintnames[:f1score] = string("* F1 Score")
    end
    metricprintnames[:precision] = string("* Precision")
    metricprintnames[:recall] = string("* Recall")
    if selectedtunableparam == :sensitivity
        metricprintnames[:sensitivity] = string("[fix] * Sensitivity")
    else
        metricprintnames[:sensitivity] = string("* Sensitivity")
    end
    if selectedtunableparam == :specificity
        metricprintnames[:specificity] = string("[fix] * Specificity")
    else
        metricprintnames[:specificity] = string("* Specificity")
    end
    return selectedtunableparam, selectedparamtomax, metricprintnames
end

function _singlelabelbinaryclassclassificationmetrics(
        estimator::Fittable,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    #
    kwargsdict = Dict(kwargs)
    selectedtunableparam, selectedparamtomax, metricprintnames =
        _singlelabelbinaryclassclassificationmetrics_tunableparam(kwargsdict)
    #
    predictedprobabilitiesalllabels = predict_proba(estimator, featuresdf)
    yscore = Cfloat.(
        singlelabelbinaryyscore(
            predictedprobabilitiesalllabels[singlelabelname],
            positiveclass,
            )
        )
    ytrue = Int.(
        singlelabelbinaryytrue(
            labelsdf[singlelabelname],
            positiveclass,
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
        bestindex = indmin(abs.(allthresholds - selectedthreshold))
    elseif selectedtunableparam == :sensitivity
        selectedsensitivity = kwargsdict[:sensitivity]
        allsensitivity = [sensitivity(x) for x in allrocnums]
        bestindex = indmin(abs.(allsensitivity - selectedsensitivity))
    elseif selectedtunableparam == :specificity
        selectedspecificity = kwargsdict[:specificity]
        allspecificity = [specificity(x) for x in allrocnums]
        bestindex = indmin(abs.(allspecificity - selectedspecificity))
    elseif selectedtunableparam == :maximize
        selectedparamtomax = kwargsdict[:maximize]
        if selectedparamtomax == :f1score
            allf1score = [fbetascore(x, 1) for x in allrocnums]
            bestindex = indmax(allf1score)
        elseif selectedparamtomax == :cohenkappa
            allcohenkappa = [cohenkappa(x) for x in allrocnums]
            bestindex = indmax(allcohenkappa)
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
    results[:recall] = recall(bestrocnums)
    results[:f1score] = f1score(bestrocnums)
    results[:cohenkappa] = cohenkappa(bestrocnums)
    return results
end

function singlelabelbinaryclassclassificationmetrics(
        estimator::Fittable,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    vectorofestimators = [estimator]
    result = singlelabelbinaryclassclassificationmetrics(
        vectorofestimators,
        featuresdf,
        labelsdf,
        singlelabelname,
        positiveclass;
        kwargs...
        )
    return result
end

function singlelabelbinaryclassclassificationmetrics(
        vectorofestimators::FittableVector,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    kwargsdict = Dict(kwargs)
    selectedtunableparam, selectedparamtomax, metricprintnames =
        _singlelabelbinaryclassclassificationmetrics_tunableparam(kwargsdict)
    metricsforeachestimator = [
        _singlelabelbinaryclassclassificationmetrics(
            est,
            featuresdf,
            labelsdf,
            singlelabelname,
            positiveclass;
            kwargs...
            )
            for est in vectorofestimators
        ]
    result = DataFrames.DataFrame()
    result[:metric] = [
        metricprintnames[:AUPRC],
        metricprintnames[:AUROCC],
        metricprintnames[:AveragePrecision],
        metricprintnames[:threshold],
        metricprintnames[:accuracy],
        metricprintnames[:cohenkappa],
        metricprintnames[:f1score],
        metricprintnames[:precision],
        metricprintnames[:recall],
        metricprintnames[:sensitivity],
        metricprintnames[:specificity],
        ]
    for i = 1:length(vectorofestimators)
        result[Symbol(vectorofestimators[i].name)] = [
            metricsforeachestimator[i][:AUPRC],
            metricsforeachestimator[i][:AUROCC],
            metricsforeachestimator[i][:AveragePrecision],
            metricsforeachestimator[i][:threshold],
            metricsforeachestimator[i][:accuracy],
            metricsforeachestimator[i][:cohenkappa],
            metricsforeachestimator[i][:f1score],
            metricsforeachestimator[i][:precision],
            metricsforeachestimator[i][:recall],
            metricsforeachestimator[i][:sensitivity],
            metricsforeachestimator[i][:specificity],
            ]
    end
    return result
end
