import DataFrames
import GLM
import StatsModels

function ordinary_least_squares_regression(
        ;
        X::AbstractVector{T} where T <: Real = [],
        Y::AbstractVector{T} where T <: Real = [],
        intercept::Bool = true,
        ignore_errors::Bool = true,
        warn_on_error::Bool = false,
        )
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
            if ignore_errors && warn_on_error
                warn(string("Ignored error: ", e))
                # intercept: 0
                # x coefficient: 0
                0, 0
            elseif ignore_errors && !warn_on_error
                # intercept: 0
                # x coefficient: 0
                0, 0
            else
                rethrow(e)
            end
        end
    else
        estimated_intercept, estimated_x_coefficient = try
            ols_regression = GLM.lm(StatsModels.@formula(Y ~ 0 + X),data,)
            coefficients = ols_regression.model.pp.beta0
            # intercept: 0
            # estimated x coefficient: coefficients[1]
            0, coefficients[1]
        catch e
            if ignore_errors && warn_on_error
                warn(string("Ignored error: ", e))
                # intercept: 0
                # x coefficient: 0
                0, 0
            elseif ignore_errors && !warn_on_error
                # intercept: 0
                # x coefficient: 0
                0, 0
            else
                rethrow(e)
            end
        end
    end
    return estimated_intercept, estimated_x_coefficient
end
