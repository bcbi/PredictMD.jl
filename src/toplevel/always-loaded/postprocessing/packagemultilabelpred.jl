"""
"""
function fit!(
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
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
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
        single_labelpredictions::AbstractMatrix,
        varargs...
        )
    result = DataFrames.DataFrame()
    for i = 1:length(transformer.label_names)
        result[transformer.label_names[i]] = single_labelpredictions[:, i]
    end
    return result
end

"""
"""
function predict_proba(
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end
