import DataFrames
import IterableTables
import StatsBase

struct HoldoutTabularDataset{T} <: AbstractHoldoutTabularDataset{T}
    blobs::A where A <: Associative
end

struct ResampledHoldoutTabularDataset{T} <: AbstractHoldoutTabularDataset{T}
    blobs::A where A <: Associative
end

function HoldoutTabularDataset(
        data_original;
        data_name::AbstractString = "Untitled Data Set",
        label_variables::T2 = Vector{Symbol}(),
        feature_variables::T3 = Vector{Symbol}(),
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        shuffle_rows::Bool = true,
        recordid_fieldname::Symbol = :recordid,
        ) where
        T2 <: AbstractVector{Symbol} where
        T3 <: AbstractVector{Symbol}
    return HoldoutTabularDataset(
        Base.GLOBAL_RNG,
        data_original;
        label_variables = label_variables,
        feature_variables = feature_variables,
        training = training,
        validation = validation,
        testing = testing,
        shuffle_rows = shuffle_rows,
        recordid_fieldname = :recordid,
        )
end

function HoldoutTabularDataset(
        rng::AbstractRNG,
        data_original;
        data_name::AbstractString = "Untitled Data Set",
        label_variables::T2 = Vector{Symbol}(),
        feature_variables::T3 = Vector{Symbol}(),
        training::Real = 0.0,
        validation::Real = 0.0,
        testing::Real = 0.0,
        shuffle_rows::Bool = true,
        recordid_fieldname::Symbol = :recordid,
        ) where
        T2 <: AbstractVector{Symbol} where
        T3 <: AbstractVector{Symbol}

    blobs = Dict{Symbol, Any}()

    blobs[:data_name] = data_name

    data_frame = DataFrames.DataFrame(data_original)

    num_rows = size(data_frame, 1)
    blobs[:num_rows] = num_rows

    for col_name in names(data_frame)
        col_values = data_frame[col_name]
        col_uniquevalues = sort( unique( col_values ) )
        col_numuniquevalues = length(col_uniquevalues)
        col_eltype = eltype(col_values)
        num_missing = sum( DataFrames.isna.( col_values ) )
        percent_missing = num_missing/num_rows * 100.
        if num_missing > 0
            error(
                "Column \"$(col_name)\" has $(num_missing) missing " *
                    "values ($(percent_missing) percent)"
                )
        end
        if col_numuniquevalues == 0
            error(
                "Column \"$(col_name)\" has zero unique values" *
                    "(eltype: $(col_eltype))"
                )
        end
        if col_numuniquevalues == 1
            singleval = col_uniquevalues[1]
            if col_eltype <: Real
                warn(
                    "Column \"$(col_name)\" only has one unique value" *
                        "(eltype: $(col_eltype), value: $(col_eltype))"
                    )
            else
                warn(
                    "Column \"$(col_name)\" only has one unique value" *
                        "(eltype: $(col_eltype), value: $(singleval))"
                    )
            end
        end
    end

    if recordid_fieldname in names(data_frame)
        msg = "The dataset already has a column named $(recordid_fieldname)."*
            "Please select a different name for the recordid column."
        error(msg)
    end
    blobs[:recordid_fieldname] = recordid_fieldname
    data_frame[recordid_fieldname] = 1:num_rows

    if shuffle_rows
        permutation = shuffle(rng, 1:num_rows)
        data_frame = data_frame[permutation, :]
    end

    DataFrames.pool!(data_frame)

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
            if labeltype <: Integer
                data_labels_integer[labelvar] = label_column_original
            end
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


    data_features = data_frame[:, feature_variables]
    blobs[:data_features] = data_features

    formulaobject_nointercept_firstlabel = generate_formula_object(
        label_variables[1],
        feature_variables;
        intercept=false,
        )
    modelframe_nointercept_firstlabel = DataFrames.ModelFrame(
        formulaobject_nointercept_firstlabel,
        data_frame,
        )
    modelmatrix_nointercept_firstlabel = DataFrames.ModelMatrix(
        modelframe_nointercept_firstlabel,
        )
    data_features_matrix = modelmatrix_nointercept_firstlabel.m
    blobs[:data_features_matrix] = data_features_matrix


    blobs[:data_unusedcolumns] = data_frame[:, unused_column_names]

    return HoldoutTabularDataset{DataFrames.DataFrame}(blobs)
end

function recordidlist_to_rownumberlist(
        dataset::AbstractHoldoutTabularDataset,
        recordidlist::StatsBase.IntegerVector,
        )
    num_rows = dataset.blobs[:num_rows]
    onetonumrowsordered = convert(Array, 1:num_rows)
    num_records_requested = length(recordidlist)
    recordid_fieldname = dataset.blobs[:recordid_fieldname]
    data_unusedcolumns = dataset.blobs[:data_unusedcolumns]
    all_recordids = data_unusedcolumns[recordid_fieldname]
    row_number_for_each_record = [
        onetonumrowsordered[all_recordids.==recordidlist[i]][1]
        for i = 1:num_records_requested
        ]
    return row_number_for_each_record
end

numtraining(d::AbstractHoldoutTabularDataset) =
    length(d.blobs[:rows_training])
numvalidation(d::AbstractHoldoutTabularDataset) =
    length(d.blobs[:rows_validation])
numtesting(d::AbstractHoldoutTabularDataset) =
    length(d.blobs[:rows_testing])

hastraining(d::AbstractHoldoutTabularDataset) = numtraining(d) > 0
hasvalidation(d::AbstractHoldoutTabularDataset) = numvalidation(d) > 0
hastesting(d::AbstractHoldoutTabularDataset) = numtesting(d) > 0

dataname(d::AbstractHoldoutTabularDataset) = d.blobs[:data_name]

function getdata(
        dataset::AbstractHoldoutTabularDataset;
        training::Bool = false,
        validation::Bool = false,
        testing::Bool = false,
        all_labels::Bool = false,
        single_label::Bool = false,
        label_variable::Symbol = dataset.blobs[:label_variables][1],
        features::Bool = false,
        shuffle_rows::Bool = true,
        label_type::Symbol = :original,
        recordidlist::StatsBase.IntegerVector = Vector{Int64}(),
        features_format::Symbol = :original,
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
        recordidlist = recordidlist,
        features_format = features_format,
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
        label_variable::Symbol = dataset.blobs[:label_variables][1],
        features::Bool = false,
        shuffle_rows::Bool = true,
        label_type::Symbol = :original,
        recordidlist::StatsBase.IntegerVector = Vector{Int64}(),
        features_format::Symbol = :original,
        )

    recordidlist_provided = length(recordidlist) > 0

    if !(recordidlist_provided || training || validation || testing)
        error("At least 1 of training, validation, testing must be true")
    end
    if !(all_labels || single_label || features)
        error("At least 1 of all_labels, single_label, features must be true")
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

    if !(features_format == :original || features_format == :matrix)
        error("features_format must either be :original or :matrix ")
    end

    if features_format == :matrix
        returndataasmatrix = true
        if !features
            error("If features_format==:matrix, then features must be true")
        end
        if all_labels || single_label
            msg = "If features_format==:matrix, then all_labels and " *
                "single_label must both be false."
            error(msg)
        end
    else
        returndataasmatrix = false
    end

    if returndataasmatrix
        allrowsselectedcolumns = dataset.blobs[:data_features_matrix]
    else
        allrowsselectedcolumns = DataFrames.DataFrame()
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
    end

    if recordidlist_provided
        rownumberlist = recordidlist_to_rownumberlist(
            dataset,
            recordidlist
            )
        datatoreturn = allrowsselectedcolumns[rownumberlist, :]
        return datatoreturn
    else
        selected_rows = Vector{Int}()
        if training
            selected_rows = vcat(
                selected_rows,
                dataset.blobs[:rows_training],
                )
        end
        if validation
            selected_rows = vcat(
                selected_rows,
                dataset.blobs[:rows_validation],
                )
        end
        if testing
            selected_rows = vcat(
                selected_rows,
                dataset.blobs[:rows_testing],
                )
        end
        sort!(selected_rows)
        num_selected_rows = length(selected_rows)
        datatoreturn = allrowsselectedcolumns[selected_rows, :]
        data_unusedcolumns = dataset.blobs[:data_unusedcolumns]
        recordid_fieldname = dataset.blobs[:recordid_fieldname]
        corresponding_recordidlist =
            data_unusedcolumns[selected_rows,recordid_fieldname]
        @assert(typeof(corresponding_recordidlist) <: AbstractVector)
        corresponding_recordidlist_array =
            convert(Array, corresponding_recordidlist)
        @assert(
            typeof(corresponding_recordidlist_array) <:
                StatsBase.IntegerVector
            )
        @assert(size(datatoreturn,1) == num_selected_rows)
        @assert(length(corresponding_recordidlist_array) == num_selected_rows)
        # if shuffle_rows
        if true
            permutation = shuffle(rng, 1:num_selected_rows)
            datatoreturn =
                datatoreturn[permutation, :]
            corresponding_recordidlist_array =
                corresponding_recordidlist_array[permutation]
        end
        return datatoreturn, corresponding_recordidlist_array
    end
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
        isapprox(num_rows_training/num_rows, training; atol=0.1)
        )
    @assert(
        isapprox(num_rows_validation/num_rows, validation; atol=0.1)
        )
    @assert(
        isapprox(num_rows_testing/num_rows, testing; atol=0.1)
        )

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
    rows_testing = StatsBase.sample(
        rng,
        all_rows,
        num_rows_testing;
        replace=false,
        )
    all_rows_minus_testing = setdiff(all_rows,rows_testing)
    rows_validation = StatsBase.sample(
        rng,
        all_rows_minus_testing,
        num_rows_validation;
        replace=false,
        )
    rows_training = setdiff(all_rows_minus_testing, rows_validation)

    @assert(length(rows_training) == num_rows_training)
    @assert(length(rows_validation) == num_rows_validation)
    @assert(length(rows_testing) == num_rows_testing)

    assigned_rows = vcat(rows_training, rows_validation, rows_testing)
    @assert(all_rows == sort(assigned_rows))

    return rows_training, rows_validation, rows_testing
end

function _check_holdout_model_arguments(
        dataset::AbstractHoldoutTabularDataset;
        dotraining::Bool = false,
        dovalidation::Bool = false,
        dotesting::Bool = false,
        modelrequirestraining::Bool = true,
        modelsupportsvalidation::Bool = false,
        )
    if dotraining && !hastraining(dataset)
        error("dotraining is true but dataset doesn't have training data")
    end
    if dovalidation && !hasvalidation(dataset)
        error("dovalidation is true but dataset doesn't have validation data")
    end
    if dotesting && !hastesting(dataset)
        error("dotesting is true but dataset doesn't have testing data")
    end
    if modelrequirestraining && !dotraining
        error("model requires training phase but dotraining is false")
    end
    if dovalidation && !modelsupportsvalidation
        error("dovalidation is true but model does not support validation")
    end
end
