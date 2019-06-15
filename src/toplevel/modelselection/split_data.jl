import DataFrames
import Random
import StatsBase

"""
"""
function split_data(
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        split::Real,
        )
    result = split_data(
        Random.GLOBAL_RNG,
        features_df,
        labels_df,
        split,
        )
    return result
end

"""
"""
function split_data(
        rng::AbstractRNG,
        features_df::DataFrames.AbstractDataFrame,
        labels_df::DataFrames.AbstractDataFrame,
        split::Real,
        )
    #
    if !(0 < split < 1)
        error("split must be >0 and <1")
    end
    if size(features_df, 1) != size(labels_df, 1)
        error("features_df and labels_df do not have the same number of rows")
    end
    #
    num_rows = size(features_df, 1)
    num_partition_1 = round(Int, split * num_rows)
    num_partition_2 = num_rows - num_partition_1
    #
    allrows = convert(Array, 1:num_rows)
    partition_1_rows = StatsBase.sample(
        rng,
        allrows,
        num_partition_1;
        replace = false,
        )
    partition_2_rows = setdiff(allrows, partition_1_rows)
    #
    partition_1_features_df = features_df[partition_1_rows, :]
    partition_2_features_df = features_df[partition_2_rows, :]
    #
    partition_1_labels_df = labels_df[partition_1_rows, :]
    partition_2_labels_df = labels_df[partition_2_rows, :]
    #
    return partition_1_features_df,
        partition_1_labels_df,
        partition_2_features_df,
        partition_2_labels_df
end

