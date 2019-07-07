import LaTeXStrings
import PGFPlotsX

"""
"""
function plotroccurves(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        kwargs...,
        )
    vectorofestimators = [estimator]
    result = plotroccurve(
        vectorofestimators,
        features_df,
        labels_df,
        single_label_name,
        positive_class;
        kwargs...,
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
        positive_class::AbstractString;
        legend_pos::AbstractString = "outer north east",
        )
    legend_pos::String = convert(String, legend_pos)
    if length(vectorofestimators) == 0
        error("length(vectorofestimators) == 0")
    end
    all_plots_and_legends = []
    for i = 1:length(vectorofestimators)
        estimator_i = vectorofestimators[i]
        metrics_i = singlelabelbinaryclassificationmetrics_resultdict(
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
        plot_i = PGFPlotsX.@pgf(
            PGFPlotsX.Plot(
                PGFPlotsX.Coordinates(
                    allfpr_i,
                    alltpr_i,
                    ),
                ),
            )
        legend_i = PGFPlotsX.@pgf(
            PGFPlotsX.LegendEntry(
                LaTeXStrings.LaTeXString(estimator_i.name)
                ),
            )
        push!(all_plots_and_legends, plot_i)
        push!(all_plots_and_legends, legend_i)
    end
    all_plots_and_legends = [all_plots_and_legends...]
    p = PGFPlotsX.@pgf(
        PGFPlotsX.Axis(
            {
                xlabel = "False positive rate",
                ylabel = "True positive rate",
                no_markers,
                legend_pos = legend_pos,
                },
            all_plots_and_legends...,
            ),
        )
    wrapper = PGFPlotsXPlot(p)
    return wrapper
end

const plotroccurve = plotroccurves

