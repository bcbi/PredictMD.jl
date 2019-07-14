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
