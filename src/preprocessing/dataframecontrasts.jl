import DataFrames

immutable ImmutableDataFrameFeatureContrasts <: AbstractPrimitiveObject
    featurenames::T1 where T1 <: SymbolVector
    numdataframefeatures::T2 where T <: Integer
    featurecontrasts::T3 where T3 <: Associative
    numarrayfeatures::T4 where T <: Integer
end

function ImmutableDataFrameFeatureContrasts(
        df::DataFrames.AbstractDataFrames,
        featurenames::SymbolVector
        )
    modelformula = makeformula(
        featurenames[1],
        featurenames;
        intercept = false,
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        df,
        )
    featurecontrasts = modelframe.constrasts
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    numarrayfeatures = size(featuresarray, 2)
    result = ImmutableDataFrameContrasts(
        featurenames,
        numdataframefeatures,
        featurecontrasts,
        numarrayfeatures,
        )
    return result
end
