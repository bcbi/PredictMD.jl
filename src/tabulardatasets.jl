using DataFrames
using IterableTables
using StatsBase

struct HoldoutTabularDataset <: AbstractHoldoutTabularDataset
    blobs::T where T <: Associative
end

struct ResampledHoldoutTabularDataset <: AbstractHoldoutTabularDataset
    blobs::T where T <: Associative
end

function HoldoutTabularDataset(
        data_original,
        label_variables::T2 where T2 <: AbstractVector{Symbol},
        feature_variables::T3 where T3 <: AbstractVector{Symbol};
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        shuffle_rows::Bool = true,
        recordid_fieldname::Symbol = :recordid,
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
        recordid_fieldname = :recordid,
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
        recordid_fieldname::Symbol = :recordid,
        )

    blobs = Dict{Symbol, Any}()

    data_frame = DataFrame(data_original)

    if recordid_fieldname in names(data_frame)
        msg = "The dataset already has a column named $(recordid_fieldname)."*
            "Please select a different name for the recordid column."
        error(msg)
    end

    blobs[:recordid_fieldname] = recordid_fieldname

    num_rows = size(data_frame, 1)
    data_frame[recordid_fieldname] = 1:num_rows

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

    blobs[:label_variables] = label_variables

    for x = feature_variables
        if !(x in all_column_names)
            error("feature variable $(x) is not one of the columns")
        end
    end

    blobs[:feature_variables] = feature_variables

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
    blobs[:rows_training] = rows_training
    blobs[:rows_validation] = rows_validation
    blobs[:rows_testing] = rows_testing

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
    blobs[:data_labels_original] = data_labels_original
    blobs[:data_labels_integer] = data_labels_integer
    blobs[:data_labels_onehot] = data_labels_onehot
    blobs[:data_labels_fullonehot] = data_labels_fullonehot
    blobs[:label_decoding_maps_integer] = label_decoding_maps_integer
    blobs[:label_decoding_maps_onehot] = label_decoding_maps_onehot
    blobs[:label_decoding_maps_fullonehot] = label_decoding_maps_fullonehot


    blobs[:data_features] = data_frame[:, feature_variables]

    blobs[:data_unusedcolumns] = data_frame[:, unused_column_names]

    return HoldoutTabularDataset(blobs)
end

get_feature_variables(dataset::AbstractHoldoutTabularDataset) =
    dataset.blobs[:feature_variables]

function getdata(
        dataset::AbstractHoldoutTabularDataset;
        training::Bool = false,
        validation::Bool = false,
        testing::Bool = false,
        all_labels::Bool = false,
        single_label::Bool = false,
        label_variable = dataset.blobs[:label_variables][1],
        features::Bool = false,
        shuffle_rows::Bool = true,
        label_type::Symbol = :original,
        )
    return getdata(
        Base.GLOBAL_RNG,
        dataset;
        training = training,
        validation = validation,
        testing = testing,
        all_labels = all_labels,
        single_label = single_label,
        label_variable = label_variable,
        features = features,
        shuffle_rows = shuffle_rows,
        label_type = label_type,
        )
end

function getdata(
        rng::AbstractRNG,
        dataset::AbstractHoldoutTabularDataset;
        training::Bool = false,
        validation::Bool = false,
        testing::Bool = false,
        all_labels::Bool = false,
        single_label::Bool = false,
        label_variable = dataset.blobs[:label_variables][1],
        features::Bool = false,
        shuffle_rows::Bool = true,
        label_type::Symbol = :original,
        )
    if !(training || validation || testing)
        error("At least 1 of training, validation, testing must be true.")
    end
    if !(all_labels || single_label || features)
        error("At least 1 of all_labels, single_label, features must be true.")
    end
    if (all_labels && single_label)
        error("all_labels and single_label cannot both be true.")
    end

    labeltype2labeldata = Dict()
    labeltype2labeldata[:original] =
        dataset.blobs[:data_labels_original]
    labeltype2labeldata[:integer] =
        dataset.blobs[:data_labels_integer]
    labeltype2labeldata[:onehot] =
        dataset.blobs[:data_labels_onehot]
    labeltype2labeldata[:dummy] =
        dataset.blobs[:data_labels_onehot]
    labeltype2labeldata[:fullonehot] =
        dataset.blobs[:data_labels_fullonehot]
    labeltype2labeldata[:fulldummy] =
        dataset.blobs[:data_labels_fullonehot]

    if !haskey(labeltype2labeldata, label_type)
        error("label_type must be 1 of: $(collect(keys(labeltype2labeldata)))")
    end

    desiredtype_labeldata = labeltype2labeldata[label_type]

    allrowsselectedcolumns = DataFrame()

    if all_labels
        for l in dataset.blobs[:label_variables]
            allrowsselectedcolumns[l] =
                desiredtype_labeldata[l]
        end
    elseif single_label
        allrowsselectedcolumns[label_variable] =
            desiredtype_labeldata[label_variable]
    end

    if features
        for f in dataset.blobs[:feature_variables]
            allrowsselectedcolumns[f] =
                dataset.blobs[:data_features][f]
        end
    end



    selected_rows = Vector{Int}()
    if training
        selected_rows = vcat(selected_rows, dataset.blobs[:rows_training])
    end
    if validation
        selected_rows = vcat(selected_rows, dataset.blobs[:rows_validation])
    end
    if testing
        selected_rows = vcat(selected_rows, dataset.blobs[:rows_testing])
    end
    sort!(selected_rows)
    num_selected_rows = length(selected_rows)

    result = allrowsselectedcolumns[selected_rows, :]

    corresponding_recordids =
        dataset.blobs[:data_unusedcolumns][
            selected_rows,
            [dataset.blobs[:recordid_fieldname]],
            ]

    if shuffle_rows
        permutation = shuffle(rng, 1:num_selected_rows)
        result = result[permutation, :]
        corresponding_recordids = corresponding_recordids[permutation, :]
    end

    return result, corresponding_recordids
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
