import DataFrames

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
        single_labelpredictions::AbstractVector,
        varargs...;
        kwargs...
        )
    single_labelpredictions = parse.(Int, single_labelpredictions)
    labelint2stringmap = getlabelint2stringmap(
        transformer.levels,
        transformer.index,
        )
    result = Vector{String}(
        undef,
        length(single_labelpredictions),
        )
    for i = 1:length(result)
        result[i] = labelint2stringmap[single_labelpredictions[i]]
    end
    return result
end

"""
"""
function predict(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        single_labelpredictions::DataFrames.AbstractDataFrame,
        varargs...;
        kwargs...
        )
    label_names = DataFrames.names(single_labelpredictions)
    result = DataFrames.DataFrame()
    for i = 1:length(label_names)
        result[label_names[i]] = predict(
            transformer,
            single_labelpredictions[label_names[i]];
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
