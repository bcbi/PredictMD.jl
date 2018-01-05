import DataFrames
import StatsModels

immutable ImmutableFeatureArrayTransposerTransformer <:
        AbstractPrimitiveObject
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

function predict_proba(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    return transform(transformer, featuresarray)
end

function DataFrame2LIBSVMTransformer(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        levels::AbstractVector,
        df::DataFrames.AbstractDataFrame,
        )
    df2decisiontreetransformer = DataFrame2DecisionTreeTransformer(
        featurenames,
        singlelabelname,
        levels,
        df,
        )
    featuretransposetransformer = ImmutableFeatureArrayTransposerTransformer()
    result = SimplePipeline(
        [
            df2decisiontreetransformer,
            featuretransposetransformer,
            ],
        )
    return result
end
