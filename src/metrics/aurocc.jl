import AUC
import MLBase
import NumericalIntegration
import StatsBase

function _ASB_aurocc(
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
    areaunderroccurve = trapz(x, y)
    return areaunderroccurve
end

function aurocc(
        ytrue::StatsBase.IntegerVector,
        yscore::StatsBase.RealVector,
        )
    Aluthge_aurocc = _ASB_aurocc(
        ytrue,
        yscore,
        )
    BCBI_aurocc = AUC.auc(
        ytrue,
        yscore,
        )
    if !( isapprox(Aluthge_aurocc, BCBI_aurocc; atol=0.01) )
        msg = "Aluthge_aurocc is not approx equal to BCBI_aurocc.\n" *
            "Aluthge_aurocc = $(Aluthge_aurocc)\n" *
            "BCBI_aurocc = $(BCBI_aurocc)\n" *
            "We will use the BCBI_aurocc value."
        warn(msg)
    end
    return BCBI_aurocc
end
