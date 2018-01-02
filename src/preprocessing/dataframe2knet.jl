import DataFrames
import StatsModels

abstract type AbstractDataFrame2KnetjlTransformer <:
        AbstractTransformer
end

struct DataFrame2KnetjlTransformer <:
        AbstractDataFrame2KnetjlTransformer
    featurenames::T1 where T1 <: AbstractVector
    featurecontrasts::T2 where T2 <: Associative
    labelnames::T3 where T3 <: VectorOfSymbols
    labellevels::T4 where T4 <: Associative
    index::T5 where T5 <: Integer
    transposefeatures::T6 where T6 <: Bool
end

function DataFrame2KnetjlTransformer(
        featurenames::AbstractVector,
        labelnames::VectorOfSymbols,
        labellevels::Associative,
        index::Integer,
        df::DataFrames.AbstractDataFrame;
        transposefeatures::Bool = true,
        )
    if length(featurenames) == 0
        error("length(featurenames) == 0")
    end
    modelformula = makeformula(
        featurenames[1],
        featurenames;
        intercept = false
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        df,
        )
    featurecontrasts = modelframe.contrasts
    result = DataFrame2KnetjlTransformer(
        featurenames,
        featurecontrasts,
        labelnames,
        labellevels,
        index,
        transposefeatures,
        )
    return result
end

function transform(
        transformer::AbstractDataFrame2KnetjlTransformer,
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
    featurecontrasts = transformer.featurecontrasts
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = featurecontrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarraytransposed = transpose(featuresarray)
        return featuresarraytransposed, labelsarray
    else
        return featuresarray, labelsarray
    end
end

function transform(
        transformer::AbstractDataFrame2KnetjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        kwargs...
        )
    modelformula = makeformula(
        transformer.featurenames[1],
        transformer.featurenames;
        intercept = false
        )
    featurecontrasts = transformer.featurecontrasts
    modelframe = StatsModels.ModelFrame(
        modelformula,
        featuresdf;
        contrasts = featurecontrasts,
        )
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    if transformer.transposefeatures
        featuresarraytransposed = transpose(featuresarray)
        return featuresarraytransposed
    else
        return featuresarray
    end
end

function fit!(
        transformer::AbstractDataFrame2KnetjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::AbstractDataFrame2KnetjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
