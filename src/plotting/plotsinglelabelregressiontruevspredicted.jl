import LaTeXStrings
import PGFPlots
import PGFPlotsX

function plotsinglelabelregressiontrueversuspredicted(
        estimator::AbstractObject,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol;
        includeorigin::Bool = false,
        )
    ytrue = singlelabelregressionytrue(
        labelsdf[singlelabelname],
        )
    predictionsalllabels = predict(estimator, featuresdf)
    ypred = singlelabelregressionypred(
        predictionsalllabels[singlelabelname],
        )
    truevalueversuspredictedvalue_linearplotobject = PGFPlots.Plots.Linear(
        ytrue,
        ypred,
        onlyMarks = true,
        style = "black,fill=black",
        )
    if includeorigin
        perfectlinevalues = sort(
            unique(
                vcat(
                    0,
                    ytrue,
                    ),
                );
            rev = false,
            )
    else
        perfectlinevalues = sort(
            unique(
                ytrue,
                );
            rev = false,
            )
    end
    perfectline_linearplotobject = PGFPlots.Plots.Linear(
        perfectlinevalues,
        perfectlinevalues,
        mark = "none",
        style = "red",
        )
    axisobject = PGFPlots.Axis(
        [
            truevalueversuspredictedvalue_linearplotobject,
            perfectline_linearplotobject,
            ],
        xlabel = LaTeXStrings.LaTeXString("True value"),
        ylabel = LaTeXStrings.LaTeXString("Predicted value"),
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end
