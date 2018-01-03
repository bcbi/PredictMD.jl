import MLBase
import StatsBase

function prcurve(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    allrocnums, allthresholds = getallrocnums(
        ytrue,
        yscore,
        )
    result = prcurve(
        allrocnums,
        allthresholds,
        )
    return result
end

function prcurve(
    allrocnums::VectorOfMLBaseROCNums,
    allthresholds::StatsBase.RealVector,
    )
    allprecisions = [precision(x) for x in allrocnums]
    allrecalls = [recall(x) for x in allrocnums]
    #
    @assert(typeof(allprecisions) <: AbstractVector)
    @assert(typeof(allrecalls) <: AbstractVector)
    @assert(typeof(allthresholds) <: AbstractVector)
    #
    permutation = sortperm(allthresholds; rev = false)
    allprecisions = allprecisions[permutation]
    allrecalls = allrecalls[permutation]
    allthresholds = allthresholds[permutation]
    return allprecisions, allrecalls, allthresholds
end
