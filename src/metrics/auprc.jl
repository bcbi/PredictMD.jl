import MLBase
import StatsBase

function auprc(
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
    areaunderprcurve = trapz(x, y)
    return areaunderprcurve
end
