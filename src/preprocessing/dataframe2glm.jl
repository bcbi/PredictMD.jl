import DataFrames

abstract type AbstractDataFrame2GLMjlTransformer <: AbstractTransformer
end

struct DataFrame2GLMjlTransformer <: AbstractDataFrame2GLMjlTransformer
    label::T1 where T1 <: Symbol
    positiveclass::T2 where T2 <: AbstractString
end

function transform(
        transformer::T1,
        featuresdf::T2,
        labelsdf::T3,
        ) where
        T1 <: AbstractDataFrame2GLMjlTransformer where
        T2 <: DataFrames.AbstractDataFrame where
        T3 <: DataFrames.AbstractDataFrame
    transformedlabelsdf = DataFrames.DataFrame()
    label = transformer.label
    positiveclass = transformer.positiveclass
    originallabelcolumn = labelsdf[label]
    transformedlabelcolumn = Int.(originallabelcolumn .== positiveclass)
    transformedlabelsdf[label] = transformedlabelcolumn
    return featuresdf, transformedlabelsdf
end

function transform(
        transformer::T1,
        featuresdf::T2,
        ) where
        T1 <: AbstractDataFrame2GLMjlTransformer where
        T2 <: DataFrames.AbstractDataFrame
    return featuresdf
end

function fit!(
        transformer::T1,
        featuresdf::T2,
        labelsdf::T3,
        ) where
        T1 <: AbstractDataFrame2GLMjlTransformer where
        T2 <: DataFrames.AbstractDataFrame where
        T3 <: DataFrames.AbstractDataFrame
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::T1,
        featuresdf::T2,
        ) where
        T1 <: AbstractDataFrame2GLMjlTransformer where
        T2 <: DataFrames.AbstractDataFrame
    return transform(transformer, featuresdf)
end
