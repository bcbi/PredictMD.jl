##### Beginning of file

import Statistics
import StatsBase

"""
    r2_score(ytrue, ypred)

Computes coefficient of determination. Higher values are better. Best value
is 1.
"""
function r2_score(
        ytrue::AbstractVector{<:Real},
        ypred::AbstractVector{<:Real},
        )
    if length(ytrue) != length(ypred)
        error("length(ytrue) != length(ypred)")
    end
    if length(ytrue) == 0
        error("length(ytrue) == 0")
    end
    # ybar = mean of the true y values
    ybar = Statistics.mean(ytrue)
    # SStot = total sum of squares
    SStot = sum( (ytrue .- ybar).^2 )
    # SSres = sum of squares of residuals
    residuals = ytrue .- ypred
    SSres = sum( residuals.^2 )
    R2 = 1 - SSres/SStot
    return R2
end

##### End of file
