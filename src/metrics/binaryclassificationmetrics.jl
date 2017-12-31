import AUC
import DataFrames
import MLBase
import StatsBase

function binaryytrue(
        labels::AbstractVector,
        positiveclass::AbstractString,
        )
    result = Int.(labels .== positiveclass)
    return result
end

function binaryyscore(
        singlelabelprobabilities::Associative,
        positiveclass::AbstractString,
        )
    println(keys(singlelabelprobabilities))
    result = singlelabelprobabilities[positiveclass]
    return result
end

function _binaryclassificationmetrics(
        estimator::AbstractASBObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    kwargsdict = Dict(kwargs)
    tunableparameters = [
        :threshold,
        :sensitivity,
        :specificity,
        :maximize,
        ]
    maximizableparameters = [
        :f1score,
        :cohenkappa,
        ]
    kwargshastunableparameter = [
        haskey(kwargsdict, x) for x in tunableparameters
        ]
    if sum(kwargshastunableparameter) !== 1
        msg = "you must specify one (and only one) of the following: " *
            join(tunableparameters, ", ")
        error(msg)
    end

    if length(tunableparameters[kwargshastunableparameter]) !== 1
        error("oh boy you definitely should never see this error message")
    end
    selectedtunableparameter =
        tunableparameters[kwargshastunableparameter][1]
    if selectedtunableparameter == :maximize
        parametertomaximize = kwargsdict[:maximize]
        if !in(parametertomaximize, maximizableparameters)
            msg = "Cannot maximize $(parametertomaximize). Select one " *
                "of the following: " * join(maximizableparameters, ", ")
            error(msg)
        end
    end
    yscore = Cfloat.(
        binaryyscore(
            predict_proba(estimator, featuresdf)[singlelabelname],
            positiveclass,
            )
        )
    ytrue = Int.(
        binaryytrue(
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
    if selectedtunableparameter == :threshold
        additionalthreshold = kwargsdict[:threshold]
    else
        additionalthreshold = 0.5
    end
    allrocnums, allthresholds = getallrocnums(
        ytrue,
        yscore;
        additionalthreshold = additionalthreshold,
        )
    if selectedtunableparameter == :threshold
        selectedthreshold = kwargsdict[:threshold]
        bestindex = indmin(abs.(allthresholds - selectedthreshold))
    elseif selectedtunableparameter == :sensitivity
        selectedsensitivity = kwargsdict[:sensitivity]
        allsensitivity = [sensitivity(x) for x in allrocnums]
        bestindex = indmin(abs.(allsensitivity - selectedsensitivity))
    elseif selectedtunableparameter == :specificity
        selectedspecificity = kwargsdict[:specificity]
        allspecificity = [specificity(x) for x in allrocnums]
        bestindex = indmin(abs.(allspecificity - selectedspecificity))
    elseif selectedtunableparameter == :maximize
        parametertomaximize = kwargsdict[:maximize]
        if parametertomaximize == :f1score
            allf1score = [fbetascore(x, 1) for x in allrocnums]
            bestindex = indmax(allf1score)
        elseif parametertomaximize == :cohenkappa
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

function binaryclassificationmetrics(
        estimator::AbstractASBObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    vectorofestimators = [estimator]
    result = binaryclassificationmetrics(
        vectorofestimators,
        featuresdf,
        labelsdf,
        singlelabelname,
        positiveclass;
        kwargs...
        )
    return result
end

function binaryclassificationmetrics(
        vectorofestimators::VectorOfAbstractASBObjects,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    numestimators = length(vectorofestimators)
    metricsforeachestimator = [
        _binaryclassificationmetrics(
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
        "AUPRC",
        "AUROCC",
        "Average precision",
        "Threshold*",
        "Accuracy*",
        "Cohen's Kappa statistic*",
        "F1 score*",
        "Precision*",
        "Recall*",
        "Sensitivity*",
        "Specificity*",
        ]
    for i = 1:numestimators
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
