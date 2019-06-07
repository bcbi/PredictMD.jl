##### Beginning of file

import DataFrames
import MLBase
import StatsBase

"""
"""
function singlelabelregressionytrue(
        labels::AbstractVector;
        float_type::Type{<:AbstractFloat} = Cfloat,
        )
    result = float_type.(labels)
    return result
end

"""
"""
function singlelabelregressionypred(
        labels::AbstractVector;
        float_type::Type{<:AbstractFloat} = Cfloat,
        )
    result = float_type.(labels)
    return result
end

"""
"""
function singlelabelregressionmetrics_resultdict(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        )
    ytrue = singlelabelregressionytrue(
        labels_df[single_label_name],
        )
    predictionsalllabels = predict(estimator, features_df)
    ypred = singlelabelregressionypred(
        predictionsalllabels[single_label_name],
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
    results = fix_type(results)
    return results
end

"""
"""
function singlelabelregressionmetrics(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        )
    vectorofestimators = Fittable[estimator]
    result = singlelabelregressionmetrics(
        vectorofestimators,
        features_df,
        labels_df,
        single_label_name,
        )
    return result
end

"""
"""
function singlelabelregressionmetrics(
        vectorofestimators::AbstractVector{Fittable},
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol;
        kwargs...
        )
    metricsforeachestimator = [
        singlelabelregressionmetrics_resultdict(
            est,
            features_df,
            labels_df,
            single_label_name,
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

##### End of file
