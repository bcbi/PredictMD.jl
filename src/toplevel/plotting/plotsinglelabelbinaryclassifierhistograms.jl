##### Beginning of file

import LaTeXStrings
import PGFPlotsX

"""
"""
function plotsinglelabelbinaryclassifierhistogram(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        single_label_levels::AbstractVector{<:AbstractString};
        numbins::Integer = 25,
        )::PGFPlotsXPlot
    # if length(single_label_levels) != length(unique(single_label_levels))
    #     error("there are duplicate values in single_label_levels")
    # end
    # if length(single_label_levels) != 2
    #     error("length(single_label_levels) != 2")
    # end
    # negative_class = single_label_levels[1]
    # positive_class = single_label_levels[2]
    # predictedprobabilitiesalllabels = predict_proba(estimator, features_df)
    # yscore = Cfloat.(
    #     singlelabelbinaryyscore(
    #         predictedprobabilitiesalllabels[single_label_name],
    #         positive_class,
    #         )
    #     )
    # ytrue = Int.(
    #     singlelabelbinaryytrue(
    #         labels_df[single_label_name],
    #         positive_class,
    #         )
    #     )
    # histogramobjectnegative_class = PGFPlots.Plots.Histogram(
    #     yscore[ytrue .== 0],
    #     bins = numbins,
    #     style = "blue, opacity = 0.5, fill=blue, fill opacity=0.5",
    #     )
    # histogramobjectpositive_class = PGFPlots.Plots.Histogram(
    #     yscore[ytrue .== 1],
    #     bins = numbins,
    #     style = "red, opacity = 0.5, fill=red, fill opacity=0.5",
    #     )
    # axisobject = PGFPlots.Axis(
    #     [
    #         histogramobjectnegative_class,
    #         PGFPlots.Plots.Command("\\addlegendentry{$(negative_class)}"),
    #         histogramobjectpositive_class,
    #         PGFPlots.Plots.Command("\\addlegendentry{$(positive_class)}"),
    #         ],
    #     style = "reverse legend",
    #     xlabel = LaTeXStrings.LaTeXString("Classifier score"),
    #     ylabel = LaTeXStrings.LaTeXString("Frequency"),
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

##### End of file
