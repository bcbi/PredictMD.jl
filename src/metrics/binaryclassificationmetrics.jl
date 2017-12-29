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

function binaryclassificationmetrics(
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
        vectorofestimators::VectorOfAbstractASBObjects,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        kwargs...
        )
    numestimators = length(vectorofestimators)
    metricsforeachestimator = [
        binaryclassificationmetrics(
            est,
            featuresdf,
            labelsdf,
            singlelabelname,
            positiveclass;
            kwargs...
            )
            for est in vectorofestimators
        ]
    allresults = []
    for i = 1:numestimators
        result_i = DataFrames.DataFrame()
        result_i[:Name] =
            vectorofestimators[i].name
        result_i[:AUROCC] =
            metricsforeachestimator[i][:AUROCC]
        result_i[:AUPRC] =
            metricsforeachestimator[i][:AUPRC]
        result_i[:AveragePrecision] =
            metricsforeachestimator[i][:AveragePrecision]
        result_i[:threshold] =
            metricsforeachestimator[i][:threshold]
        result_i[:accuracy] =
            metricsforeachestimator[i][:accuracy]
        result_i[:sensitivity] =
            metricsforeachestimator[i][:sensitivity]
        result_i[:specificity] =
            metricsforeachestimator[i][:specificity]
        result_i[:precision] =
            metricsforeachestimator[i][:precision]
        result_i[:recall] =
            metricsforeachestimator[i][:recall]
        result_i[:f1score] =
            metricsforeachestimator[i][:f1score]
        push!(allresults, result_i)
    end
    finalresult = vcat(allresults...)
    return finalresult
end
