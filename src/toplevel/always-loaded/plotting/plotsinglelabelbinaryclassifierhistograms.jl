import LaTeXStrings
import PGFPlotsX
import StatsBase

function num_histogram_bins(
        v::AbstractVector;
        closed::Symbol = :left,
        )::Integer
    h = StatsBase.fit(
        StatsBase.Histogram,
        v;
        closed = closed,
        )
    result = length(h.weights)
    return result
end

function normalized_histogram_weights(
        v::AbstractVector,
        edges::AbstractRange;
        closed::Symbol = :left,
        )
    h = StatsBase.fit(
        StatsBase.Histogram,
        v,
        edges;
        closed = closed,
        )
    unnormalized_weights = h.weights
    normalized_weights = unnormalized_weights/sum(unnormalized_weights)
    return normalized_weights
end

"""
"""
function plotsinglelabelbinaryclassifierhistogram(
        estimator::AbstractFittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        single_label_levels::AbstractVector{<:AbstractString};
        num_bins::Integer = 0,
        closed::Symbol = :left,
        legend_pos::AbstractString = "outer north east",
        # style = "blue,opacity = 0.5,fill=blue,fill opacity=0.5",
        negative_style::AbstractString =
            "blue, opacity=1.0, fill=blue, fill opacity = 0.5",
        positive_style::AbstractString =
            "red, opacity=1.0, fill=red, fill opacity = 0.5",
        # style = "red,opacity = 0.5,fill=red,fill opacity=0.5",
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
    yscore = Float64.(
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
    if num_bins < 1
        num_bins_negative_class = num_histogram_bins(yscore[ytrue .== 0])
        num_bins_positive_class = num_histogram_bins(yscore[ytrue .== 1])
        num_bins = max(num_bins_negative_class, num_bins_positive_class)
    end
    bin_width = 1/num_bins
    edges_range = 0:bin_width:1
    negative_class_histogram = normalized_histogram_weights(
        yscore[ytrue .== 0],
        edges_range;
        closed = closed,
        )
    positive_class_histogram = normalized_histogram_weights(
        yscore[ytrue .== 1],
        edges_range;
        closed = closed,
        )
    x_values = collect(edges_range)
    negative_class_y_values = vcat(negative_class_histogram..., 0)
    positive_class_y_values = vcat(positive_class_histogram..., 0)
    p = PGFPlotsX.@pgf(
        PGFPlotsX.Axis(
            {
                ymin = 0.0,
                ymax = 1.0,
                no_markers,
                legend_pos = legend_pos,
                xlabel = LaTeXStrings.LaTeXString(
                    "Classifier score"
                    ),
                ylabel = LaTeXStrings.LaTeXString(
                    "Frequency"
                    ),
                },
            PGFPlotsX.PlotInc(
                {
                    "ybar interval",
                    style = negative_style,
                    },
                PGFPlotsX.Coordinates(
                    x_values,
                    negative_class_y_values,
                    ),
                ),
            PGFPlotsX.PlotInc(
                {
                    "ybar interval",
                    style = positive_style,
                    },
                PGFPlotsX.Coordinates(
                    x_values,
                    positive_class_y_values,
                    ),
                ),
            ),
        )
    #             # "ybar interval",
    #             # "ybar",
    #             # bar_shift = "0pt",
    #             # "xticklabel interval boundaries",
    #             # xmajorgrids = false,
    #             # xtick = [0.0, 0.25, 0.5, 0.75, 1.0,],
    #             # xtick = [0.0, 0.5, 1.0,],
    #             # xticklabel = raw"$[\pgfmathprintnumber\tick,\pgfmathprintnumber\nexttick)$",
    #             # "xticklabel style" = {font = raw"\tiny", },
    #             },
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


