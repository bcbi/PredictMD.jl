"""
"""
function simple_moving_average(
        x::AbstractVector,
        window::Integer,
        )
    if window < 0
        error("window must be >=0")
    end
    n = length(x)
    result = zeros(x)
    for i = 1:n
        lower_bound = max(1, i - window)
        upper_bound = min(n, i + window)
        result[i] = mean(x[lower_bound:upper_bound])
    end
    return result
end
