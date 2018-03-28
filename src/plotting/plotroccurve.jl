import LaTeXStrings
import PGFPlots
import PGFPlotsX

function plotroccurve(
        estimator::AbstractObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString,
        )
    vectorofestimators = [estimator]
    result = plotroccurve(
        vectorofestimators,
        featuresdf,
        labelsdf,
        singlelabelname,
        positiveclass,
        )
    return result
end

function plotroccurve(
        vectorofestimators::AbstractObjectVector,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString,
        )
    if length(vectorofestimators) == 0
        error("length(vectorofestimators) == 0")
    end
    alllinearplotobjects = []
    for i = 1:length(vectorofestimators)
        estimator_i = vectorofestimators[i]
        metrics_i = _singlelabelbinaryclassclassificationmetrics(
            estimator_i,
            featuresdf,
            labelsdf,
            singlelabelname,
            positiveclass;
            threshold = 0.5,
            )
        ytrue_i = metrics_i[:ytrue]
        yscore_i = metrics_i[:yscore]
        allfpr_i, alltpr_i, allthresholds_i = roccurve(
            ytrue_i,
            yscore_i,
            )
        linearplotobject_i = PGFPlots.Plots.Linear(
            allfpr_i,
            alltpr_i,
            legendentry = LaTeXStrings.LaTeXString(estimator_i.name),
            mark = "none",
            )
        push!(alllinearplotobjects, linearplotobject_i)
    end
    axisobject = PGFPlots.Axis(
        [alllinearplotobjects...],
        xlabel = LaTeXStrings.LaTeXString("False positive rate"),
        ylabel = LaTeXStrings.LaTeXString("True positive rate"),
        legendPos = "outer north east",
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end

const plotroccurves = plotroccurve
