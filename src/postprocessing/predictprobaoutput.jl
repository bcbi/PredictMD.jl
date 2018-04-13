struct ImmutablePredictProbaSingleLabelInt2StringTransformer <:
        AbstractPrimitiveObject
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
end

function setfeaturecontrasts!(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function get_underlying(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_underlying!(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end
function gethistory(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

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

function predict_proba(
        transformer::ImmutablePredictProbaSingleLabelInt2StringTransformer,
        singlelabelprobabilities::Associative;
        kwargs...
        )
    labelint2stringmap = _getlabelint2stringmap(
        transformer.levels,
        transformer.index,
        )
    result = Dict()
    for key in keys(singlelabelprobabilities)
        result[labelint2stringmap[key]] = singlelabelprobabilities[key]
    end
    return result
end
