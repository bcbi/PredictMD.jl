immutable ImmutablePackageSingleLabelPredictionTransformer <:
        AbstractPrimitiveObject
    singlelabelname::T1 where T1 <: Symbol
end

function valuehistories(x::ImmutablePackageSingleLabelPredictionTransformer)
    return nothing
end

function fit!(
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
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
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
        singlelabelpredictions::AbstractVector,
        )
    result = DataFrames.DataFrame()
    labelname = transformer.singlelabelname
    result[labelname] = singlelabelpredictions
    return result
end

function predict_proba(
        transformer::ImmutablePackageSingleLabelPredictionTransformer,
        varargs...;
        kwargs...
        )
    if length(varargs) == 1
        return varargs[1]
    else
        return varargs
    end
end
