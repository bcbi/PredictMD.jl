import CSV
import DataFrames

# imports from PredictMD
import ..filename_extension
import ..fix_dict_type
import ..is_nothing
import ..make_missing_anywhere!
import ..something_exists_at_path

function x_contains_y(
        x::AbstractString,
        y::AbstractVector{<:AbstractString},
        )
    if length(y) == 0
        return false
    end
    for i = 1:length(y)
        if contains(x, y[i])
            return true
        end
    end
    return false
end

function symbol_begins_with(
    x::Symbol,
    y::AbstractString
    )
    if string(x)[1:length(y)] == y
        return true
    else
        return false
    end
    return nothing
end

function ccs_onehot_names(
        df::DataFrames.AbstractDataFrame,
        ccs_onehot_prefix::AbstractString = "ccs_onehot_",
        )
    result = column_names_with_prefix(
        df,
        ccs_onehot_prefix,
        )
    return result
end

function column_names_with_prefix(
        df::DataFrames.AbstractDataFrame,
        prefix::AbstractString,
        )
    all_names = DataFrames.names(df)
    name_begins_with_prefix = Vector{Bool}(length(all_names))
    for j = 1:length(all_names)
        name_begins_with_prefix = symbol_begins_with(
            all_names[k],
            prefix,
            )
    end
    vector_of_ccs_onehot_names = all_names[name_begins_with_ccs_onehot_prefix]
    return vector_of_ccs_onehot_names
end

"""
Given a single ICD 9 code, import the relevant patients from the
Health Care Utilization Project (HCUP) National Inpatient Sample (NIS)
database.
"""
function clean_hcup_nis_csv_icd9(
        icd_code_list::AbstractVector{<:AbstractString},
        input_file_name_list::AbstractVector{<:AbstractString},
        output_file_name::AbstractString;
        header_row::Bool = true,
        print_every_n_lines::Integer = 1_000_000,
        icd_code_type::Union{Void, Symbol} = nothing,
        num_dx_columns::Integer = 25,
        num_pr_columns::Integer = 15,
        ccs_onehot_prefix::AbstractString = "ccs_onehot_",
        )
    """
    example usage:

    import PredictMD
    icd_code_list = ["8841"]
    input_file_name_list = [
        "./data/nis_2012_core.csv",
        "./data/nis_2013_core.csv",
        "./data/nis_2014_core.csv",
        ]
    output_file_name = "./output/hcup_nis_pr_8841.csv"
    icd_code_type = :procedure
    PredictMD.Clean.clean_hcup_nis_csv_icd9(
        icd_code_list,
        input_file_name_list,
        output_file_name;
        icd_code_type = icd_code_type,
        )
    """

    if is_nothing(icd_code_type)
        error("need to specify icd_code_type")
    end
    if icd_code_type == :diagnosis
    elseif icd_code_type == :procedure
    else
        error("icd_code_type must be one of: :diagnosis, :procedure")
    end
    if length(input_file_name_list) == 0
        error("length(input_file_name_list) == 0")
    end
    for i = 1:length(input_file_name_list)
        if filename_extension(input_file_name_list[i]) != ".csv"
            error("all input files must be .csv")
        end
    end
    if filename_extension(output_file_name) != ".csv"
        error("output file must be .csv")
    end
    if something_exists_at_path(output_file_name)
        error(
            string(
                "Output file already exists. ",
                "Rename, move, or delete the file, and then try again.",
                )
        )
    end
    temp_file_name_vector = Vector{String}(length(input_file_name_list))
    for i = 1:length(input_file_name_list)
        temp_file_name_vector[i] = string(tempname(), "_", i, ".csv")
    end
    for i = 1:length(input_file_name_list)
        if something_exists_at_path(temp_file_name_vector[i])
            error("something_exists_at_path(temp_file_name_vector[i])")
        end
        open(input_file_name_list[i], "r") do f_input
            open(temp_file_name_vector[i], "w") do f_temp_output
                line_number = 1
                for line in eachline(f_input)
                    if line_number == 1 && header_row
                        write(f_temp_output, line)
                        write(f_temp_output, "\n")
                    else
                        if x_contains_y(line, icd_code_list)
                            write(f_temp_output, line)
                            write(f_temp_output, "\n")
                        end
                    end
                    line_number += 1
                    if line_number % print_every_n_lines == 0
                        info(string("Current line number: ", line_number))
                    end
                end
            end
        end
    end

    df_vector = Vector{DataFrames.DataFrame}(length(input_file_name_list))

    for i = 1:length(temp_file_name_vector)
        # df_i = CSV.read(temp_file_name_vector[i],DataFrames.DataFrame,)
        df_i = DataFrames.readtable(temp_file_name_vector[i])
        df_vector[i] = df_i
    end

    for i = 1:length(temp_file_name_vector)
        Base.Filesystem.rm(
            temp_file_name_vector[i];
            force = true,
            recursive = true,
            )
    end

    all_column_names_vectors = [
        DataFrames.names(df) for df in df_vector
        ]
    shared_column_names = intersect(all_names_vectors...)

    for i = 1:length(df_vector)
        extra_column_names = setdiff(
            names(df_vector[i]),
            shared_column_names,
            )
        DataFrames.delete!(df_vector, extra_column_names)
    end

    combined_df = vcat(df_vector...)

    for i = 1:length(df_vector)
        df_vector[i] = DataFrames.DataFrame()
    end

    if icd_code_type == :diagnosis
        icd_code_column_names = Symbol[
            Symbol( string("DX", i) ) for j = 1:num_dx_columns
            ]
    elseif icd_code_type == :procedure
        icd_code_column_names = Symbol[
            Symbol( string("PR", i) ) for j = 1:num_pr_columns
            ]
    else
        error("icd_code_type must be one of: :diagnosis, :procedure")
    end

    ith_row_has_kth_icd_code_matrix = Matrix{Bool}(
        size(combined_df, 1),
        length(icd_code_list),
        )
    for k = 1:length(icd_code_list)
        current_icd_code = icd_code_list[k]
        ith_row_has_current_icd_code_in_jth_icdcodecolumn_matrix = Matrix{Bool}(
            size(combined_df, 1),
            length(icd_code_column_names),
            )
        for j = 1:length(icd_code_column_names)
            for i = size(combined_df, 1)
                ith_row_has_current_icd_code_in_jth_icdcodecolumn_matrix =
                    combined_df[i, icd_code_column_names[j]] == current_icd_code
            end
        end
        ith_row_has_current_icd_code_in_jth_icdcodecolumn_matrix[
            DataFrames.ismissing(ith_row_has_current_icd_code_in_jth_icdcodecolumn_matrix)
            ] = false
        ith_row_has_current_icd_code_in_any_icdcode_column = vec(
            sum(ith_row_has_current_icd_code_in_jth_icdcodecolumn_matrix, 2) .> 0
            )
        ith_row_has_kth_icd_code_matrix[:, k] = ith_row_has_current_icd_code_in_any_icdcode_column
    end

    matching_rows = find(
        vec(
            sum(ith_row_has_kth_icd_code_matrix, 2) .> 0
            )
        )

    combined_df = combined_df[matching_rows, :]

    dx_column_names = [Symbol(string("DX", i)) for i = 1:num_dx_columns]
    dx_ccs_column_names = [Symbol(string("DXCCS", i)) for i = 1:num_dx_columns]

    info("DEBUG before big nasty thing. time: ", now())
    index_to_ccs = string.(
        unique(
            DataFrames.skipmissing(
                vcat(
                    [combined_df[:, col] for col in dx_ccs_column_names]...
                    )
                )
            )
        )
    info("DEBUG in middle of big nasty thing. time: ", now())
    ccs_to_index = Dict()
    for k = 1:length(index_to_ccs)
        ccs_to_index[  index_to_ccs[ k ]  ] = k
    end
    ccs_to_index = fix_dict_type(ccs_to_index)
    info("DEBUG after big nasty thing. time: ", now())

    ith_row_has_vcode_dx_in_kth_ccs = Matrix{Bool}(
        size(combined_df, 1),
        length(index_to_ccs),
        )

    for j = 1:length(dx_column_names)
        jth_dx_col_name = dx_column_names[j]
        jth_dx_ccs_col_name = dx_ccs_column_names[j]
        for i = 1:size(combined_df, 1)
            dx_value = combined_df[i, jth_dx_col_name]
            if DataFrames.ismissing(dx_value)
            else
                if dx_value[1] == "V"
                    ccs_value = combined_df[i, jth_dx_ccs_col_name]
                    if DataFrames.ismissing(ccs_value)
                        error("dx value was not missing but ccs value was missing")
                    else
                        ith_row_has_vcode_dx_in_kth_ccs[i, ccs_to_index[ccs_value]] = true
                    end
                end
            end
        end
    end

    DEBUG_num_ccs_columns_added = 0
    DEBUG_num_ccs_columns_not_added = 0
    for k = 1:length(index_to_ccs)
        kth_ccs = ccs_to_index[k]
        kth_ccs_onehot_column_name = Symbol(
            string(
                ccs_onehot_prefix,
                kth_ccs,
                )
            )
        temporary_column_ints = Int.(ith_row_has_vcode_dx_in_kth_ccs[i, k])
        if sum(temporary_column_ints) > 0
            temporary_column_strings = Vector{String}(size(combined_df, 1))
            for i = 1:size(combined_df, 1)
                if temporary_column_ints[i] > 0
                    temporary_column_strings[i] = "Yes"
                else
                    temporary_column_strings[i] = "No"
                end
            end
            combined_df[kth_ccs_onehot_column_name] = temporary_column_strings
            info("DEBUG Added ccs column: ", kth_ccs_onehot_column_name)
            DEBUG_num_ccs_columns_added += 1
        else
            DEBUG_num_ccs_columns_not_added += 1
        end
    end

    if !(DEBUG_num_ccs_columns_added + DEBUG_num_ccs_columns_added == length(index_to_ccs))
        error("!(DEBUG_num_ccs_columns_added + DEBUG_num_ccs_columns_not_added == length(index_to_ccs))")
    end
    info("DEBUG: num_ccs_columns_added: ", DEBUG_num_ccs_columns_added)
    info("DEBUG: num_ccs_columns_not_added", DEBUG_num_ccs_columns_added)

    make_missing_anywhere!(combined_df, "A")
    make_missing_anywhere!(combined_df, "C")

    CSV.write(
        output_file_name,
        combined_df,
        )

    return output_file_name
end
