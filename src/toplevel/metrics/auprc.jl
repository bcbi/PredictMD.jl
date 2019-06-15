import MLBase
import NumericalIntegration
import StatsBase

"""
"""
function auprc(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
        )
    allprecisions, allrecalls, allthresholds = prcurve(
        ytrue,
        yscore,
        )
    #
    permutation = sortperm(allthresholds; rev=true)
    allprecisions = allprecisions[permutation]
    allrecalls = allrecalls[permutation]
    allthresholds = allthresholds[permutation]
    #
    x = allrecalls
    y = allprecisions
    areaunderprcurve = trapz(x, y)
    return areaunderprcurve
end

