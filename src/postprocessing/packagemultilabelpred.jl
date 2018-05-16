struct ImmutablePackageMultiLabelPredictionTransformer <:
        AbstractEstimator
    labelnames::T1 where T1 <: AbstractVector{<:Symbol}
end

function set_feature_contrasts!(
        x::ImmutablePackageMultiLabelPredictionTransformer,
        feature_contrasts::AbstractFeatureContrasts,
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

function get_history(
        x::ImmutablePackageMultiLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_history!(
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
