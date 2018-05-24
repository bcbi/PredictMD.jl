import DataFrames

"""
"""
struct ImmutablePredictionsSingleLabelInt2StringTransformer <:
        AbstractEstimator
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
end

"""
"""
function set_feature_contrasts!(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(transformer::ImmutablePredictionsSingleLabelInt2StringTransformer)
    return nothing
end

"""
"""
function fit!(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end

"""
"""
function predict(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        singlelabelpredictions::AbstractVector;
        kwargs...
        )
    singlelabelpredictions = parse.(Int, singlelabelpredictions)
    labelint2stringmap = _getlabelint2stringmap(
        transformer.levels,
        transformer.index,
        )
    result = Vector{String}(length(singlelabelpredictions))
    for i = 1:length(result)
        result[i] = labelint2stringmap[singlelabelpredictions[i]]
    end
    return result
end

"""
"""
function predict(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        singlelabelpredictions::DataFrames.AbstractDataFrame;
        kwargs...
        )
    labelnames = DataFrames.names(singlelabelpredictions)
    result = DataFrames.DataFrame()
    for i = 1:length(labelnames)
        result[labelnames[i]] = predict(
            transformer,
            singlelabelpredictions[labelnames[i]];
            kwargs...
            )
    end
    return result
end

"""
"""
function predict_proba(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end
