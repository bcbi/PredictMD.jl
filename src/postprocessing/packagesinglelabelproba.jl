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
    return varargs
end

function predict_proba(
        transformer::AbstractPackageSingleLabelPredictProbaTransformer,
        singlelabelprobabilities::Associative,
        )
    result = Dict()
    result[transformer.singlelabelname] = singlelabelprobabilities
    return result
end
