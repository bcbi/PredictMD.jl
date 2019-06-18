import LaTeXStrings
import PGFPlotsX
import Statistics

"""
"""
function probability_calibration_scores_and_fractions(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        window::Real = 0.1,
        )
    ytrue = Int.(
        singlelabelbinaryytrue(
            labels_df[single_label_name],
            positive_class,
            )
        )
    predictedprobabilitiesalllabels = predict_proba(estimator, features_df)
    yscore = Cfloat.(
        singlelabelbinaryyscore(
            predictedprobabilitiesalllabels[single_label_name],
            positive_class,
            )
        )
    scores, fractions = probability_calibration_scores_and_fractions(
        ytrue,
        yscore;
        window = window,
        )
    return scores, fractions
end

"""
"""
function probability_calibration_scores_and_fractions(
        ytrue::AbstractVector{<: Integer},
        yscore::AbstractVector{F};
        window::Real = 0.1,
        )::Tuple{Vector{F}, Vector{F}} where
        F <: AbstractFloat
    scores = sort(
        unique(
            vcat(
                yscore,
                zero(eltype(yscore)),
                one(eltype(yscore)),
                )
            )
        )
    fractions = fill(F(0), size(scores))
    num_rows = fill(Int(0), length(scores))
    for k = 1:length(scores)
        rows_that_have_approximately_the_kth_score = findall(
            ( scores[k] - window ) .<= ( yscore ) .<= ( scores[k] + window )
            )
        num_rows[k] = length(rows_that_have_approximately_the_kth_score)
        if length(rows_that_have_approximately_the_kth_score) == 0
            fractions[k] = NaN
        else
            fractions[k] = Statistics.mean(
                ytrue[rows_that_have_approximately_the_kth_score]
                )
        end
    end
    nonzero_indices = findall(num_rows .!= 0)
    scores_nonzero_indices::Vector{F} = scores[nonzero_indices]
    fractions_nonzero_indices::Vector{F} = fractions[nonzero_indices]
    return scores_nonzero_indices, fractions_nonzero_indices
end

"""
"""
function plot_probability_calibration_curve(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        window::Real = 0.1,
        multiply_by::Real = 1.0,
        legend_pos::AbstractString = "outer north east",
        )
    scores, fractions = probability_calibration_scores_and_fractions(
        estimator,
        features_df,
        labels_df,
        single_label_name,
        positive_class;
        window = window,
        )
    result = plot_probability_calibration_curve(
        scores,
        fractions;
        multiply_by = multiply_by,
        legend_pos = legend_pos,
        )
    return result
end

"""
"""
function plot_probability_calibration_curve(
        scores::AbstractVector{F},
        fractions::AbstractVector{F};
        multiply_by::Real = 1.0,
        legend_pos::AbstractString = "outer north east",
        )::PGFPlotsXPlot where F <: AbstractFloat
    legend_pos::String = convert(String, legend_pos)
    scores = convert(Vector{F}, scores * multiply_by)
    fractions = convert(Vector{F}, fractions * multiply_by)
    score_versus_fraction_linearplotobject = PGFPlotsX.@pgf(
        PGFPlotsX.Plot(
            {
                only_marks,
                style = "black, fill = black",
                },
            PGFPlotsX.Coordinates(
                scores,
                fractions,
                )
            )
        )
    zero_coordinate = convert(F, zero(F))
    one_coordinate = convert(F, one(F) * multiply_by)
    perfectline_xs = [
        zero_coordinate,
        one_coordinate,
        ]
    perfectline_ys = [
        zero_coordinate,
        one_coordinate,
        ]
    perfectline_linearplotobject = PGFPlotsX.@pgf(
        PGFPlotsX.Plot(
            {
                no_marks,
                style = "dotted, red, color=red, fill=red",
                },
            PGFPlotsX.Coordinates(
                perfectline_xs,
                perfectline_ys,
                ),
            )
        )
    estimated_intercept, estimated_x_coefficient =
        simple_linear_regression(
            scores, # X
            fractions, # Y
            )
    bestfitline_xs = [
        zero_coordinate,
        one_coordinate,
        ]
    bestfitline_ys = [
        estimated_intercept,
        estimated_intercept + estimated_x_coefficient * one_coordinate,
        ]
    bestfitline_linearplotobject = PGFPlotsX.@pgf(
        PGFPlotsX.Plot(
            {
                no_marks,
                style = "dashed, blue, color=blue, fill=blue",
                },
            PGFPlotsX.Coordinates(
                bestfitline_xs,
                bestfitline_ys,
                ),
            )
        )
    p = PGFPlotsX.@pgf(
        PGFPlotsX.Axis(
            {
                xlabel = LaTeXStrings.LaTeXString(
                    "Probability of positive class"
                    ),
                ylabel = LaTeXStrings.LaTeXString(
                    "Fraction of positive class"
                    ),
                legend_pos = legend_pos,
                },
            score_versus_fraction_linearplotobject,
            perfectline_linearplotobject,
            bestfitline_linearplotobject,
            ),
        )
    wrapper = PGFPlotsXPlot(p)
    return wrapper
end

"""
"""
function probability_calibration_metrics(
        estimator::Fittable,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString;
        window::Real = 0.1,
        )
    vectorofestimators = Fittable[estimator]
    result = probability_calibration_metrics(
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
function probability_calibration_metrics(
        vectorofestimators::AbstractVector{Fittable},
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        single_label_name::Symbol,
        positive_class::AbstractString,
        window::Real = 0.1,
        )
    result = DataFrames.DataFrame()
    result[:metric] = [
        "R^2 (coefficient of determination)",
        "Brier score (binary formulation)",
        "Best fit line: estimated intercept",
        "Best fit line: estimated coefficient",
        ]
    for i = 1:length(vectorofestimators)
        ytrue = Int.(
            singlelabelbinaryytrue(
                labels_df[single_label_name],
                positive_class,
                )
            )
        predictedprobabilitiesalllabels = predict_proba(
                vectorofestimators[i],
                features_df,
                )
        yscore = Cfloat.(
            singlelabelbinaryyscore(
                predictedprobabilitiesalllabels[single_label_name],
                positive_class,
                )
        )
        binary_brier_score_value = binary_brier_score(ytrue, yscore)
        scores, fractions = probability_calibration_scores_and_fractions(
            ytrue,
            yscore;
            window = window,
            )
        r2_score_value = r2_score(scores, fractions)
        estimated_intercept, estimated_x_coefficient =
            simple_linear_regression(
                Float64.(scores), # X
                Float64.(fractions), # Y
                )
        result[Symbol(vectorofestimators[i].name)] = [
            r2_score_value,
            binary_brier_score_value,
            estimated_intercept,
            estimated_x_coefficient,
            ]
    end
    return result
end
