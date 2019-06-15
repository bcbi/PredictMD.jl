import MLBase
import StatsBase

"""
"""
function avg_precision(
        allprecisions::AbstractVector{<:Real},
        allrecalls::AbstractVector{<:Real},
        allthresholds::AbstractVector{<:Real},
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

"""
"""
function averageprecisionscore(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
        )
    allprecisions, allrecalls, allthresholds = prcurve(
        ytrue,
        yscore,
        )
    x = allrecalls
    y = allprecisions
    avgprecision = avg_precision(
        allprecisions,
        allrecalls,
        allthresholds,
        )
    return avgprecision
end

