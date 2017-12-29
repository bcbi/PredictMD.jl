import DataFrames
import StatsBase

function shufflerows!(
        dataframe::DataFrames.AbstractDataFrame,
        )
    result = shufflerows!(Base.GLOBAL_RNG, dataframe)
    return result
end

function shufflerows!(
        rng::AbstractRNG,
        dataframe::DataFrames.AbstractDataFrame,
        )
    numrows = size(dataframe,1)
    allrows = convert(Array,1:numrows)
    rowpermutation = shuffle!(rng, allrows)
    dataframe[:, :] = dataframe[rowpermutation, :]
    return dataframe
end
