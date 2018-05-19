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
        estimator::Fittable,
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
    results[:r2_score] = r2_score(
        ytrue,
        ypred,
        )
    results[:mean_square_error] = mean_square_error(
        ytrue,
        ypred,
        )
    results[:root_mean_square_error] = root_mean_square_error(
        ytrue,
        ypred,
        )
    results = fix_dict_type(results)
    return results
end

function singlelabelregressionmetrics(
        estimator::Fittable,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        )
    vectorofestimators = Fittable[estimator]
    result = singlelabelregressionmetrics(
        vectorofestimators,
        featuresdf,
        labelsdf,
        singlelabelname,
        )
    return result
end

function singlelabelregressionmetrics(
        vectorofestimators::AbstractVector{Fittable},
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
    result[:metric] = [
        "R^2 (coefficient of determination)",
        "Mean squared error (MSE)",
        "Root mean square error (RMSE)",
        ]
    for i = 1:length(vectorofestimators)
        result[Symbol(vectorofestimators[i].name)] = [
            metricsforeachestimator[i][:r2_score],
            metricsforeachestimator[i][:mean_square_error],
            metricsforeachestimator[i][:root_mean_square_error],
            ]
    end
    return result
end
