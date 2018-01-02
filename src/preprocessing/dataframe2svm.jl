import DataFrames
import StatsModels

abstract type AbstractFeatureArrayTransposerTransformer <:
        AbstractTransformer
end

struct FeatureArrayTransposerTransformer <:
        AbstractFeatureArrayTransposerTransformer
end

function transform(
        transformer::AbstractFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        labelsarray::AbstractArray;
        kwargs...
        )
    featuresarraytransposed = transpose(featuresarray)
    return featuresarraytransposed, labelsarray
end

function transform(
        transformer::AbstractFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    featuresarraytransposed = transpose(featuresarray)
    return featuresarraytransposed
end

function fit!(
        transformer::AbstractFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        labelsarray::AbstractArray;
        kwargs...
        )
    return transform(transformer, featuresarray, labelsarray)
end

function predict_proba(
        transformer::AbstractFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    return transform(transformer, featuresarray)
end

function DataFrame2LIBSVMjlTransformer(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        levels::AbstractVector,
        df::DataFrames.AbstractDataFrame,
        )
    df2decisiontreetransformer = DataFrame2DecisionTreejlTransformer(
        featurenames,
        singlelabelname,
        levels,
        df,
        )
    featuretransposetransformer = FeatureArrayTransposerTransformer()
    result = SimplePipeline(
        [df2decisiontreetransformer,featuretransposetransformer,],
        )
    return result
end
