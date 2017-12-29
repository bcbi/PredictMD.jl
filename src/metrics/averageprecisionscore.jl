import MLBase
import StatsBase

function _calculateaverageprecisionfromprecisionrecallcurve(
        allprecisions::T1,
        allrecalls::T2,
        ) where
        T1 <: StatsBase.RealVector where
        T2 <: StatsBase.RealVector
    if length(allprecisions) != length(allrecalls)
        error("length(allprecisions) != length(allrecalls)")
    end
    if length(allprecisions) < 2
        error("length(allprecisions) < 2")
    end
    permutation = sortperm(allprecisions; rev = true)
    allprecisions = allprecisions[permutation]
    allrecalls = allrecalls[permutation]
    N = length(allprecisions)
    result = 0
    for k = 2:N
        result += (allrecalls[k] - allrecalls[k-1]) * allprecisions[k]
    end
    return result
end

function averageprecisionscore(
        ytrue::T1,
        yscore::T2
        ) where
        T1 <: StatsBase.IntegerVector where
        T2 <: StatsBase.RealVector
    allprecisions, allrecalls, allthresholds = prcurve(
        ytrue,
        yscore,
        )
    x = allrecalls
    y = allprecisions
    avgprecision = _calculateaverageprecisionfromprecisionrecallcurve(
        allprecisions,
        allrecalls,
        )
    return avgprecision
end
