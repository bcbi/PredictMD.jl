##### Beginning of file

import MLBase
import StatsBase

"""
"""
function roccurve(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
        )
    allrocnums, allthresholds = getallrocnums(
        ytrue,
        yscore,
        )
    result = roccurve(
        allrocnums,
        allthresholds,
        )
    return result
end

"""
"""
function roccurve(
        allrocnums::AbstractVector{<:MLBase.ROCNums},
        allthresholds::AbstractVector{<:Real},
        )
    allfpr = [false_positive_rate(x) for x in allrocnums]
    alltpr = [true_positive_rate(x) for x in allrocnums]
    #
    permutation = sortperm(allthresholds; rev = false)
    allfpr = allfpr[permutation]
    alltpr = alltpr[permutation]
    allthresholds = allthresholds[permutation]
    return allfpr, alltpr, allthresholds
end

##### End of file
