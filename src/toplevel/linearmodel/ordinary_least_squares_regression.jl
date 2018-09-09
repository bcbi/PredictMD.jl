##### Beginning of file

import Statistics

"""
    simple_linear_regression(x, y)

Simple linear regression: find the best fit line to the set of
2-dimensional points (x, y) using the ordinary least squares method.

simple_linear_regression(x, y) fits a line of the form y = a + b*x
(where a and b are real numbers) and returns the tuple (a, b).

"""
function simple_linear_regression(
        x::AbstractVector,
        y::AbstractVector,
        )::Tuple
    if length(x) != length(y)
        error("length(x) != length(y)")
    end
    if length(x) == 0
        error("length(x) == 0")
    end
    x_bar = Statistics.mean(x)
    y_bar = Statistics.mean(y)
    var_x = Statistics.var(x)
    cov_x_y = Statistics.cov(x,y)
    beta_hat = cov_x_y/var_x
    if isfinite(beta_hat)
        alpha_hat = y_bar - beta_hat*x_bar
        intercept = alpha_hat
        coefficient = beta_hat
    else
        @warn(
            string(
                "The best-fit line does not have a finite slope. ",
                "I will ignore this result, and instead I will return ",
                "intercept = 0 and coefficient = 0.",
                )
            )
        intercept = 0
        coefficient = 0
    end
    return intercept, coefficient
end

##### End of file
