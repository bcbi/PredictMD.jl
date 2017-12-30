import AUC
import MLBase
import StatsBase

function roccurve(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    allrocnums, allthresholds = getallrocnums(
        ytrue,
        yscore,
        )
    result = roccurve(
        allrocnums,
        allthresholds,
        )
    return result
end

function roccurve(
        allrocnums::VectorOfMLBaseROCNums,
        allthresholds::StatsBase.RealVector,
        )
    allfpr = [fpr(x) for x in allrocnums]
    alltpr = [tpr(x) for x in allrocnums]
    #
    @assert(typeof(allfpr) <: AbstractVector)
    @assert(typeof(alltpr) <: AbstractVector)
    @assert(typeof(allthresholds) <: AbstractVector)
    #
    permutation = sortperm(allthresholds; rev = false)
    allfpr = allfpr[permutation]
    alltpr = alltpr[permutation]
    allthresholds = allthresholds[permutation]
    return allfpr, alltpr, allthresholds
end
