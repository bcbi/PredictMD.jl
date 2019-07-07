"""
"""
function set_feature_contrasts!(
        x::ImmutablePackageSingleLabelPredictionTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutablePackageSingleLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutablePackageSingleLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
        )
    return nothing
end

"""
"""
function fit!(
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
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
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
        single_labelpredictions::AbstractVector,
        )
    result = DataFrames.DataFrame()
    label_name = transformer.single_label_name
    result[label_name] = single_labelpredictions
    return result
end

"""
"""
function predict_proba(
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end

