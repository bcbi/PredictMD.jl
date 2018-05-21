import LaTeXStrings
import PGFPlots
import PGFPlotsX

function plotsinglelabelregressiontrueversuspredicted(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol;
        includeorigin::Bool = false,
        )
    ytrue = singlelabelregressionytrue(
        labels_df[singlelabelname],
        )
    predictionsalllabels = predict(estimator, features_df)
    ypred = singlelabelregressionypred(
        predictionsalllabels[singlelabelname],
        )
    truevalueversuspredictedvalue_linearplotobject = PGFPlots.Plots.Linear(
        ypred,
        ytrue,
        onlyMarks = true,
        style = "black, fill = black",
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
        style = "dotted, fill=red",
        )
    estimated_intercept,
        estimated_x_coefficient = ordinary_least_squares_regression(
            Float64.(ypred), # X
            Float64.(ytrue); # Y
            intercept = true,
            )
    bestfitline_linearplotobject = PGFPlots.Plots.Linear(
        perfectlinevalues,
        estimated_intercept + estimated_x_coefficient*perfectlinevalues,
        mark = "none",
        style = "dashed, fill=blue",
        )
    axisobject = PGFPlots.Axis(
        [
            truevalueversuspredictedvalue_linearplotobject,
            perfectline_linearplotobject,
            bestfitline_linearplotobject,
            ],
        xlabel = LaTeXStrings.LaTeXString("Predicted value"),
        ylabel = LaTeXStrings.LaTeXString("True value"),
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
end
