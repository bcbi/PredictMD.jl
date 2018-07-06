##### Beginning of file

import MLBase
import ROCAnalysis
import StatsBase

function _aurocc_trapz(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
        )
    allfpr, alltpr, allthresholds = roccurve(
        ytrue,
        yscore,
        )
    #
    permutation = sortperm(allthresholds; rev=true)
    allfpr = allfpr[permutation]
    alltpr = alltpr[permutation]
    allthresholds = allthresholds[permutation]
    #
    x = allfpr
    y = alltpr
    aurocc_trapz_result = trapz(x, y)
    return aurocc_trapz_result
end

function _aurocc_verify(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
        )
    targetlevel = 1
    nontargetlevel = 0
    targetscores = yscore[ytrue .== targetlevel]
    nontargetscores = yscore[ytrue .== nontargetlevel]
    r = ROCAnalysis.roc(targetscores, nontargetscores)
    complement_of_aurocc = ROCAnalysis.auc(r)
    aurocc_verify_result = 1 - complement_of_aurocc
    return aurocc_verify_result
end

"""
"""
function aurocc(
        ytrue::AbstractVector{<:Integer},
        yscore::AbstractVector{<:Real},
        )
    aurocc_trapz_value = _aurocc_trapz(
        ytrue,
        yscore,
        )
    aurocc_verify_value = _aurocc_verify(
        ytrue,
        yscore,
        )
    if !( isapprox(aurocc_trapz_value, aurocc_verify_value; atol=0.00000001) )
        error("Was not able to accurately compute the AUROCC.")
    end
    return aurocc_trapz_value
end

##### End of file
