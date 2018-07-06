##### Beginning of file

import DataFrames

"""
"""
struct ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer <:
        AbstractEstimator
    label::T1 where T1 <: Symbol
    positiveclass::T2 where T2 <: AbstractString
end

"""
"""
function set_feature_contrasts!(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    return nothing
end

"""
"""
function get_underlying(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function get_history(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function transform(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    transformedlabels_df = DataFrames.DataFrame()
    label = transformer.label
    positiveclass = transformer.positiveclass
    originallabelcolumn = labels_df[label]
    transformedlabelcolumn = Int.(originallabelcolumn .== positiveclass)
    transformedlabels_df[label] = transformedlabelcolumn
    return features_df, transformedlabels_df
end

"""
"""
function transform(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return features_df
end

"""
"""
function parse_functions!(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        )
    return nothing
end

"""
"""
function fit!(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, features_df, labels_df)
end

"""
"""
function predict(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, features_df)
end

"""
"""
function predict_proba(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, features_df)
end

##### End of file
