import DataFrames

struct ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer <:
        AbstractPrimitiveObject
    label::T1 where T1 <: Symbol
    positiveclass::T2 where T2 <: AbstractString
end

function underlying(::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer)
    return nothing
end

function transform(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
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
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return featuresdf
end

function fit!(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict_proba(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
