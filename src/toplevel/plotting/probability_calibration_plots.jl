##### Beginning of file

import LaTeXStrings
import PGFPlots
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
        multiply_by::Real = 1.0,
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
        multiply_by = multiply_by,
        )
    return scores, fractions
end

"""
"""
function probability_calibration_scores_and_fractions(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:AbstractFloat};
        window::Real = 0.1,
        multiply_by::Real = 1.0,
        )
    scores = sort(
        unique(
            vcat(
                yscore,
                zero(eltype(yscore)),
                one(eltype(yscore)),
                )
            )
        )
    fractions = zeros(scores)
    num_rows = zeros(Int, length(scores))
    for k = 1:length(scores)
        rows_that_have_approximately_the_kth_score = find(
            ( scores[k] - window ) .<= ( yscore ) .<= ( scores[k] + window )
            )
        num_rows[k] = length(rows_that_have_approximately_the_kth_score)
        if length(rows_that_have_approximately_the_kth_score) == 0
            fractions[k] = -999
        else
            fractions[k] = Statistics.mean(
                ytrue[rows_that_have_approximately_the_kth_score]
                )
        end
    end
    nonzero_indices = find(num_rows .!= 0)
    scores = scores[nonzero_indices]
    fractions = fractions[nonzero_indices]
    return scores, fractions
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
        )
    scores, fractions = probability_calibration_scores_and_fractions(
        estimator,
        features_df,
        labels_df,
        single_label_name,
        positive_class;
        window = window,
        multiply_by = multiply_by,
        )
    result = plot_probability_calibration_curve(scores, fractions)
    return result
end

"""
"""
function plot_probability_calibration_curve(
        scores::AbstractVector{<:AbstractFloat},
        fractions::AbstractVector{<:AbstractFloat},
        multiply_by::Real = 1.0,
        )
    scores = scores * multiply_by
    fractions = fractions * multiply_by
    score_versus_fraction_linearplotobject = PGFPlots.Plots.Linear(
        scores,
        fractions,
        onlyMarks = true,
        style = "black, fill = black",
        )
    point_at_zero = zero(eltype(fractions))
    point_at_one = multiply_by*one(eltype(fractions))
    perfectline_linearplotobject = PGFPlots.Plots.Linear(
        [
            point_at_zero,
            point_at_one,
            ],
        [
            point_at_zero,
            point_at_one,
            ],
        mark = "none",
        style = "dotted, fill=red",
        )
    estimated_intercept, estimated_x_coefficient =
        ordinary_least_squares_regression(
            scores, # X
            fractions; # Y
            intercept = true,
            )
    bestfitline_linearplotobject = PGFPlots.Plots.Linear(
        [
            point_at_zero,
            point_at_one,
            ],
        [
            estimated_intercept + estimated_x_coefficient*point_at_zero,
            estimated_intercept + estimated_x_coefficient*point_at_one,
            ],
        mark = "none",
        style = "dashed, fill=blue",
        )
    axisobject = PGFPlots.Axis(
        [
            score_versus_fraction_linearplotobject,
            perfectline_linearplotobject,
            bestfitline_linearplotobject,
            ],
        xlabel = LaTeXStrings.LaTeXString("Probability of positive class"),
        ylabel = LaTeXStrings.LaTeXString("Fraction of positive class"),
        )
    tikzpicture = PGFPlots.plot(axisobject)
    return tikzpicture
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
        multiply_by::Real = 1.0,
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
        multiply_by::Real = 1.0,
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
            multiply_by = multiply_by,
            )
        r2_score_value = r2_score(scores, fractions)
        estimated_intercept, estimated_x_coefficient =
            ordinary_least_squares_regression(
                Float64.(scores), # X
                Float64.(fractions); # Y
                intercept = true,
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

##### End of file
