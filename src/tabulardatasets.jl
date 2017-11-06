using DataFrames
using IterableTables
using StatsBase

struct HoldoutTabularDataset <: AbstractHoldoutTabularDataset
    data_labels_original::T1 where T1 <: Associative
    data_labels_integer::T2 where T2 <: Associative
    label_decoding_maps_integer::T3 where T3 <: Associative
    data_labels_onehot::T4 where T4 <: Associative
    label_decoding_maps_onehot::T5 where T5 <: Associative
    data_labels_fullonehot::T6 where T6 <: Associative
    label_decoding_maps_fullonehot::T7 where T7 <: Associative
    data_features::T8 where T8 <: AbstractDataFrame
    data_unusedcolumns::T9 where T9 <: AbstractDataFrame
    label_variables::T10 where T10 <: AbstractVector{Symbol}
    feature_variables::T11 where T11 <: AbstractVector{Symbol}
    rows_training::T12 where T12 <: StatsBase.IntegerVector
    rows_validation::T13 where T13 <: StatsBase.IntegerVector
    rows_testing::T14 where T14 <: StatsBase.IntegerVector
end

function HoldoutTabularDataset(
        data_original,
        label_variables::T2 where T2 <: AbstractVector{Symbol},
        feature_variables::T3 where T3 <: AbstractVector{Symbol};
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        shuffle_rows::Bool = true,
        )
    return HoldoutTabularDataset(
        Base.GLOBAL_RNG,
        data_original,
        label_variables,
        feature_variables;
        training = training,
        validation = validation,
        testing = testing,
        shuffle_rows = shuffle_rows,
        )
end

function HoldoutTabularDataset(
        rng::AbstractRNG,
        data_original,
        label_variables::T2 where T2 <: AbstractVector{Symbol},
        feature_variables::T3 where T3 <: AbstractVector{Symbol};
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        shuffle_rows::Bool = true,
        )
    data_frame = DataFrame(data_original)
    num_rows = size(data_frame, 1)

    if shuffle_rows
        permutation = shuffle(rng, 1:num_rows)
        data_frame = data_frame[permutation, :]
    end

    pool!(data_frame)

    all_column_names = names(data_frame)

    for y = label_variables
        if !(y in all_column_names)
            error("label variable $(y) is not one of the columns")
        end
    end

    for x = feature_variables
        if !(x in all_column_names)
            error("feature variable $(x) is not one of the columns")
        end
    end

    used_column_names = vcat(label_variables, feature_variables)
    unused_column_names = setdiff(all_column_names, used_column_names)

    num_rows_training, num_rows_validation, num_rows_testing =
        _calculate_num_rows_partition(num_rows, training, validation, testing)
    rows_training, rows_validation, rows_testing = _partition_rows(
        rng,
        num_rows_training,
        num_rows_validation,
        num_rows_testing,
        )

    data_labels_original = Dict()
    data_labels_integer = Dict()
    label_decoding_maps_integer = Dict()
    data_labels_onehot = Dict()
    label_decoding_maps_onehot = Dict()
    data_labels_fullonehot = Dict()
    label_decoding_maps_fullonehot = Dict()
    for labelvar = label_variables
        label_column_original = data_frame[:, labelvar]
        labeltype = eltype(label_column_original)
        if labeltype <: Real
            data_labels_original[labelvar] = label_column_original
        else
            data_labels_original[labelvar] = label_column_original
            #
            label_column_int, int_coding_map = encode_labels(
                label_column_original,
                :integer,
                )
            data_labels_integer[labelvar] = label_column_int
            label_decoding_maps_integer[labelvar] = int_coding_map
            #
            label_column_onehot, onehot_coding_map = encode_labels(
                label_column_original,
                :onehot
                )
            data_labels_onehot[labelvar] = label_column_onehot
            label_decoding_maps_onehot[labelvar] = onehot_coding_map
            #
            label_column_fullonehot, fullonehot_coding_map = encode_labels(
                label_column_original,
                :onehot
                )
            data_labels_fullonehot[labelvar] = label_column_fullonehot
            label_decoding_maps_fullonehot[labelvar] = fullonehot_coding_map
        end
    end

    data_features = data_frame[:, feature_variables]

    data_unusedcolumns = data_frame[:, unused_column_names]

    return HoldoutTabularDataset(
        data_labels_original,
        data_labels_integer,
        label_decoding_maps_integer,
        data_labels_onehot,
        label_decoding_maps_onehot,
        data_labels_fullonehot,
        label_decoding_maps_fullonehot,
        data_features,
        data_unusedcolumns,
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
