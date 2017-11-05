using DataFrames
using IterableTables
using StatsBase

struct TabularDataset <: AbstractTabularDataset
    data_frame::T1 where T1 <: AbstractDataFrame
    label_variables::T2 where T2 <: AbstractVector{Symbol}
    feature_variables::T3 where T3 <: AbstractVector{Symbol}
    rows_training::T3 where T3 <: StatsBase.IntegerVector
    rows_validation::T4 where T4 <: StatsBase.IntegerVector
    rows_testing::T5 where T5 <: StatsBase.IntegerVector
end

function TabularDataset(
        data_original,
        label_variables::T2 where T2 <: AbstractVector{Symbol},
        feature_variables::T3 where T3 <: AbstractVector{Symbol};
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        )
    return TabularDataset(
        Base.GLOBAL_RNG,
        data_original,
        label_variables,
        feature_variables;
        training = training,
        validation = validation,
        testing = testing,
        )
end

function TabularDataset(
        rng::AbstractRNG,
        data_original,
        label_variables::T2 where T2 <: AbstractVector{Symbol},
        feature_variables::T3 where T3 <: AbstractVector{Symbol};
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        )

    data_frame = DataFrame(data_original)
    num_rows = size(data_frame, 1)
    permutation = shuffle(rng, 1:num_rows)
    data_frame = data_frame[permutation, :]

    all_column_names = names(data_frame)

    for y = label_variables
        if !(y in all_column_names)
            error("label variable $(y) is not one of the columns")
        end
        if !(eltype(data_frame[:, y]) <: Real)
            warn("element type of label $(y) is not a subtype of Real.")
        end
    end

    for x = feature_variables
        if !(x in all_column_names)
            error("feature variable $(x) is not one of the columns")
        end
    end

    num_rows_training, num_rows_validation, num_rows_testing =
        _calculate_num_rows_partition(num_rows, training, validation, testing)
    rows_training, rows_validation, rows_testing = _partition_rows(
        num_rows_training,
        num_rows_validation,
        num_rows_testing
        )

    return TabularDataset(
        data_frame,
        label_variables,
        feature_variables,
        rows_training,
        rows_validation,
        rows_testing,
        )
end

function _calculate_num_rows_partition(
        num_rows::Integer,
        training::Real,
        validation::Real,
        testing::Real,
        )
    if !(num_rows > 0)
        error("num rows must be > 0")
    end
    if !(training + validation + testing == 1)
        error("training + validation + testing must equal 1.")
    end
    num_rows_testing = round(Int, num_rows * testing)
    num_rows_validation = round(Int, num_rows * validation)
    num_rows_training = num_rows - num_rows_testing - num_rows_validation

    @assert(num_rows_training >= 0)
    @assert(num_rows_validation >= 0)
    @assert(num_rows_testing >= 0)

    @assert(
        num_rows_training + num_rows_validation + num_rows_testing ==
        num_rows
        )
    return num_rows_training, num_rows_validation, num_rows_testing
end

function _partition_rows(
        num_rows_training::Integer,
        num_rows_validation::Integer,
        num_rows_testing::Integer,
        )
    return _partition_rows(
        Base.GLOBAL_RNG,
        num_rows_training,
        num_rows_validation,
        num_rows_testing,
        )
end

function _partition_rows(
        rng::AbstractRNG,
        num_rows_training::Integer,
        num_rows_validation::Integer,
        num_rows_testing::Integer,
        )
    num_rows = num_rows_training + num_rows_validation + num_rows_testing
    all_rows = convert(Array, 1:num_rows)
    rows_testing = sample(
        rng,
        all_rows,
        num_rows_training;
        replace=false,
        )
    remaining_rows = setdiff(all_rows,rows_testing)
    rows_validation = sample(
        rng,
        remaining_rows,
        num_rows_validation;
        replace=false,
        )
    rows_training = setdiff(remaining_rows, rows_validation)

    assigned_rows = vcat(rows_training, rows_validation, rows_testing)

    @assert(all_rows == sort(assigned_rows))

    return rows_training, rows_validation, rows_testing
end
