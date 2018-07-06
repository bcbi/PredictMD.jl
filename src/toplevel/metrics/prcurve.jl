##### Beginning of file

import MLBase
import StatsBase

"""
"""
function prcurve(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
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

"""
"""
function prcurve(
    allrocnums::AbstractVector{<:MLBase.ROCNums},
    allthresholds::AbstractVector{<:Real},
    )
    allprecisions = [precision(x) for x in allrocnums]
    allrecalls = [recall(x) for x in allrocnums]
    permutation = sortperm(allthresholds; rev = false)
    allprecisions = allprecisions[permutation]
    allrecalls = allrecalls[permutation]
    allthresholds = allthresholds[permutation]
    return allprecisions, allrecalls, allthresholds
end

##### End of file
