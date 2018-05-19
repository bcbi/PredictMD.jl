import DataFrames

function risk_score_cutoff_values(
        estimator::Fittable,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        singlelabelname::Symbol,
        positiveclass::AbstractString;
        multiply_by::Real = 1.0,
        average_function = Base.mean,
        )
    #
    ytrue = Int.(
        singlelabelbinaryytrue(
            labelsdf[singlelabelname],
            positiveclass,
            )
        )
    #
    predictedprobabilitiesalllabels = predict_proba(estimator, featuresdf)
    yscore = Cfloat.(
        singlelabelbinaryyscore(
            predictedprobabilitiesalllabels[singlelabelname],
            positiveclass,
            )
        )
    #
    cutoffs, risk_group_prevalences = risk_score_cutoff_values(
            ytrue,
            yscore;
            multiply_by = multiply_by,
            average_function = average_function,
            )
    return cutoffs, risk_group_prevalences
end

function risk_score_cutoff_values(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:AbstractFloat};
        multiply_by::Real = 1.0,
        average_function = Base.mean,
        )
    true_negative_rows = find(
        ytrue .== 0
        )
    true_positive_rows = find(
        ytrue .== 1
        )
    #
    average_score_true_negatives = average_function(
        yscore[true_negative_rows]
        )
    average_score_true_positives = average_function(
        yscore[true_positive_rows]
        )
    #
    lower_cutoff = multiply_by * average_score_true_negatives
    higher_cutoff = multiply_by * average_score_true_positives
    #
    cutoffs = (lower_cutoff, higher_cutoff,)
    #
    low_risk_group_rows = find(
        yscore .<= average_score_true_negatives
        )
    medium_risk_group_rows = find(
        average_score_true_negatives .<= yscore .<= average_score_true_positives
        )
    high_risk_group_rows = find(
        average_score_true_positives .<= yscore
        )
    #
    risk_group_prevalences = DataFrames.DataFrame()
    risk_group_prevalences[:Risk_group] = [
        "Low risk",
        "Medium risk",
        "High risk",
        ]
    risk_group_prevalences[:User_supplied_average_function] = [
        average_function( ytrue[low_risk_group_rows] ),
        average_function( ytrue[medium_risk_group_rows] ),
        average_function( ytrue[high_risk_group_rows] ),
        ]
    risk_group_prevalences[:Arithmetic_mean] = [
        Base.mean( ytrue[low_risk_group_rows] ),
        Base.mean( ytrue[medium_risk_group_rows] ),
        Base.mean( ytrue[high_risk_group_rows] ),
        ]
    risk_group_prevalences[:Median] = [
        Base.median( ytrue[low_risk_group_rows] ),
        Base.median( ytrue[medium_risk_group_rows] ),
        Base.median( ytrue[high_risk_group_rows] ),
        ]
    if average_function == Base.mean || average_function == Base.median
        delete!(risk_group_prevalences, :User_supplied_average_function)
    end
    return cutoffs, risk_group_prevalences
end
