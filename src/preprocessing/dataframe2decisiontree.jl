import DataFrames
import StatsModels

abstract type AbstractDataFrame2DecisionTreeTransformer <:
        AbstractTransformer
end

struct DataFrame2DecisionTreeTransformer <:
        AbstractDataFrame2DecisionTreeTransformer
    featurenames::T1 where T1 <: AbstractVector
    dffeaturecontrasts::T2 where T2 <: ImmutableDataFrameFeatureContrasts
    singlelabelname::T3 where T3 <: Symbol
    levels::T4 where T4 <: AbstractVector
end

function DataFrame2DecisionTreeTransformer(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        levels::AbstractVector,
        df::DataFrames.AbstractDataFrame,
        )
    dffeaturecontrasts = ImmutableDataFrameFeatureContrasts(
        df,
        featurenames,
        )
    result = DataFrame2DecisionTreeTransformer(
        featurenames,
        dffeaturecontrasts,
        singlelabelname,
        levels,
        )
    return result
end

function transform(
        transformer::AbstractDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    singlelabelname = transformer.singlelabelname
    labelsarray = convert(Array, labelsdf[singlelabelname])
    @assert(typeof(labelsarray) <: AbstractVector)
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
    return featuresarray, labelsarray
end

function transform(
        transformer::AbstractDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
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
    return featuresarray
end

function fit!(
        transformer::AbstractDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::AbstractDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
