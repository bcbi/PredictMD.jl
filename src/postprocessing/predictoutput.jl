import DataFrames

immutable ImmutablePredictionsSingleLabelInt2StringTransformer <:
        AbstractPrimitiveObject
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
end

function setfeaturecontrasts!(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function getunderlying(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function setunderlying!(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function gethistory(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::ImmutablePredictionsSingleLabelInt2StringTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

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

function predict(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        singlelabelpredictions::AbstractVector;
        kwargs...
        )
    singlelabelpredictions = parse.(Int, singlelabelpredictions)
    labelint2stringmap = _getlabelint2stringmap(
        transformer.levels,
        transformer.index,
        )
    result = Vector{String}(length(singlelabelpredictions))
    for i = 1:length(result)
        result[i] = labelint2stringmap[singlelabelpredictions[i]]
    end
    return result
end

function predict(
        transformer::ImmutablePredictionsSingleLabelInt2StringTransformer,
        singlelabelpredictions::DataFrames.AbstractDataFrame;
        kwargs...
        )
    labelnames = DataFrames.names(singlelabelpredictions)
    result = DataFrames.DataFrame()
    for i = 1:length(labelnames)
        result[labelnames[i]] = predict(
            transformer,
            singlelabelpredictions[labelnames[i]];
            kwargs...
            )
    end
    return result
end

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
