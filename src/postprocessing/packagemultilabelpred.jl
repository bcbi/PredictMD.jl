struct ImmutablePackageMultiLabelPredictionTransformer <:
        AbstractPrimitiveObject
    labelnames::T1 where T1 <: SymbolVector
end

function setfeaturecontrasts!(
        x::ImmutablePackageMultiLabelPredictionTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function get_underlying(
        x::ImmutablePackageMultiLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_underlying!(
        x::ImmutablePackageMultiLabelPredictionTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function gethistory(
        x::ImmutablePackageMultiLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::ImmutablePackageMultiLabelPredictionTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function fit!(
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
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
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
        singlelabelpredictions::AbstractMatrix,
        )
    result = DataFrames.DataFrame()
    for i = 1:length(transformer.labelnames)
        result[transformer.labelnames[i]] = singlelabelpredictions[:, i]
    end
    return result
end

function predict_proba(
        transformer::ImmutablePackageMultiLabelPredictionTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end
