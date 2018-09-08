##### Beginning of file

import DataFrames
import Random
import StatsBase

"""
"""
function shuffle_rows!(
        dataframe::DataFrames.AbstractDataFrame,
        )
    result = shuffle_rows!(Random.GLOBAL_RNG, dataframe)
    return result
end

"""
"""
function shuffle_rows!(
        rng::AbstractRNG,
        dataframe::DataFrames.AbstractDataFrame,
        )
    numrows = size(dataframe,1)
    allrows = convert(Array,1:numrows)
    rowpermutation = shuffle!(rng, allrows)
    dataframe[:, :] = dataframe[rowpermutation, :]
    return dataframe
end

##### End of file
