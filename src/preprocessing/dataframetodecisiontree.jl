import DataFrames
import StatsModels

mutable struct MutableDataFrame2DecisionTreeTransformer <:
        AbstractEstimator
    featurenames::T1 where T1 <: AbstractVector
    singlelabelname::T2 where T2 <: Symbol
    levels::T3 where T3 <: AbstractVector
    dffeaturecontrasts::T4 where T4 <: AbstractContrasts
    function MutableDataFrame2DecisionTreeTransformer(
            featurenames::AbstractVector,
            singlelabelname::Symbol;
            levels::AbstractVector = [],
            )
        result = new(
            featurenames,
            singlelabelname,
            levels,
            )
        return result
    end
end

function setfeaturecontrasts!(
        x::MutableDataFrame2DecisionTreeTransformer,
        contrasts::AbstractContrasts,
        )
    x.dffeaturecontrasts = contrasts
    return nothing
end

function get_underlying(
        x::MutableDataFrame2DecisionTreeTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    result = x.dffeaturecontrasts
    return result
end

function set_underlying!(
        x::MutableDataFrame2DecisionTreeTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    x.dffeaturecontrasts = object
    return nothing
end

function gethistory(
        x::MutableDataFrame2DecisionTreeTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::MutableDataFrame2DecisionTreeTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function transform(
        transformer::MutableDataFrame2DecisionTreeTransformer,
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
        transformer::MutableDataFrame2DecisionTreeTransformer,
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
        transformer::MutableDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

function predict_proba(
        transformer::MutableDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
