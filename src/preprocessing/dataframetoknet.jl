import DataFrames
import StatsModels

mutable struct MutableDataFrame2ClassificationKnetTransformer <:
        AbstractEstimator
    featurenames::T1 where T1 <: AbstractVector
    labelnames::T2 where T2 <: AbstractVector{Symbol}
    labellevels::T3 where T3 <: Associative
    index::T4 where T4 <: Integer
    transposefeatures::T5 where T5 <: Bool
    transposelabels::T6 where T6 <: Bool
    dffeaturecontrasts::T7 where T7 <: AbstractFeatureContrasts
    function MutableDataFrame2ClassificationKnetTransformer(
            featurenames::AbstractVector,
            labelnames::AbstractVector{Symbol},
            labellevels::Associative,
            index::Integer;
            transposefeatures::Bool = true,
            transposelabels::Bool = false,
            )
        result = new(
            featurenames,
            labelnames,
            labellevels,
            index,
            transposefeatures,
            transposelabels,
            )
        return result
    end
end

mutable struct MutableDataFrame2RegressionKnetTransformer <:
        AbstractEstimator
    featurenames::T1 where T1 <: AbstractVector
    labelnames::T2 where T2 <: AbstractVector{Symbol}
    transposefeatures::T3 where T3 <: Bool
    transposelabels::T4 where T4 <: Bool
    dffeaturecontrasts::T5 where T5 <: AbstractFeatureContrasts
    function MutableDataFrame2RegressionKnetTransformer(
            featurenames::AbstractVector,
            labelnames::AbstractVector{Symbol};
            transposefeatures::Bool = true,
            transposelabels::Bool = false,
            )
        result = new(
            featurenames,
            labelnames,
            transposefeatures,
            transposelabels,
            )
        return result
    end
end

function get_history(
        x::MutableDataFrame2ClassificationKnetTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function get_history(
        x::MutableDataFrame2RegressionKnetTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function get_underlying(
        x::MutableDataFrame2ClassificationKnetTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.dffeaturecontrasts
    return result
end

function get_underlying(
        x::MutableDataFrame2RegressionKnetTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.dffeaturecontrasts
    return result
end

function set_feature_contrasts!(
        x::MutableDataFrame2ClassificationKnetTransformer,
        feature_contrasts::AbstractFeatureContrasts,
        )
    x.dffeaturecontrasts = feature_contrasts
    return nothing
end

function set_feature_contrasts!(
        x::MutableDataFrame2RegressionKnetTransformer,
        contrasts::AbstractFeatureContrasts,
        )
    x.dffeaturecontrasts = contrasts
    return nothing
end

function fit!(
        transformer::MutableDataFrame2ClassificationKnetTransformer,
        training_features_df::DataFrames.AbstractDataFrame,
        training_labels_df::DataFrames.AbstractDataFrame,
        validation_features_df::Union{Void, DataFrames.AbstractDataFrame} = nothing,
        validation_labels_df::Union{Void, DataFrames.AbstractDataFrame} = nothing;
        kwargs...
        )
    result = transform(
        transformer,
        training_features_df,
        training_labels_df,
        validation_features_df,
        validation_labels_df;
        kwargs...
        )
    return result
end

function fit!(
        transformer::MutableDataFrame2RegressionKnetTransformer,
        training_features_df::DataFrames.AbstractDataFrame,
        training_labels_df::DataFrames.AbstractDataFrame,
        validation_features_df::Union{Void, DataFrames.AbstractDataFrame} = nothing,
        validation_labels_df::Union{Void, DataFrames.AbstractDataFrame} = nothing;
        kwargs...
        )
    result = transform(
        transformer,
        training_features_df,
        training_labels_df,
        validation_features_df,
        validation_labels_df;
        kwargs...
        )
    return result
end

function predict(
        transformer::MutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

function predict_proba(
        transformer::MutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

function predict(
        transformer::MutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    result = transform(
        transformer,
        featuresdf;
        kwargs...
        )
    return result
end

function predict_proba(
        transformer::MutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    result = transform(
        transformer,
        featuresdf;
        kwargs...
        )
    return result
end

function transform(
        transformer::MutableDataFrame2ClassificationKnetTransformer,
        training_features_df::DataFrames.AbstractDataFrame,
        training_labels_df::DataFrames.AbstractDataFrame,
        validation_features_df::Union{Void, DataFrames.AbstractDataFrame} = nothing,
        validation_labels_df::Union{Void, DataFrames.AbstractDataFrame} = nothing;
        kwargs...
        )
    if is_nothing(validation_features_df) && is_nothing(validation_labels_df)
        has_validation_data = false
    elseif !is_nothing(validation_features_df) && !is_nothing(validation_labels_df)
        has_validation_data = true
    else
        error(
            string(
                "Either both validation_features_df and validation_labels_df ",
                "must be defined, or neither can be defined."
                )
            )
    end
    if length(transformer.labelnames) == 0
        error("length(transformer.labelnames) == 0")
    elseif length(transformer.labelnames) == 1
        label_1 = transformer.labelnames[1]
        levels_1 = transformer.labellevels[label_1]
        labelstring2intmap_1 = _getlabelstring2intmap(
            levels_1,
            transformer.index,
            )
        training_labels_array =
            [labelstring2intmap_1[y] for y in training_labels_df[label_1]]
        @assert(typeof(training_labels_array) <: AbstractVector)
        @assert(length(training_labels_array) == size(training_labels_df, 1))
    else
        training_labels_array = Array{Int}(
            size(training_labels_df, 1),
            length(transformer.labelnames),
            )
        for j = 1:length(transformer.labelnames)
            label_j = transformer.labelnames[j]
            levels_j = transformer.labellevels[label_j]
            labelstring2intmap_j = _getlabelstring2intmap(
                levels_j,
                transformer.index,
                )
            training_labels_array[:, j] =
                [labelstring2intmap_j[y] for y in labelsdf[label_j]]
        end
    end
    modelformula = generate_formula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    training_modelframe = StatsModels.ModelFrame(
        modelformula,
        training_features_df;
        contrasts = transformer.dffeaturecontrasts.contrasts,
        )
    training_modelmatrix = StatsModels.ModelMatrix(training_modelframe)
    training_features_array = training_modelmatrix.m
    if transformer.transposefeatures
        training_features_array = transpose(training_features_array)
    end
    if transformer.transposelabels
        training_labels_array = transpose(training_labels_array)
    end
    training_features_array = convert(Array, training_features_array)
    training_labels_array = convert(Array, training_labels_array)
    if has_validation_data
        validation_features_array, validation_labels_array = transform(
            transformer,
            validation_features_df,
            validation_labels_df;
            kwargs...
            )
        return training_features_array,
            training_labels_array,
            validation_features_array,
            validation_labels_array
    else
        return training_features_array,
            training_labels_array
    end
end

function transform(
        transformer::MutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    modelformula = generate_formula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = transformer.dffeaturecontrasts.contrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarray = transpose(featuresarray)
    end
    return featuresarray
end

function transform(
        transformer::MutableDataFrame2RegressionKnetTransformer,
        training_features_df::DataFrames.AbstractDataFrame,
        training_labels_df::DataFrames.AbstractDataFrame,
        validation_features_df::Union{Void, DataFrames.AbstractDataFrame} = nothing,
        validation_labels_df::Union{Void, DataFrames.AbstractDataFrame} = nothing;
        kwargs...
        )
    if is_nothing(validation_features_df) && is_nothing(validation_labels_df)
        has_validation_data = false
    elseif !is_nothing(validation_features_df) && !is_nothing(validation_labels_df)
        has_validation_data = true
    else
        error(
            string(
                "Either both validation_features_df and validation_labels_df ",
                "must be defined, or neither can be defined."
                )
            )
    end
    training_labels_array = hcat(
        [
            training_labels_df[label] for label in transformer.labelnames
            ]...
        )
    modelformula = generate_formula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    training_modelframe = StatsModels.ModelFrame(
        modelformula,
        training_features_df;
        contrasts = transformer.dffeaturecontrasts.contrasts,
        )
    training_modelmatrix = StatsModels.ModelMatrix(training_modelframe)
    training_features_array = training_modelmatrix.m
    if transformer.transposefeatures
        training_features_array = transpose(training_features_array)
    end
    if transformer.transposelabels
        training_labels_array = transpose(training_labels_array)
    end
    training_features_array = convert(Array, training_features_array)
    training_labels_array = convert(Array, training_labels_array)
    if has_validation_data
        validation_features_array, validation_labels_array = transform(
            transformer,
            validation_features_df,
            validation_labels_df;
            kwargs...
            )
        return training_features_array,
            training_labels_array,
            validation_features_array,
            validation_labels_array
    else
        return training_features_array,
            training_labels_array
    end
end

function transform(
        transformer::MutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        kwargs...
        )
    modelformula = generate_formula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = transformer.dffeaturecontrasts.contrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarray = transpose(featuresarray)
    end
    return featuresarray
end
