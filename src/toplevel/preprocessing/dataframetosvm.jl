import DataFrames
import StatsModels

"""
"""
function set_feature_contrasts!(
        x::ImmutableFeatureArrayTransposerTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutableFeatureArrayTransposerTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutableFeatureArrayTransposerTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

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
function parse_functions!(
        transformer::ImmutableFeatureArrayTransposerTransformer,
        )
    return nothing
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
        featuresarray::AbstractMatrix;
        kwargs...
        )
    return transform(transformer, featuresarray)
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
    result = SimplePipeline(
        Fittable[
            df2decisiontreetransformer,
            featuretransposetransformer,
            ],
        )
    return result
end

