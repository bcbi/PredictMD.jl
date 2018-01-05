import DataFrames
import StatsModels

immutable ImmutableDataFrame2DecisionTreeTransformer <:
        AbstractPrimitiveObject
    featurenames::T1 where T1 <: AbstractVector
    dffeaturecontrasts::T2 where T2 <: ImmutableDataFrameFeatureContrasts
    singlelabelname::T3 where T3 <: Symbol
    levels::T4 where T4 <: AbstractVector
end

function ImmutableDataFrame2DecisionTreeTransformer(
        featurenames::AbstractVector,
        dffeaturecontrasts::ImmutableDataFrameFeatureContrasts,
        singlelabelname::Symbol;
        levels::AbstractVector = [],
        )
    result = ImmutableDataFrame2DecisionTreeTransformer(
        featurenames,
        dffeaturecontrasts,
        singlelabelname,
        levels,
        )
    return result
end

function transform(
        transformer::ImmutableDataFrame2DecisionTreeTransformer,
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
        transformer::ImmutableDataFrame2DecisionTreeTransformer,
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
        transformer::ImmutableDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf, labelsdf)
end

function predict(
        transformer::ImmutableDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end

function predict_proba(
        transformer::ImmutableDataFrame2DecisionTreeTransformer,
        featuresdf::DataFrames.AbstractDataFrame;
        kwargs...
        )
    return transform(transformer, featuresdf)
end
