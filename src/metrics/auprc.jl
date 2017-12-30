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
    x = allrecalls
    y = allprecisions
    areaunderprcurve = trapz(x, y)
    return areaunderprcurve
end
