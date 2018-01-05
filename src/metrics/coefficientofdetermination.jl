import StatsBase

function R2coefficientofdetermination(
        ytrue::StatsBase.RealVector,
        ypred::StatsBase.RealVector,
        )
    if length(ytrue) !== length(ypred)
        error("length(ytrue) !== length(ypred)")
    end
    if length(ytrue) == 0
        error("length(ytrue) == 0")
    end
    # ybar = mean of the true y values
    ybar = mean(ytrue)
    # SStot = total sum of squares
    SStot = sum( (ytrue .- ybar).^2 )
    # SSres = sum of squares of residuals
    residuals = ytrue .- ypred
    SSres = sum( residuals.^2 )
    R2 = 1 - SSres/SStot
    return R2
end

function fractionofvarianceunexplained(
        ytrue::StatsBase.RealVector,
        ypred::StatsBase.RealVector,
        )
    R2 = R2coefficientofdetermination(ytrue, ypred)
    FVU = 1 - R2
    return FVU
end
