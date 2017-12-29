import MLBase
import StatsBase

function getallrocnums(
        ytrue::T1,
        yscore::T2;
        additionalthreshold::T3 = 0.5,
        ) where
        T1 <: StatsBase.IntegerVector where
        T2 <: StatsBase.RealVector where
        T3 <: Real
    allthresholds = getbinarythresholds(
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

function accuracy(x::T) where T <: MLBase.ROCNums
    result = (x.tp + x.tn)/(x.p + x.n)
    return result
end

function tpr(x::T) where T <: MLBase.ROCNums
    result = (x.tp)/(x.p)
    return result
end

function tnr(x::T) where T <: MLBase.ROCNums
    result = (x.tn)/(x.n)
    return result
end

function fpr(x::T) where T <: MLBase.ROCNums
    result = (x.fp)/(x.n)
    return result
end

function fnr(x::T) where T <: MLBase.ROCNums
    result = (x.fn)/(x.p)
    return result
end

function ppv(x::T) where T <: MLBase.ROCNums
    if (x.tp == 0) && (x.tp + x.fp == 0)
        result = 1
    elseif (x.tp !== 0) && (x.tp + x.fp == 0)
        error("x.tp !== 0) && (x.tp + x.fp == 0)")
    else
        result = (x.tp) / (x.tp + x.fp)
    end
    return result
end

function npv(x::T) where T <: MLBase.ROCNums
    if (x.tn == 0) && (x.tn + x.fn ==0)
        result = 1
    elseif (x.tn !== 0) && (x.tn + x.fn == 0)
        error("(x.tn !== 0) && (x.tn + x.fn == 0)")
    else
        result = (x.tn) / (x.tn + x.fn)
    end
    return result
end

function sensitivity(x::T) where T <: MLBase.ROCNums
    return tpr(x)
end

function specificity(x::T) where T <: MLBase.ROCNums
    return tnr(x)
end

function precision(x::T) where T <: MLBase.ROCNums
    return ppv(x)
end

function recall(x::T) where T <: MLBase.ROCNums
    return tpr(x)
end

function fbetascore(
        x::T1,
        beta::T2,
        ) where
        T1 <: MLBase.ROCNums where
        T2 <: Real
    p = precision(x)
    r = recall(x)
    result = ( 1 + beta^2 ) * ( p*r ) / ( ((beta^2) * p) + r )
    return result
end

function f1score(
        x::T1,
        ) where
        T1 <: MLBase.ROCNums
    return fbetascore(x, 1)
end
