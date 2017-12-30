import LaTeXStrings
import PGFPlots

function plotprcurve(
        estimator::AbstractASBObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString,
        )
    vectorofestimators = [estimator]
    result = plotprcurve(
        vectorofestimators,
        featuresdf,
        labelsdf,
        singlelabelname,
        positiveclass,
        )
    return result
end

function plotprcurve(
        vectorofestimators::VectorOfAbstractASBObjects,
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
        metrics_i = _binaryclassificationmetrics(
            estimator_i,
            featuresdf,
            labelsdf,
            singlelabelname,
            positiveclass;
            threshold = 0.5,
            )
        ytrue_i = metrics_i[:ytrue]
        yscore_i = metrics_i[:yscore]
        allprecisions, allrecalls, allthresholds = prcurve(
            ytrue_i,
            yscore_i,
            )
        name_i = estimator_i.name
        @assert(typeof(name_i) <: AbstractString)
        legendentry_i = LaTeXStrings.LaTeXString(name_i)
        linearplotobject_i = PGFPlots.Plots.Linear(
            allrecalls,
            allprecisions,
            legendentry = legendentry_i,
            mark = "none",
            )
        push!(alllinearplotobjects, linearplotobject_i)
    end
    axisobject = PGFPlots.Axis(
        [alllinearplotobjects...],
        xlabel = "Recall",
        ylabel = "Precision",
        legendPos = "south west",
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end

const plotprcurves = plotprcurve
