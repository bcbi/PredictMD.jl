immutable ImmutablePackageMultiLabelPredictionTransformer <:
        AbstractPrimitiveObject
    labelnames::T1 where T1 <: SymbolVector
end

function valuehistories(x::ImmutablePackageMultiLabelPredictionTransformer)
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
