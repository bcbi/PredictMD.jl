import MLBase
import ROCAnalysis
import StatsBase

function _aurocc(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
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
    aurocc_result = trapz(x, y)
    return aurocc_result
end

function _aurocc_verify(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    targetlevel = 1
    nontargetlevel = 0
    targetscores = yscore[ytrue .== targetlevel]
    nontargetscores = yscore[ytrue .== nontargetlevel]
    r = ROCAnalysis.roc(targetscores, nontargetscores)
    complement_of_aurocc = ROCAnalysis.auc(r)
    aurocc_result = 1 - complement_of_aurocc
    return aurocc_result
end

function aurocc(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    aurocc_value = _aurocc(
        ytrue,
        yscore,
        )
    aurocc_verify_value = _aurocc_verify(
        ytrue,
        yscore,
        )
    if !( isapprox(aurocc_value, aurocc_verify_value; atol=0.00000001) )
        error("Was not able to accurately compute the AUROCC.")
    end
    return aurocc_value
end
