import DataFrames
import StatsBase

function shufflerows!(
        dataframe::T2,
        ) where
        T2 <: DataFrames.AbstractDataFrame
    result = shufflerows!(Base.GLOBAL_RNG, dataframe)
    return result
end

function shufflerows!(
        rng::T1,
        dataframe::T2,
        ) where
        T1 <: AbstractRNG where
        T2 <: DataFrames.AbstractDataFrame
    numrows = size(dataframe,1)
    allrows = convert(Array,1:numrows)
    rowpermutation = shuffle!(rng, allrows)
    dataframe[:, :] = dataframe[rowpermutation, :]
    return dataframe
end
