struct ImmutablePackageSingleLabelPredictProbaTransformer <:
        AbstractPrimitiveObject
    singlelabelname::T1 where T1 <: Symbol
end

function setfeaturecontrasts!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function getunderlying(
        x::ImmutablePackageSingleLabelPredictProbaTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function setunderlying!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function gethistory(
        x::ImmutablePackageSingleLabelPredictProbaTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::ImmutablePackageSingleLabelPredictProbaTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
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

function predict(
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
