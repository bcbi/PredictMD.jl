import DataFrames
import StatsModels

abstract type AbstractDataFrame2DecisionTreejlTransformer <:
        AbstractTransformer
end

struct DataFrame2DecisionTreejlTransformer <:
        AbstractDataFrame2DecisionTreejlTransformer
    featurenames::T1 where T1 <: AbstractVector
    featurecontrasts::T2 where T2 <: Associative
    singlelabelname::T3 where T3 <: Symbol
    levels::T4 where T4 <: AbstractVector
end

function DataFrame2DecisionTreejlTransformer(
        featurenames::AbstractVector,
        singlelabelname::Symbol,
        levels::AbstractVector,
        df::DataFrames.AbstractDataFrame,
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
    result = DataFrame2DecisionTreejlTransformer(
        featurenames,
        featurecontrasts,
        singlelabelname,
        levels,
        )
    return result
end

function transform(
        transformer::AbstractDataFrame2DecisionTreejlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        )
    singlelabelname = transformer.singlelabelname
    labelsarray = convert(Array, labelsdf[singlelabelname])
    @assert(typeof(labelsarray) <: AbstractVector)
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
    return featuresarray, labelsarray
end

function transform(
        transformer::AbstractDataFrame2DecisionTreejlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
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
    return featuresarray
end

function fit!(
        transformer::AbstractDataFrame2DecisionTreejlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::AbstractDataFrame2DecisionTreejlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        )
    return transform(transformer, featuresdf)
end
