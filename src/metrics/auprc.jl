import MLBase
import StatsBase

function auprc(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
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
