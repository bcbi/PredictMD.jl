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
        varargs...
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
