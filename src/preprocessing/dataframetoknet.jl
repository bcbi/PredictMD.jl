import DataFrames
import StatsModels

struct ImmutableDataFrame2ClassificationKnetTransformer <:
        AbstractPrimitiveObject
    featurenames::T1 where T1 <: AbstractVector
    dffeaturecontrasts::T2 where T2 <: ImmutableDataFrameFeatureContrasts
    labelnames::T3 where T3 <: SymbolVector
    labellevels::T4 where T4 <: Associative
    index::T5 where T5 <: Integer
    transposefeatures::T6 where T6 <: Bool
    transposelabels::T7 where T7 <: Bool
end

function valuehistories(x::ImmutableDataFrame2ClassificationKnetTransformer)
    return nothing
end

function ImmutableDataFrame2ClassificationKnetTransformer(
        featurenames::AbstractVector,
        dffeaturecontrasts::AbstractContrastsObject,
        labelnames::SymbolVector,
        labellevels::Associative,
        index::Integer;
        transposefeatures::Bool = true,
        transposelabels::Bool = false,
        )
    result = ImmutableDataFrame2ClassificationKnetTransformer(
        featurenames,
        dffeaturecontrasts,
        labelnames,
        labellevels,
        index,
        transposefeatures,
        transposelabels,
        )
    return result
end

function transform(
        transformer::ImmutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    if length(transformer.labelnames) == 0
        error("length(transformer.labelnames) == 0")
    elseif length(transformer.labelnames) == 1
        label_1 = transformer.labelnames[1]
        levels_1 = transformer.labellevels[label_1]
        labelstring2intmap_1 = _getlabelstring2intmap(
            levels_1,
            transformer.index,
            )
        labelsarray = [labelstring2intmap_1[y] for y in labelsdf[label_1]]
        @assert(typeof(labelsarray) <: AbstractVector)
        @assert(length(labelsarray) == size(labelsdf, 1))
    else
        labelsarray = -99 * ones(size(labelsdf, 1), length(transformer.labelnames))
        for j = 1:length(transformer.labelnames)
            label_j = transformer.labelnames[j]
            levels_j = transformer.labellevels[label_j]
            labelstring2intmap_j = _getlabelstring2intmap(
                levels_j,
                transformer.index,
                )
            labelsarray[:, j] =
                [labelstring2intmap_j[y] for y in labelsdf[label_j]]
        end
    end
    modelformula = makeformula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = transformer.dffeaturecontrasts.featurecontrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarray = transpose(featuresarray)
    end
    if transformer.transposelabels
        labelsarray = transpose(labelsarray)
    end
    featuresarray = convert(Array, featuresarray)
    labelsarray = convert(Array, labelsarray)
    return featuresarray, labelsarray
end

function transform(
        transformer::ImmutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        kwargs...
        )
    modelformula = makeformula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = transformer.dffeaturecontrasts.featurecontrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarray = transpose(featuresarray)
    end
    return featuresarray
end

function fit!(
        transformer::ImmutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict(
        transformer::ImmutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

function predict_proba(
        transformer::ImmutableDataFrame2ClassificationKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

struct ImmutableDataFrame2RegressionKnetTransformer <:
        AbstractPrimitiveObject
    featurenames::T1 where T1 <: AbstractVector
    dffeaturecontrasts::T2 where T2 <: AbstractContrastsObject
    labelnames::T3 where T3 <: SymbolVector
    transposefeatures::T4 where T4 <: Bool
    transposelabels::T5 where T5 <: Bool
end

function valuehistories(x::ImmutableDataFrame2RegressionKnetTransformer)
    return nothing
end

function ImmutableDataFrame2RegressionKnetTransformer(
        featurenames::AbstractVector,
        dffeaturecontrasts::AbstractContrastsObject,
        labelnames::SymbolVector;
        transposefeatures::Bool = true,
        transposelabels::Bool = false,
        )
    result = ImmutableDataFrame2RegressionKnetTransformer(
        featurenames,
        dffeaturecontrasts,
        labelnames,
        transposefeatures,
        transposelabels,
        )
    return result
end

function transform(
        transformer::ImmutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    labelsarray = hcat(
        [
            labelsdf[label] for label in transformer.labelnames
            ]...
        )
    modelformula = makeformula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = transformer.dffeaturecontrasts.featurecontrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarray = transpose(featuresarray)
    end
    if transformer.transposelabels
        labelsarray = transpose(labelsarray)
    end
    featuresarray = convert(Array, featuresarray)
    labelsarray = convert(Array, labelsarray)
    return featuresarray, labelsarray
end

function transform(
        transformer::ImmutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        kwargs...
        )
    modelformula = makeformula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = transformer.dffeaturecontrasts.featurecontrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarray = transpose(featuresarray)
    end
    return featuresarray
end

function fit!(
        transformer::ImmutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict(
        transformer::ImmutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

function predict_proba(
        transformer::ImmutableDataFrame2RegressionKnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
