##### Beginning of file

import DataFrames
import StatsModels

function MutableDataFrame2DecisionTreeTransformer(
        feature_names::AbstractVector,
        single_label_name::Symbol;
        levels::AbstractVector = [],
        )
    dffeaturecontrasts = FeatureContrastsNotYetGenerated()
    result = MutableDataFrame2DecisionTreeTransformer(
        feature_names,
        single_label_name,
        levels,
        dffeaturecontrasts,
        )
    return result
end

"""
"""
function set_feature_contrasts!(
        x::MutableDataFrame2DecisionTreeTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    x.dffeaturecontrasts = feature_contrasts
    return nothing
end

"""
"""
function get_underlying(
        x::MutableDataFrame2DecisionTreeTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.dffeaturecontrasts
    return result
end

"""
"""
function get_history(
        x::MutableDataFrame2DecisionTreeTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

"""
"""
function transform(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    single_label_name = transformer.single_label_name
    labelsarray = convert(Array, labels_df[single_label_name])
    modelformula = generate_formula(
        transformer.feature_names[1],
        transformer.feature_names;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        features_df;
        contrasts = transformer.dffeaturecontrasts.contrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    return featuresarray, labelsarray
end

"""
"""
function transform(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    modelformula = generate_formula(
        transformer.feature_names[1],
        transformer.feature_names;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        features_df;
        contrasts = transformer.dffeaturecontrasts.contrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    return featuresarray
end

"""
"""
function parse_functions!(
    transformer::MutableDataFrame2DecisionTreeTransformer,
    )
    return nothing
end

"""
"""
function fit!(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, features_df, labels_df)
end

"""
"""
function predict(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, features_df)
end

"""
"""
function predict_proba(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, features_df)
end

##### End of file
