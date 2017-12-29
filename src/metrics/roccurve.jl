import AUC
import MLBase
import StatsBase

function roccurve(
        ytrue::T1,
        yscore::T2
        ) where
        T1 <: StatsBase.IntegerVector where
        T2 <: StatsBase.RealVector
    allrocnums, allthresholds = getallrocnums(
        ytrue,
        yscore,
        )
    allfpr = [fpr(x) for x in allrocnums]
    alltpr = [tpr(x) for x in allrocnums]
    @assert(typeof(allfpr) <: AbstractVector)
    @assert(typeof(alltpr) <: AbstractVector)
    permutation = sortperm(allfpr)
    allfpr = allfpr[permutation]
    alltpr = alltpr[permutation]
    return allfpr, alltpr, allthresholds
end
