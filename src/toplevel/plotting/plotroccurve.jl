##### Beginning of file

import LaTeXStrings
import PGFPlots
import PGFPlotsX

"""
"""
function plotroccurves(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString,
        )
    vectorofestimators = [estimator]
    result = plotroccurve(
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
function plotroccurves(
        vectorofestimators::AbstractVector{Fittable},
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString,
        )
    if length(vectorofestimators) == 0
        error("length(vectorofestimators) == 0")
    end
    alllinearplotobjects = []
    for i = 1:length(vectorofestimators)
        estimator_i = vectorofestimators[i]
        metrics_i = _singlelabelbinaryclassificationmetrics(
            estimator_i,
            features_df,
            labels_df,
            single_label_name,
            positive_class;
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

const plotroccurve = plotroccurves

##### End of file
