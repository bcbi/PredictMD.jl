import DataFrames
import StatsModels

struct ImmutableFeatureArrayTransposerTransformer <:
        AbstractEstimator
end

function setfeaturecontrasts!(
        x::ImmutableFeatureArrayTransposerTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function get_underlying(
        x::ImmutableFeatureArrayTransposerTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function set_underlying!(
        x::ImmutableFeatureArrayTransposerTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function gethistory(
        x::ImmutableFeatureArrayTransposerTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::ImmutableFeatureArrayTransposerTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function transform(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        labelsarray::AbstractArray;
        kwargs...
        )
    featuresarraytransposed = transpose(featuresarray)
    return featuresarraytransposed, labelsarray
end

function transform(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    featuresarraytransposed = transpose(featuresarray)
    return featuresarraytransposed
end

function fit!(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        labelsarray::AbstractArray;
        kwargs...
        )
    return transform(transformer, featuresarray, labelsarray)
end

function predict(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    return transform(transformer, featuresarray)
end

function predict_proba(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    return transform(transformer, featuresarray)
end

function DataFrame2LIBSVMTransformer(
        featurenames::AbstractVector,
        singlelabelname::Symbol;
        levels::AbstractVector = [],
        )
    df2decisiontreetransformer = MutableDataFrame2DecisionTreeTransformer(
        featurenames,
        singlelabelname;
        levels = levels,
        )
    featuretransposetransformer = ImmutableFeatureArrayTransposerTransformer()
    result = ImmutableSimpleLinearPipeline(
        [
            df2decisiontreetransformer,
            featuretransposetransformer,
            ],
        )
    return result
end
