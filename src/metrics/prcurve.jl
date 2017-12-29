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
    allprecisions = [precision(x) for x in allrocnums]
    allrecalls = [recall(x) for x in allrocnums]
    @assert(typeof(allprecisions) <: AbstractVector)
    @assert(typeof(allrecalls) <: AbstractVector)
    permutation = sortperm(allrecalls)
    allprecisions = allprecisions[permutation]
    allrecalls = allrecalls[permutation]
    return allprecisions, allrecalls, allthresholds
end
