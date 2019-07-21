import Statistics

"""
    simple_linear_regression(x::AbstractVector, y::AbstractVector)

Simple linear regression - given a set of two-dimensional points (x, y), use
the ordinary least squares method to find the best fit line of the form
y = a + b*x (where a and b are real numbers) and return the tuple (a, b).
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

    @assert(isfinite(x_bar))
    @assert(isfinite(y_bar))
    @assert(isfinite(var_x))
    @assert(isfinite(cov_x_y))

    coefficient = cov_x_y/var_x

    if isfinite(coefficient)
        intercept = y_bar - coefficient*x_bar
        @debug(
            string("Found best fit line: "),
            intercept,
            coefficient,
            )
    else
        @warn(
            string(
                "The best fit line does not have a finite slope. ",
                "I will ignore this result and will instead return ",
                "intercept = 0 and coefficient = 0",
                )
            )
        intercept = 0
        coefficient = 0
    end

    return intercept, coefficient
end
