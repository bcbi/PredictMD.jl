abstract type AbstractPredictProbaLabelsInt2StringTransformer <:
        AbstractTransformer
end

abstract type AbstractPredictProbaSingleLabelInt2StringTransformer <:
        AbstractPredictProbaLabelsInt2StringTransformer
end

abstract type AbstractPredictProbaMultipleLabelsInt2StringTransformer <:
        AbstractPredictProbaLabelsInt2StringTransformer
end

struct PredictProbaSingleLabelInt2StringTransformer <:
        AbstractPredictProbaSingleLabelInt2StringTransformer
    index::T1 where T1 <: Integer
    levels::T2 where T2 <: AbstractVector
end

function fit!(
        transformer::AbstractPredictProbaSingleLabelInt2StringTransformer,
        varargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end

function predict_proba(
        transformer::AbstractPredictProbaSingleLabelInt2StringTransformer,
        singlelabelprobabilities::Associative,
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
