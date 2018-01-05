import DataFrames
import StatsModels

struct ImmutableDataFrame2KnetTransformer <:
        AbstractPrimitiveObject
    featurenames::T1 where T1 <: AbstractVector
    dffeaturecontrasts::T2 where T2 <: ImmutableDataFrameFeatureContrasts
    labelnames::T3 where T3 <: SymbolVector
    labellevels::T4 where T4 <: Associative
    index::T5 where T5 <: Integer
    transposefeatures::T6 where T6 <: Bool
    transposelabels::T7 where T7 <: Bool
end

function ImmutableDataFrame2KnetTransformer(
        featurenames::AbstractVector,
        labelnames::SymbolVector,
        labellevels::Associative,
        index::Integer,
        df::DataFrames.AbstractDataFrame;
        transposefeatures::Bool = true,
        transposelabels::Bool = false,
        )
    dffeaturecontrasts = ImmutableDataFrameFeatureContrasts(
        df,
        featurenames
        )
    result = ImmutableDataFrame2KnetTransformer(
        featurenames,
        dffeaturecontrasts,
        labelnames,
        labellevels,
        index,
        transposefeatures,
        )
    return result
end

function transform(
        transformer::ImmutableDataFrame2KnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    labelsarraynumrows = size(labelsdf, 1)
    labelsarraynumcols = length(transformer.labelnames)
    if labelsarraynumcols == 0
        error("length(transformer.labelnames) == 0")
    elseif labelsarraynumcols == 1
        label_1 = transformer.labelnames[1]
        levels_1 = transformer.labellevels[label_1]
        labelstring2intmap_1 = _getlabelstring2intmap(
            levels_1,
            transformer.index,
            )
        labelsarray = [labelstring2intmap_1[y] for y in labelsdf[label_1]]
        @assert(typeof(labelsarray) <: AbstractVector)
        @assert(length(labelsarray) == labelsarraynumrows)
    else
        labelsarray = -99 * ones(labelsarraynumrows, labelsarraynumcols)
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
    if typeof(labelsarray) <: AbstractMatrix
        if size(labelsarray, 1) == 1 | size(labelsarray, 2) == 1
            labelsarray = convert(Vector, vec(labelsarray))
        end
    end
    return featuresarray, labelsarray
end

function transform(
        transformer::ImmutableDataFrame2KnetTransformer,
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
        transformer::ImmutableDataFrame2KnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::ImmutableDataFrame2KnetTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
