import DataFrames
import StatsModels

"""
"""
function transform(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        labelsarray::AbstractArray;
        kwargs...
        )
    featuresarraytransposed = transpose(featuresarray)
    return featuresarraytransposed, labelsarray
end

"""
"""
function transform(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    featuresarraytransposed = transpose(featuresarray)
    return featuresarraytransposed
end

"""
"""
function fit!(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        labelsarray::AbstractArray;
        kwargs...
        )
    return transform(transformer, featuresarray, labelsarray)
end

"""
"""
function predict(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix,
        varargs...;
        kwargs...
        )
    return (transform(transformer, featuresarray), varargs...)
end

"""
"""
function predict_proba(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        featuresarray::AbstractMatrix;
        kwargs...
        )
    return transform(transformer, featuresarray)
end

"""
"""
function DataFrame2LIBSVMTransformer(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        levels::AbstractVector = [],
        )
    df2decisiontreetransformer = MutableDataFrame2DecisionTreeTransformer(
        feature_names,
        single_label_name;
        levels = levels,
        )
    featuretransposetransformer =
        ImmutableFeatureArrayTransposerTransformer()
    result = df2decisiontreetransformer |> featuretransposetransformer
    return result
end
