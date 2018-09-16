##### Beginning of file

"""
"""
function set_feature_contrasts!(
        x::ImmutablePackageMultiLabelPredictionTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutablePackageMultiLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutablePackageMultiLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
        )
    return nothing
end

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

##### End of file
