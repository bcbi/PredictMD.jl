"""
"""
struct ImmutablePackageSingleLabelPredictProbaTransformer <:
        AbstractEstimator
    singlelabelname::T1 where T1 <: Symbol
end

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
        singlelabelprobabilities::Associative;
        kwargs...
        )
    result = Dict()
    result[transformer.singlelabelname] = singlelabelprobabilities
    result = fix_dict_type(result)
    return result
end
