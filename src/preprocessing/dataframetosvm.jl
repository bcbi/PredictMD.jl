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
        dffeaturecontrasts::ImmutableDataFrameFeatureContrasts,
        )
    df2decisiontreetransformer = ImmutableDataFrame2DecisionTreeTransformer(
        featurenames,
        dffeaturecontrasts,
        singlelabelname,
        levels,
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
