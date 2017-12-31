abstract type AbstractPackageSingleLabelPredictProbaTransformer <:
        AbstractTransformer
end

struct PackageSingleLabelPredictProbaTransformer <:
        AbstractPackageSingleLabelPredictProbaTransformer
    singlelabelname::T1 where T1 <: Symbol
end

function fit!(
        transformer::AbstractPackageSingleLabelPredictProbaTransformer,
        varargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end

function predict_proba(
        transformer::AbstractPackageSingleLabelPredictProbaTransformer,
        singlelabelprobabilities::Associative,
        )
    result = Dict()
    result[transformer.singlelabelname] = singlelabelprobabilities
    return result
end
