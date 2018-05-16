struct ImmutablePackageSingleLabelPredictionTransformer <:
        AbstractEstimator
    singlelabelname::T1 where T1 <: Symbol
end

function set_feature_contrasts!(
        x::ImmutablePackageSingleLabelPredictionTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

function get_underlying(
        x::ImmutablePackageSingleLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function get_history(
        x::ImmutablePackageSingleLabelPredictionTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_history!(
        x::ImmutablePackageSingleLabelPredictionTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
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
