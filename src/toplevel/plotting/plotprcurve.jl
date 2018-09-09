##### Beginning of file

import LaTeXStrings
import PGFPlotsX

"""
"""
function plotprcurves(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString,
        )
    vectorofestimators = [estimator]
    result = plotprcurve(
        vectorofestimators,
        features_df,
        labels_df,
        single_label_name,
        positive_class,
        )
    return result
end

"""
"""
function plotprcurves(
        vectorofestimators::AbstractVector{Fittable},
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString,
        )::PGFPlotsXPlot
    # if length(vectorofestimators) == 0
    #     error("length(vectorofestimators) == 0")
    # end
    # alllinearplotobjects = []
    # for i = 1:length(vectorofestimators)
    #     estimator_i = vectorofestimators[i]
    #     metrics_i = _singlelabelbinaryclassificationmetrics(
    #         estimator_i,
    #         features_df,
    #         labels_df,
    #         single_label_name,
    #         positive_class;
    #         threshold = 0.5,
    #         )
    #     ytrue_i = metrics_i[:ytrue]
    #     yscore_i = metrics_i[:yscore]
    #     allprecisions, allrecalls, allthresholds = prcurve(
    #         ytrue_i,
    #         yscore_i,
    #         )
    #     linearplotobject_i = PGFPlots.Plots.Linear(
    #         allrecalls,
    #         allprecisions,
    #         legendentry = LaTeXStrings.LaTeXString(estimator_i.name),
    #         mark = "none",
    #         )
    #     push!(alllinearplotobjects, linearplotobject_i)
    # end
    # axisobject = PGFPlots.Axis(
    #     [alllinearplotobjects...],
    #     xlabel = LaTeXStrings.LaTeXString("Recall"),
    #     ylabel = LaTeXStrings.LaTeXString("Precision"),
    #     legendPos = "outer north east",
    #     )
    # tikzpicture = PGFPlots.plot(axisobject)
    # # return tikzpicture
    # p = PGFPlotsX.@pgf(
    #
    #     )
    # wrapper = PGFPlotsXPlot(p)
    wrapper = PGFPlotsXPlot(nothing)
    return wrapper
end

const plotprcurve = plotprcurves

##### End of file
