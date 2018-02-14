import LaTeXStrings
import PGFPlots

function singlelabelbinaryclassclassifierhistogram(
        estimator::AbstractObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        singlelabellevels::SymbolVector,
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
        legendentry = LaTeXStrings.LaTeXString(negativeclass)
        )
    histogramobjectpositiveclass = PGFPlots.Plots.Histogram(
        yscore[ytrue .== 1],
        legendentry = LaTeXStrings.LaTeXString(positiveclass)
        )
    axisobject = PGFPlots.Axis(
        [histogramobjectnegativeclass, histogramobjectpositiveclass,],
        xlabel = LaTeXStrings.LaTeXString("Classifier score"),
        ylabel = LaTeXStrings.LaTeXString("Frequency"),
        legendPos = "outer north east",
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end
