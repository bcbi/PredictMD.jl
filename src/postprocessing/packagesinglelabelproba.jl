abstract type AbstractPackageSingleLabelPredictProbaTransformer <:
        AbstractTransformer
end

struct PackageSingleLabelPredictProbaTransformer <:
        AbstractPackageSingleLabelPredictProbaTransformer
    singlelabelname::T1 where T1 <: Symbol
end

function fit!(
        transformer::AbstractPackageSingleLabelPredictProbaTransformer,
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
        transformer::AbstractPackageSingleLabelPredictProbaTransformer,
        singlelabelprobabilities::Associative;
        kwargs...
        )
    result = Dict()
    result[transformer.singlelabelname] = singlelabelprobabilities
    return result
end
