import Statistics

"""
"""
function simple_moving_average(
        x::AbstractVector,
        window::Integer,
        ) where T
    if window < 0
        error("window must be >=0")
    end
    n = length(x)
    result = similar(x)
    for i = 1:n
        lower_bound = max(1, i - window)
        upper_bound = min(n, i + window)
        result[i] = Statistics.mean(x[lower_bound:upper_bound])
    end
    return result
end

