import DataFrames

immutable ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer <:
        AbstractPrimitiveObject
    label::T1 where T1 <: Symbol
    positiveclass::T2 where T2 <: AbstractString
end

function setfeaturecontrasts!(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        contrasts::AbstractContrasts,
        )
    return nothing
end

function getunderlying(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function setunderlying!(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        object;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function gethistory(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer;
        saving::Bool = false,
        loading::Bool = false,
        )
    return nothing
end

function sethistory!(
        x::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        h;
        saving::Bool = false,
        loading::Bool = false,
        )
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

function predict(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end


function predict_proba(
        transformer::ImmutableDataFrame2GLMSingleLabelBinaryClassTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
