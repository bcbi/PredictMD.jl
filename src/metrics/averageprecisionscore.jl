import MLBase
import StatsBase

function average_precision_score(
        allprecisions::StatsBase.RealVector,
        allrecalls::StatsBase.RealVector,
        allthresholds::StatsBase.RealVector,
        )
    if length(allprecisions) != length(allrecalls)
        error("length(allprecisions) != length(allrecalls)")
    end
    if length(allprecisions) < 2
        error("length(allprecisions) < 2")
    end
    #
    permutation = sortperm(allthresholds; rev = true)
    allprecisions = allprecisions[permutation]
    allrecalls = allrecalls[permutation]
    #
    N = length(allprecisions)
    result = 0
    for k = 2:N
        result += (allrecalls[k] - allrecalls[k-1]) * allprecisions[k]
    end
    return result
end

function averageprecisionscore(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    allprecisions, allrecalls, allthresholds = prcurve(
        ytrue,
        yscore,
        )
    x = allrecalls
    y = allprecisions
    avgprecision = average_precision_score(
        allprecisions,
        allrecalls,
        allthresholds,
        )
    return avgprecision
end
