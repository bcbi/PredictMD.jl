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
