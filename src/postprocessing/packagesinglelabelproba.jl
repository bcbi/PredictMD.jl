immutable ImmutablePackageSingleLabelPredictProbaTransformer <:
        AbstractPrimitiveObject
    singlelabelname::T1 where T1 <: Symbol
end

function underlying(::ImmutablePackageSingleLabelPredictProbaTransformer)
    return nothing
end

function fit!(
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
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
        transformer::ImmutablePackageSingleLabelPredictProbaTransformer,
        singlelabelprobabilities::Associative;
        kwargs...
        )
    result = Dict()
    result[transformer.singlelabelname] = singlelabelprobabilities
    return result
end
