import DataFrames

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
    positive_class = transformer.positive_class
    originallabelcolumn = labels_df[label]
    transformedlabelcolumn = Int.(originallabelcolumn .== positive_class)
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
function predict(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        features_df::DataFrames.AbstractDataFrame,
        my_class::AbstractString,
        varargs...;
        kwargs...
        )
    result = (transform(transformer, features_df),
              transform(transformer, my_class),
              varargs...)
    return result
end

"""
"""
function transform(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        my_class::AbstractString;
        kwargs...
        )
    transformed_my_class = Int(my_class == transformer.positive_class)
    return transformed_my_class
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
