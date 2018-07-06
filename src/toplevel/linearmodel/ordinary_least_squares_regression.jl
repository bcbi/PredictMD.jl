##### Beginning of file

import DataFrames
import GLM
import StatsModels

"""
    ordinary_least_squares_regression(x, y; intercept = true)

Find the best fit line to the set of 2-dimensional points (x, y) using the
ordinary least squares method.

If intercept is true (default), fit a line of the form y = a + b*x (where a
and b are real numbers) and return the tuple (a, b)

If intercept is false, fit a line of the form y = b*x (where b is a real
number) and return the tuple (0, b)
"""
function ordinary_least_squares_regression(
        x::AbstractVector{T},
        y::AbstractVector{T};
        intercept::Bool = true,
        ) where T <: Real
    if length(x) != length(y)
        error("length(x) != length(y)")
    end
    if length(x) == 0
        error("length(x) == 0")
    end
    data = DataFrames.DataFrame(
        x = x,
        y = y,
        )
    if intercept
        estimated_intercept, estimated_x_coefficient = try
            ols_regression = GLM.lm(StatsModels.@formula(y ~ 1 + x),data,)
            coefficients = ols_regression.model.pp.beta0
            # estimated intercept: coefficients[1]
            # estimated x coefficient: coefficients[2]
            coefficients[1], coefficients[2]
        catch e
            info(string("DEBUG: Ignored error: ", e))
            0, 0
        end
    else
        estimated_intercept, estimated_x_coefficient = try
            ols_regression = GLM.lm(StatsModels.@formula(y ~ 0 + x),data,)
            coefficients = ols_regression.model.pp.beta0
            # intercept: 0
            # estimated x coefficient: coefficients[1]
            0, coefficients[1]
        catch e
            info(string("DEBUG: Ignored error: ", e))
            0, 0
        end
    end
    return estimated_intercept, estimated_x_coefficient
end

##### End of file
