import LaTeXStrings
import PGFPlotsX

"""
"""
function plotsinglelabelregressiontrueversuspredicted(
        estimator::AbstractFittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol;
        includeorigin::Bool = false,
        legend_pos::AbstractString = "outer north east",
        )::PGFPlotsXPlot
    ytrue = singlelabelregressionytrue(
        labels_df[single_label_name],
        )
    predictionsalllabels = predict(estimator, features_df)
    ypred = singlelabelregressionypred(
        predictionsalllabels[single_label_name],
        )
    truevalueversuspredictedvalue_linearplotobject = PGFPlotsX.@pgf(
        PGFPlotsX.Plot(
            {
                only_marks,
                style = "black, fill = black",
                },
            PGFPlotsX.Coordinates(
                ypred,
                ytrue,
                ),
            )
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
    perfectline_linearplotobject = PGFPlotsX.@pgf(
        PGFPlotsX.Plot(
            {
                no_marks,
                style = "dotted, red, color=red, fill=red",
                },
            PGFPlotsX.Coordinates(
                perfectlinevalues,
                perfectlinevalues,
                ),
            ),
    )
    estimated_intercept,
        estimated_x_coefficient = simple_linear_regression(
            Float64.(ypred), # X
            Float64.(ytrue), # Y
            )
    bestfitline_linearplotobject = PGFPlotsX.@pgf(
        PGFPlotsX.Plot(
            {
                no_marks,
                style = "dashed, blue, color=blue, fill=blue",
                },
            PGFPlotsX.Coordinates(
                perfectlinevalues,
                estimated_intercept .+ estimated_x_coefficient*perfectlinevalues,
                ),
            ),
        )
    p = PGFPlotsX.@pgf(
        PGFPlotsX.Axis(
            {
                xlabel = LaTeXStrings.LaTeXString(
                    "Predicted value"
                    ),
                ylabel = LaTeXStrings.LaTeXString(
                    "True value"
                    ),
                legend_pos = legend_pos,
                },
            truevalueversuspredictedvalue_linearplotobject,
            perfectline_linearplotobject,
            bestfitline_linearplotobject,
            ),
        )
    wrapper = PGFPlotsXPlot(p)
    return wrapper
end

