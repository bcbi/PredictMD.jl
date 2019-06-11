import MLBase
import StatsBase

"""
"""
function getallrocnums(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real};
        additionalthreshold::Real = 0.5,
        )
    allthresholds = get_binary_thresholds(
        yscore;
        additionalthreshold = additionalthreshold,
        )
    allrocnums = MLBase.roc(
        ytrue,
        yscore,
        allthresholds,
        )
    return allrocnums, allthresholds
end

"""
"""
accuracy(x::MLBase.ROCNums) = (x.tp + x.tn)/(x.p + x.n)

"""
"""
true_positive_rate(x::MLBase.ROCNums) = (x.tp)/(x.p)

"""
"""
true_negative_rate(x::MLBase.ROCNums) = (x.tn)/(x.n)

"""
"""
false_positive_rate(x::MLBase.ROCNums) = (x.fp)/(x.n)

"""
"""
false_negative_rate(x::MLBase.ROCNums) = (x.fn)/(x.p)

"""
"""
function positive_predictive_value(x::MLBase.ROCNums)
    if (x.tp == 0) && (x.tp + x.fp == 0)
        result = 1
    elseif (x.tp != 0) && (x.tp + x.fp == 0)
        error("x.tp != 0) && (x.tp + x.fp == 0)")
    else
        result = (x.tp) / (x.tp + x.fp)
    end
    return result
end

"""
"""
function negative_predictive_value(x::MLBase.ROCNums)
    if (x.tn == 0) && (x.tn + x.fn ==0)
        result = 1
    elseif (x.tn != 0) && (x.tn + x.fn == 0)
        error("(x.tn != 0) && (x.tn + x.fn == 0)")
    else
        result = (x.tn) / (x.tn + x.fn)
    end
    return result
end

"""
"""
sensitivity(x::MLBase.ROCNums) = true_positive_rate(x)

"""
"""
specificity(x::MLBase.ROCNums) = true_negative_rate(x)

"""
"""
precision(x::MLBase.ROCNums) = positive_predictive_value(x)

"""
"""
recall(x::MLBase.ROCNums) = true_positive_rate(x)

"""
"""
function fbetascore(
        x::MLBase.ROCNums,
        beta::Real,
        )
    p = precision(x)
    r = recall(x)
    result = ( 1 + beta^2 ) * ( p*r ) / ( ((beta^2) * p) + r )
    return result
end

"""
"""
f1score(x::MLBase.ROCNums) = fbetascore(x, 1)

