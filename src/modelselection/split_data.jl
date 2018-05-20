import DataFrames
import StatsBase

function split_data(
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        split::Real,
        )
    result = split_data(
        Base.GLOBAL_RNG,
        featuresdf,
        labelsdf,
        split,
        )
    return result
end

function split_data(
        rng::AbstractRNG,
        featuresdf::DataFrames.AbstractDataFrame,
        labelsdf::DataFrames.AbstractDataFrame,
        split::Real,
        )
    if !(0 < split < 1)
        error("split must be >0 and <1")
    end
    if size(featuresdf, 1) != size(labelsdf, 1)
        error("featuresdf and labelsdf do not have the same number of rows")
    end
    num_rows = size(featuresdf, 1)
    num_partition_1 = round(Int, split * num_rows)
    num_partition_2 = num_rows - num_partition_1
    allrows = convert(Array, 1:num_rows)
    partition_1_rows = StatsBase.sample(
        rng,
        allrows,
        num_partition_1;
        replace = false,
        )
    partition_2_rows = setdiff(allrows, partition_1_rows)
    @assert(typeof(partition_1_rows) <: AbstractVector)
    @assert(typeof(partition_2_rows) <: AbstractVector)
    @assert(length(partition_1_rows) == num_partition_1)
    @assert(length(partition_2_rows) == num_partition_2)
    @assert(
        all(
            allrows .== sort(vcat(partition_1_rows, partition_2_rows))
            )
        )
    partition_1_features_df = featuresdf[partition_1_rows, :]
    partition_2_features_df = featuresdf[partition_2_rows, :]
    partition_1_labels_df = labelsdf[partition_1_rows, :]
    partition_2_labels_df = labelsdf[partition_2_rows, :]
    return partition_1_features_df,
        partition_2_features_df,
        partition_1_labels_df,
        partition_2_labels_df
end
