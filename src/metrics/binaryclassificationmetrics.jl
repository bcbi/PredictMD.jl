import AUC
import DataFrames
import MLBase
import StatsBase

function binaryytrue(
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString,
        )
    singlelabelcolumn = labelsdf[singlelabelname]
    singlelabelcolumnasbinary = Int.(singlelabelcolumn .== positiveclass)
    return singlelabelcolumnasbinary
end

function binaryyscore(
        predict_proba_results::Associative,
        singlelabelname::Symbol,
        positiveclass::AbstractString,
        )
    singlelabel_predict_proba_results = predict_proba_results[singlelabelname]
    if haskey(singlelabel_predict_proba_results, positiveclass)
        singlelabel_probabilityofclass1 =
            singlelabel_predict_proba_results[positiveclass]
    elseif haskey(singlelabel_predict_proba_results, 1)
        singlelabel_probabilityofclass1 =
            singlelabel_predict_proba_results[1]
    else
        error("couldn't figure out how to get proba for positive class")
    end
    return singlelabel_probabilityofclass1
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
        error("oh boy you should never see this error message")
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
            predict_proba(estimator, featuresdf),
            singlelabelname,positiveclass,
            )
        )
    ytrue = Int.(
        binaryytrue(
            labelsdf,
            singlelabelname,
            positiveclass,
            )
        )
    results = Dict()
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
        bestindex = indmin(abs(allthresholds - selectedthreshold))
    elseif selectedtunableparameter == :sensitivity
        selectedsensitivity = kwargsdict[:sensitivity]
        allsensitivity = [sensitivity(x) for x in allrocnums]
        bestindex = indmin(abs.(allsensitivity - selectedsensitivity))
    elseif selectedtunableparameter == :specificity
        selectedspecificity = kwargsdict[:specificity]
        allspecificity = [specificity(x) for x in allrocnums]
        bestindex = indmin(abs(allspecificity - selectedspecificity))
    elseif selectedtunableparameter == :maximize
        parametertomaximize = kwargsdict[:maximize]
        if parametertomaximize == :f1score
            allf1score = [fbetascore(x, 1) for x in allrocnums]
            bestindex = indmax(allf1score)
        else
            error("this is an error that should never happen")
        end
    else
        error("this is another error that should never happen")
    end
    bestrocnums = allrocnums[bestindex]
    bestthreshold = allthresholds[bestindex]
    results[:threshold] = bestthreshold
    results[:accuracy] = accuracy(bestrocnums)
    results[:sensitivity] = sensitivity(bestrocnums)
    results[:specificity] = specificity(bestrocnums)
    results[:precision] = precision(bestrocnums)
    results[:recall] = recall(bestrocnums)
    results[:f1score] = f1score(bestrocnums)
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
    # allresults = []
    result = DataFrames.DataFrame()
    result[:metric] = [
        "AUROCC",
        "AUPRC",
        "Average precision",
        "Threshold*",
        "Accuracy*",
        "Sensitivity*",
        "Specificity*",
        "Precision*",
        "Recall*",
        "F1 score*",
        ]
    for i = 1:numestimators
        result[Symbol(vectorofestimators[i].name)] = [
            metricsforeachestimator[i][:AUROCC],
             metricsforeachestimator[i][:AUPRC],
            metricsforeachestimator[i][:AveragePrecision],
            metricsforeachestimator[i][:threshold],
            metricsforeachestimator[i][:accuracy],
            metricsforeachestimator[i][:sensitivity],
            metricsforeachestimator[i][:specificity],
            metricsforeachestimator[i][:precision],
            metricsforeachestimator[i][:recall],
            metricsforeachestimator[i][:f1score],
            ]
    end
    return result
end
