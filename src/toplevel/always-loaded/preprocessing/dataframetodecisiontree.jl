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
function transform(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    single_label_name = transformer.single_label_name
    labelsarray = convert(Array, labels_df[single_label_name])
    my_formula = transformer.dffeaturecontrasts.formula_without_intercept
    my_schema = transformer.dffeaturecontrasts.schema_without_intercept
    my_formula = StatsModels.apply_schema(my_formula, my_schema)
    response, featuresarray = StatsModels.modelcols(my_formula,
                                                    features_df)
    return featuresarray, labelsarray
end

"""
"""
function transform(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        features_df::DataFrames.AbstractDataFrame;
        kwargs...
        )
    my_formula = transformer.dffeaturecontrasts.formula_without_intercept
    my_schema = transformer.dffeaturecontrasts.schema_without_intercept
    my_formula = StatsModels.apply_schema(my_formula, my_schema)
    response, featuresarray = StatsModels.modelcols(my_formula,
                                                    features_df)
    return featuresarray
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
        features_df::DataFrames.AbstractDataFrame,
        varargs...;
        kwargs...
        )
    return (transform(transformer, features_df), varargs...)
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
