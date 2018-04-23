import MLBase
import StatsBase

function getallrocnums(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector;
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

function accuracy(x::MLBase.ROCNums)
    result = (x.tp + x.tn)/(x.p + x.n)
    return result
end

function tpr(x::MLBase.ROCNums)
    result = (x.tp)/(x.p)
    return result
end

function tnr(x::MLBase.ROCNums)
    result = (x.tn)/(x.n)
    return result
end

function fpr(x::MLBase.ROCNums)
    result = (x.fp)/(x.n)
    return result
end

function fnr(x::MLBase.ROCNums)
    result = (x.fn)/(x.p)
    return result
end

function ppv(x::MLBase.ROCNums)
    if (x.tp == 0) && (x.tp + x.fp == 0)
        result = 1
    elseif (x.tp != 0) && (x.tp + x.fp == 0)
        error("x.tp != 0) && (x.tp + x.fp == 0)")
    else
        result = (x.tp) / (x.tp + x.fp)
    end
    return result
end

function npv(x::MLBase.ROCNums)
    if (x.tn == 0) && (x.tn + x.fn ==0)
        result = 1
    elseif (x.tn != 0) && (x.tn + x.fn == 0)
        error("(x.tn != 0) && (x.tn + x.fn == 0)")
    else
        result = (x.tn) / (x.tn + x.fn)
    end
    return result
end

function sensitivity(x::MLBase.ROCNums)
    return tpr(x)
end

function specificity(x::MLBase.ROCNums)
    return tnr(x)
end

function precision(x::MLBase.ROCNums)
    return ppv(x)
end

function recall(x::MLBase.ROCNums)
    return tpr(x)
end

function fbetascore(
        x::MLBase.ROCNums,
        beta::Real,
        )
    p = precision(x)
    r = recall(x)
    result = ( 1 + beta^2 ) * ( p*r ) / ( ((beta^2) * p) + r )
    return result
end

function f1score(
        x::MLBase.ROCNums,
        )
    return fbetascore(x, 1)
end
