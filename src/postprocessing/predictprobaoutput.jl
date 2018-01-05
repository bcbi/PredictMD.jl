immutable ImmutablePredictProbaSingleLabelInt2StringTransformer <:
        AbstractPrimitiveObject
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
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
