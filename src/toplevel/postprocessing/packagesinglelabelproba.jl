"""
"""
function set_feature_contrasts!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutablePackageSingleLabelPredictProbaTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutablePackageSingleLabelPredictProbaTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
        )
    return nothing
end

"""
"""
function fit!(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
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
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
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
function predict_proba(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
        single_labelprobabilities::AbstractDict;
        kwargs...
        )
    result = Dict()
    result[transformer.single_label_name] = single_labelprobabilities
    result = fix_type(result)
    return result
end

