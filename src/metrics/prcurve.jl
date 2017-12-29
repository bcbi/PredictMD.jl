import MLBase
import StatsBase

function prcurve(
        ytrue::T1,
        yscore::T2
        ) where
        T1 <: StatsBase.IntegerVector where
        T2 <: StatsBase.RealVector
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
