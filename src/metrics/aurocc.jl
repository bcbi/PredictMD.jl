import AUC
import MLBase
import ROCAnalysis
import StatsBase

function _aluthge_aurocc(
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
    Aluthge_aurocc = trapz(x, y)
    return Aluthge_aurocc
end

function _rocanalysis_aurocc(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    targetlevel = 1
    nontargetlevel = 0
    targetscores = yscore[ytrue .== targetlevel]
    nontargetscores = yscore[ytrue .== nontargetlevel]
    r = ROCAnalysis.roc(targetscores, nontargetscores)
    complementof_ROCAnalysis_aurocc = ROCAnalysis.auc(r)
    ROCAnalysis_aurocc = 1 - complementof_ROCAnalysis_aurocc
    return ROCAnalysis_aurocc
end

function aurocc(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    Aluthge_aurocc = _aluthge_aurocc(
        ytrue,
        yscore,
        )
    ROCAnalysis_aurocc = _rocanalysis_aurocc(
        ytrue,
        yscore,
        )
    if !( isapprox(Aluthge_aurocc, ROCAnalysis_aurocc; atol=0.00000001) )
        msg = "Aluthge_aurocc is not approx equal to ROCAnalysis_aurocc.\n" *
            "Aluthge_aurocc = $(Aluthge_aurocc)\n" *
            "ROCAnalysis_aurocc = $(ROCAnalysis_aurocc)\n" *
            "We will use the Aluthge_aurocc value."
        error(msg)
    end
    return Aluthge_aurocc
end
