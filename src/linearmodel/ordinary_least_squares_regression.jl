import DataFrames
import GLM
import StatsModels

function ordinary_least_squares_regression(
        X::AbstractVector{T},
        Y::AbstractVector{T};
        intercept::Bool = true,
        ) where T <: Real
    if length(X) != length(Y)
        error("length(X) != length(Y)")
    end
    if length(X) == 0
        error("length(X) == 0")
    end
    data = DataFrames.DataFrame(
        X = X,
        Y = Y,
        )
    if intercept
        estimated_intercept, estimated_x_coefficient = try
            ols_regression = GLM.lm(StatsModels.@formula(Y ~ 1 + X),data,)
            coefficients = ols_regression.model.pp.beta0
            # estimated intercept: coefficients[1]
            # estimated x coefficient: coefficients[2]
            coefficients[1], coefficients[2]
        catch e
            info(string("DEBUG Ignored error: ", e))
            0, 0
        end
    else
        estimated_intercept, estimated_x_coefficient = try
            ols_regression = GLM.lm(StatsModels.@formula(Y ~ 0 + X),data,)
            coefficients = ols_regression.model.pp.beta0
            # intercept: 0
            # estimated x coefficient: coefficients[1]
            0, coefficients[1]
        catch e
            info(string("DEBUG Ignored error: ", e))
            0, 0
        end
    end
    return estimated_intercept, estimated_x_coefficient
end
