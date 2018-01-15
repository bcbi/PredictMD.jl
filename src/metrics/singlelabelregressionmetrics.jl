import AUC
import DataFrames
import MLBase
import StatsBase

function singlelabelregressionytrue(
        labels::AbstractVector;
        floattype::Type = Cfloat,
        )
    if !(floattype <: AbstractFloat)
        error("!(floattype <: AbstractFloat)")
    end
    result = floattype.(labels)
    return result
end

function singlelabelregressionypred(
        labels::AbstractVector;
        floattype::Type = Cfloat,
        )
    if !(floattype <: AbstractFloat)
        error("!(floattype <: AbstractFloat)")
    end
    result = floattype.(labels)
    return result
end

function _singlelabelregressionmetrics(
        estimator::AbstractObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        )
    ytrue = singlelabelregressionytrue(
        labelsdf[singlelabelname],
        )
    predictionsalllabels = predict(estimator, featuresdf)
    ypred = singlelabelregressionypred(
        predictionsalllabels[singlelabelname],
        )
    results = Dict()
    results[:R2coefficientofdetermination] = R2coefficientofdetermination(
        ytrue,
        ypred,
        )
    return results
end

function singlelabelregressionmetrics(
        estimator::AbstractObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        )
    vectorofestimators = [estimator]
    result = singlelabelregressionmetrics(
        vectorofestimators,
        featuresdf,
        labelsdf,
        singlelabelname,
        )
    return result
end

function singlelabelregressionmetrics(
        vectorofestimators::AbstractObjectVector,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol;
        kwargs...
        )
    metricsforeachestimator = [
        _singlelabelregressionmetrics(
            est,
            featuresdf,
            labelsdf,
            singlelabelname,
            )
            for est in vectorofestimators
        ]
    result = DataFrames.DataFrame()
    result[:metric] = "R^2 (coefficient of determination)"
    for i = 1:length(vectorofestimators)
        result[Symbol(vectorofestimators[i].name)] = [
            metricsforeachestimator[i][:R2coefficientofdetermination]
            ]
    end
    return result
end
