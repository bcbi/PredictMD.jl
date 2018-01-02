import DataFrames

abstract type AbstractDataFrame2GLMjlTransformer <: AbstractTransformer
end

struct DataFrame2GLMjlTransformer <: AbstractDataFrame2GLMjlTransformer
    label::T1 where T1 <: Symbol
    positiveclass::T2 where T2 <: AbstractString
end

function transform(
        transformer::AbstractDataFrame2GLMjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    transformedlabelsdf = DataFrames.DataFrame()
    label = transformer.label
    positiveclass = transformer.positiveclass
    originallabelcolumn = labelsdf[label]
    transformedlabelcolumn = Int.(originallabelcolumn .== positiveclass)
    transformedlabelsdf[label] = transformedlabelcolumn
    return featuresdf, transformedlabelsdf
end

function transform(
        transformer::AbstractDataFrame2GLMjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return featuresdf
end

function fit!(
        transformer::AbstractDataFrame2GLMjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::AbstractDataFrame2GLMjlTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
