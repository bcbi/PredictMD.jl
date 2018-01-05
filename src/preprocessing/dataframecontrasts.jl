import DataFrames

immutable ImmutableDataFrameFeatureContrasts <: AbstractContrastsObject
    featurenames::T1 where T1 <: SymbolVector
    numdataframefeatures::T2 where T2 <: Integer
    featurecontrasts::T3 where T3 <: Associative
    numarrayfeatures::T4 where T4 <: Integer
end

function ImmutableDataFrameFeatureContrasts(
        df::DataFrames.AbstractDataFrame,
        featurenames::SymbolVector,
        )
    numdataframefeatures = length(unique(featurenames))
    modelformula = makeformula(
        featurenames[1],
        featurenames;
        intercept = false,
        )
    modelframe = StatsModels.ModelFrame(
        modelformula,
        df,
        )
    featurecontrasts = modelframe.contrasts
    modelmatrix = StatsModels.ModelMatrix(modelframe)
    featuresarray = modelmatrix.m
    numarrayfeatures = size(featuresarray, 2)
    result = ImmutableDataFrameFeatureContrasts(
        featurenames,
        numdataframefeatures,
        featurecontrasts,
        numarrayfeatures,
        )
    return result
end

function featurecontrasts(
        df::DataFrames.AbstractDataFrame,
        featurenames::SymbolVector,
        )
    result = ImmutableDataFrameFeatureContrasts(
        df,
        featurenames,
        )
    return result
end
