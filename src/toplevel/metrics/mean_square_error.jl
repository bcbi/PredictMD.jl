import Statistics

"""
    mean_square_error(ytrue, ypred)
"""
function mean_square_error(
        ytrue::AbstractVector{<:Real},
        ypred::AbstractVector{<:Real},
        )
    result = Statistics.mean(abs2, ytrue .- ypred)
    return result
end

"""
    root_mean_square_error(ytrue, ypred)
"""
root_mean_square_error(ytrue,ypred) = sqrt(mean_square_error(ytrue,ypred))

# convenience aliases for mean squared error:
mean_squared_error(ytrue,ypred) = mean_square_error(ytrue,ypred)
mean_square_deviation(ytrue,ypred) = mean_square_error(ytrue,ypred)
mean_squared_deviation(ytrue,ypred) = mean_square_error(ytrue,ypred)

# convenience aliases for root mean squared error:
root_mean_squared_error(ytrue,ypred) = root_mean_square_error(ytrue,ypred)
root_mean_square_deviation(ytrue,ypred) = root_mean_square_error(ytrue,ypred)
root_mean_squared_deviation(ytrue,ypred) = root_mean_square_error(ytrue,ypred)

