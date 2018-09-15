##### Beginning of file

import LaTeXStrings
import PGFPlotsX
import StatsBase



"""
"""
function plotsinglelabelbinaryclassifierhistogram(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        single_label_levels::AbstractVector{<:AbstractString};
        nbins::Union{Nothing, Integer} = nothing,
        closed::Symbol = :right,
        legend_pos::AbstractString = "outer north east",
        )::PGFPlotsXPlot
    if length(single_label_levels) != length(unique(single_label_levels))
        error("there are duplicate values in single_label_levels")
    end
    if length(single_label_levels) != 2
        error("length(single_label_levels) != 2")
    end
    negative_class = single_label_levels[1]
    positive_class = single_label_levels[2]
    predictedprobabilitiesalllabels = predict_proba(estimator, features_df)
    yscore = Cfloat.(
        singlelabelbinaryyscore(
            predictedprobabilitiesalllabels[single_label_name],
            positive_class,
            )
        )
    ytrue = Int.(
        singlelabelbinaryytrue(
            labels_df[single_label_name],
            positive_class,
            )
        )
    if isa(nbins, Nothing)
        negative_class_histogram = StatsBase.fit(
            StatsBase.Histogram,
            yscore[ytrue .== 0];
            closed = closed,

            )
        positive_class_histogram = StatsBase.fit(
            StatsBase.Histogram,
            yscore[ytrue .== 1];
            closed = closed,
            )
    else
        negative_class_histogram = StatsBase.fit(
            StatsBase.Histogram,
            yscore[ytrue .== 0];
            closed = closed,
            nbins = nbins,
            )
        positive_class_histogram = StatsBase.fit(
            StatsBase.Histogram,
            yscore[ytrue .== 1];
            closed = closed,
            nbins = nbins,
            )
    end
    p = PGFPlotsX.@pgf(
        PGFPlotsX.Axis(
            {
                legend_pos = legend_pos,
                xlabel = LaTeXStrings.LaTeXString(
                    "Classifier score"
                    ),
                ylabel = LaTeXStrings.LaTeXString(
                    "Frequency"
                    ),
                "ybar interval",
                "xticklabel interval boundaries",
                xmajorgrids = false,
                xticklabel = raw"$[\pgfmathprintnumber\tick,\pgfmathprintnumber\nexttick)$",
                "xticklabel style" = {font = raw"\tiny", },
                },
            PGFPlotsX.Plot(
                {
                    style = "blue, opacity = 0.5, fill=blue, fill opacity=0.5",
                    },
                PGFPlotsX.Table(negative_class_histogram),
                ),
            PGFPlotsX.Plot(
                {
                    style = "red, opacity = 0.5, fill=red, fill opacity=0.5",
                    },
                PGFPlotsX.Table(positive_class_histogram),
                ),
            ),
        )
    # axisobject = PGFPlots.Axis(
    #     [
    #         histogramobjectnegative_class,
    #         PGFPlots.Plots.Command("\\addlegendentry{$(negative_class)}"),
    #         histogramobjectpositive_class,
    #         PGFPlots.Plots.Command("\\addlegendentry{$(positive_class)}"),
    #         ],
    #     style = "reverse legend",
    #     )
    wrapper = PGFPlotsXPlot(p)
    return wrapper
end


# Examples from https://kristofferc.github.io/PGFPlotsX.jl/latest/examples/juliatypes.html

# one_dimensional_example = PGFPlotsX.@pgf(
#     PGFPlotsX.Axis(
#         {
#             "ybar interval",
#             "xticklabel interval boundaries",
#             xmajorgrids = false,
#             xticklabel = raw"$[\pgfmathprintnumber\tick,\pgfmathprintnumber\nexttick)$",
#             "xticklabel style" = {font = raw"\tiny", },
#             },
#         PGFPlotsX.Plot(
#             PGFPlotsX.Table(
#                 StatsBase.fit(
#                     StatsBase.Histogram,
#                     range(0; stop = 1, length = 100).^3;
#                     closed = :left,
#                     ),
#                 ),
#             ),
#         ),
#     )

# w = range(-1; stop = 1, length = 100) .^ 3
# xy = vec(tuple.(w, w'))
# h = StatsBase.fit(
#     StatsBase.Histogram,
#     (first.(xy), last.(xy));
#     closed = :left,
#     )
# two_dimensional_example = PGFPlotsX.@pgf(
#     PGFPlotsX.Axis(
#         {
#             view = (0, 90),
#             colorbar,
#             "colormap/jet",
#             },
#         PGFPlotsX.Plot3(
#             {
#                 surf,
#                 shader = "flat",
#                 },
#             PGFPlotsX.Table(h)
#             ),
#         ),
#     )


##### End of file
