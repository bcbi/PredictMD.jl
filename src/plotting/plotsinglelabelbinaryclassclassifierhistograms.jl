import LaTeXStrings
import PGFPlots
import PGFPlotsX

function plotsinglelabelbinaryclassclassifierhistogram(
        estimator::Fittable,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        singlelabellevels::AbstractVector{<:AbstractString};
        numbins::Integer = 25,
        )
    if length(singlelabellevels) != length(unique(singlelabellevels))
        error("there are duplicate values in singlelabellevels")
    end
    if length(singlelabellevels) != 2
        error("length(singlelabellevels) != 2")
    end
    negativeclass = singlelabellevels[1]
    positiveclass = singlelabellevels[2]
    predictedprobabilitiesalllabels = predict_proba(estimator, featuresdf)
    yscore = Cfloat.(
        singlelabelbinaryyscore(
            predictedprobabilitiesalllabels[singlelabelname],
            positiveclass,
            )
        )
    ytrue = Int.(
        singlelabelbinaryytrue(
            labelsdf[singlelabelname],
            positiveclass,
            )
        )
    histogramobjectnegativeclass = PGFPlots.Plots.Histogram(
        yscore[ytrue .== 0],
        bins = numbins,
        # style = "blue,fill=blue",
        style = "blue,fill=blue!10",
        )
    histogramobjectpositiveclass = PGFPlots.Plots.Histogram(
        yscore[ytrue .== 1],
        bins = numbins,
        # style = "red,fill=red",
        style = "red,fill=red!10",
        )
    axisobject = PGFPlots.Axis(
        [
            histogramobjectnegativeclass,
            PGFPlots.Plots.Command("\\addlegendentry{$(negativeclass)}"),
            histogramobjectpositiveclass,
            PGFPlots.Plots.Command("\\addlegendentry{$(positiveclass)}"),
            ],
        style = "reverse legend",
        xlabel = LaTeXStrings.LaTeXString("Classifier score"),
        ylabel = LaTeXStrings.LaTeXString("Frequency"),
        legendPos = "outer north east",
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end
