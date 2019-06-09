##### Beginning of file

"""
"""
function set_feature_contrasts!(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function parse_functions!(
        transformer::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        )
    return nothing
end

"""
"""
function fit!(
        transformer::ImmutablePredictProbaSingleLabelInt2StringTransformer,
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
        transformer::ImmutablePredictProbaSingleLabelInt2StringTransformer,
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
        transformer::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        single_labelprobabilities::AbstractDict;
        kwargs...
        )
    labelint2stringmap = getlabelint2stringmap(
        transformer.levels,
        transformer.index,
        )
    result = Dict()
    for key in keys(single_labelprobabilities)
        result[labelint2stringmap[key]] = single_labelprobabilities[key]
    end
    result = fix_type(result)
    return result
end

##### End of file
