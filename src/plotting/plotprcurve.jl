import LaTeXStrings
import PGFPlots

function plotprcurve(
        estimator::AbstractObject,
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
        linearplotobject_i = PGFPlots.Plots.Linear(
            allrecalls,
            allprecisions,
            legendentry = LaTeXStrings.LaTeXString(estimator_i.name),
            mark = "none",
            )
        push!(alllinearplotobjects, linearplotobject_i)
    end
    axisobject = PGFPlots.Axis(
        [alllinearplotobjects...],
        xlabel = LaTeXStrings.LaTeXString("Recall"),
        ylabel = LaTeXStrings.LaTeXString("Precision"),
        legendPos = "south west",
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end

const plotprcurves = plotprcurve
