function simplemovingaverage(
        x::AbstractVector,
        window::Integer,
        )
    if window < 0
        error("window must be >=0")
    end
    n = length(x)
    result = zeros(x)
    for i = 1:n
        lowerbound = max(1, i - window)
        upperbound = min(n, i + window)
        result[i] = mean(x[lowerbound:upperbound])
    end
    return result
end
