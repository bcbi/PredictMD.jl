##### Beginning of file

import CSV
import CSVFiles
import DataFrames
import FileIO

# import selected names from PredictMD
import ..convert_value_to_missing!
import ..filename_extension
import ..fix_type
import ..is_nothing

"""
"""
function x_contains_y(
        x::AbstractString,
        y::AbstractVector{<:AbstractString},
        )
    if length(y) == 0
        return false
    end
    for i = 1:length(y)
        if occursin(y[i], x)
            return true
        end
    end
    return false
end

"""
"""
function symbol_begins_with(
    x::Symbol,
    y::AbstractString
    )
    if length(y) <= length(string(x)) && string(x)[1:length(y)] == y
        return true
    else
        return false
    end
    return nothing
end

"""
Given a dataframe, return the column names corresponding to CCS "one-hot"
columns.

# Examples

```julia
import CSVFiles
import FileIO
import PredictMD

df = DataFrames.DataFrame(
    FileIO.load(
        MY_CSV_FILE_NAME;
        type_detect_rows = 30_000,
        )
    )

@info(PredictMD.Cleaning.ccs_onehot_names(df))
@info(PredictMD.Cleaning.ccs_onehot_names(df, "ccs_onehot_"))
```
"""
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

"""

"""
function column_names_with_prefix(
        df::DataFrames.AbstractDataFrame,
        prefix::AbstractString,
        )
    all_names = DataFrames.names(df)
    name_begins_with_prefix = Vector{Bool}(length(all_names))
    for j = 1:length(all_names)
        name_begins_with_prefix[j] = symbol_begins_with(
            all_names[j],
            prefix,
            )
    end
    vector_of_matching_names = all_names[name_begins_with_prefix]
    return vector_of_matching_names
end

"""
Given a single ICD 9 code, import the relevant patients from the
Health Care Utilization Project (HCUP) National Inpatient Sample (NIS)
database.

# Examples:

```julia
import CSVFiles
import FileIO
import PredictMD

icd_code_list = ["8841"]
icd_code_type=:procedure
input_file_name_list = [
    "./data/nis_2012_core.csv",
    "./data/nis_2013_core.csv",
    "./data/nis_2014_core.csv",
    ]
output_file_name = "./output/hcup_nis_pr_8841.csv"

PredictMD.Cleaning.clean_hcup_nis_csv_icd9(
    icd_code_list,
    input_file_name_list,
    output_file_name;
    icd_code_type=icd_code_type,
    rows_for_type_detect = 30_000,
    )

df = DataFrames.DataFrame(
    FileIO.load(
        output_file_name;
        type_detect_rows = 30_000,
        )
    )

@info(PredictMD.Cleaning.ccs_onehot_names(df))
```
"""
function clean_hcup_nis_csv_icd9(
        icd_code_list::AbstractVector{<:AbstractString},
        input_file_name_list::AbstractVector{<:AbstractString},
        output_file_name::AbstractString;
        header_row::Bool = true,
        print_every_n_lines::Integer = 1_000_000,
        icd_code_type::Union{Nothing, Symbol} = nothing,
        num_dx_columns::Integer = 25,
        num_pr_columns::Integer = 15,
        ccs_onehot_prefix::AbstractString = "ccs_onehot_",
        rows_for_type_detect::Union{Nothing, Integer} = nothing,
        )
    if is_nothing(rows_for_type_detect)
        error("you need to specify rows_for_type_detect")
    end
    if rows_for_type_detect <= 0
        error("rows_for_type_detect must be > 0")
    end

    if is_nothing(icd_code_type)
        error("you need to specify icd_code_type")
    end
    if icd_code_type==:diagnosis
    elseif icd_code_type==:procedure
    else
        error("\"icd_code_type\" must be one of: :diagnosis, :procedure")
    end

    if length(input_file_name_list) == 0
        error("length(input_file_name_list) == 0")
    end

    input_file_name_list = strip.(input_file_name_list)

    for i = 1:length(input_file_name_list)
        if filename_extension(input_file_name_list[i]) != ".csv"
            error("all input files must be .csv")
        end
    end

    output_file_name = strip.(output_file_name)

    if filename_extension(output_file_name) != ".csv"
        error("output file must be .csv")
    end
    if ispath(output_file_name)
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

    icd_code_list = strip.(icd_code_list)

    for i = 1:length(input_file_name_list)
        if ispath(temp_file_name_vector[i])
            error("ispath(temp_file_name_vector[i])")
        end
        @info(
            string(
                "Starting to read input file ",
                i,
                " of ",
                length(input_file_name_list),
                ".",
                )
            )
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
                    if (print_every_n_lines >= 0) &&
                            (line_number % print_every_n_lines == 0)
                        @info(
                            string(
                                "Input file ",
                                i,
                                " of ",
                                length(input_file_name_list),
                                ". Current line number: ",
                                line_number,
                                )
                            )
                    end
                end
            end
        end
        @info(
            string(
                "Finished reading input file ",
                i,
                " of ",
                length(input_file_name_list),
                ".",
                )
            )
    end

    df_vector = Vector{DataFrames.DataFrame}(length(input_file_name_list))

    for i = 1:length(temp_file_name_vector)
        @info(
            string(
                "Starting to read temporary file ",
                i,
                " of ",
                length(input_file_name_list),
                ".",
                )
            )
        # df_i = DataFrames.readtable(temp_file_name_vector[i])
        # We can't use DataFrames.readtable because it is deprecated.
        df_i = DataFrames.DataFrame(
            FileIO.load(
                temp_file_name_vector[i];
                type_detect_rows = rows_for_type_detect,
                )
            )
        df_vector[i] = df_i
        @info(
            string(
                "Finished reading temporary file ",
                i,
                " of ",
                length(input_file_name_list),
                ".",
                )
            )
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
    shared_column_names = intersect(all_column_names_vectors...)

    for i = 1:length(df_vector)
        extra_column_names = setdiff(
            names(df_vector[i]),
            shared_column_names,
            )
        DataFrames.deletecols!(df_vector[i], extra_column_names,)
    end

    combined_df = vcat(df_vector...)

    for i = 1:length(df_vector)
        df_vector[i] = DataFrames.DataFrame()
    end

    if icd_code_type==:diagnosis
        icd_code_column_names = Symbol[
            Symbol( string("DX", j) ) for j = 1:num_dx_columns
            ]
    elseif icd_code_type==:procedure
        icd_code_column_names = Symbol[
            Symbol( string("PR", j) ) for j = 1:num_pr_columns
            ]
    else
        error("\"icd_code_type\" must be one of: :diagnosis, :procedure")
    end

    row_i_has_kth_icd_code_matrix = Matrix{Bool}(
        size(combined_df, 1),
        length(icd_code_list),
        )
    for k = 1:length(icd_code_list)
        current_icd_code = icd_code_list[k]
        row_i_has_current_icd_code_in_col_j_matrix =
            Matrix{Bool}(
                size(combined_df, 1),
                length(icd_code_column_names),
                )
        for j = 1:length(icd_code_column_names)
            @info(
                string(
                    "icd9 code ",
                    k,
                    " of ",
                    length(icd_code_list),
                    ". DX column ",
                    j,
                    " of ",
                    length(icd_code_column_names),
                    ".",
                    )
                )
            for i = 1:size(combined_df, 1)
                cell_value = combined_df[i, icd_code_column_names[j]]
                if DataFrames.ismissing(cell_value)
                    row_i_has_current_icd_code_in_col_j_matrix[i, j] = false
                else
                    cell_value = strip(string(cell_value))
                    row_i_has_current_icd_code_in_col_j_matrix[i, j] =
                        cell_value == current_icd_code
                end
            end
        end
        row_i_has_current_icd_code_in_any_icdcode_column = vec(
            sum(row_i_has_current_icd_code_in_col_j_matrix, 2) .> 0
            )
        row_i_has_kth_icd_code_matrix[:, k] =
            row_i_has_current_icd_code_in_any_icdcode_column
    end

    matching_rows =
        findall(Bool.(vec(sum(row_i_has_kth_icd_code_matrix, 2).>0)))
    num_rows_before = size(combined_df, 1)
    combined_df = combined_df[matching_rows, :]
    num_rows_after = size(combined_df, 1)
    @info(
        string(
            "I initially identified ",
            num_rows_before,
            " rows that could possibly have matched your ICD code(s).",
            " I checked each row, and ",
            num_rows_after,
            " of those rows actually matched your ICD code(s).",
            "I removed the ",
            num_rows_before - num_rows_after,
            " rows that did not match.",
            )
        )

    dx_column_names = [Symbol(string("DX", i)) for i = 1:num_dx_columns]
    dx_ccs_column_names =
        [Symbol(string("DXCCS", i)) for i = 1:num_dx_columns]

    index_to_ccs = strip.(
        string.(
            unique(
                DataFrames.skipmissing(
                    vcat(
                        [combined_df[:, col] for
                            col in dx_ccs_column_names]...
                        )
                    )
                )
            )
        )
    index_to_ccs = index_to_ccs[findall(index_to_ccs .!= "")]
    index_to_ccs = unique(index_to_ccs)
    index_to_ccs = parse.(Int, index_to_ccs)
    sort!(index_to_ccs)
    index_to_ccs = string.(index_to_ccs)

    ccs_to_index = Dict()
    for k = 1:length(index_to_ccs)
        ccs_to_index[  index_to_ccs[ k ]  ] = k
    end
    ccs_to_index = fix_type(ccs_to_index)

    row_i_has_vcode_dx_in_kth_ccs = Matrix{Bool}(
        size(combined_df, 1),
        length(index_to_ccs),
        )

    for j = 1:length(dx_column_names)
        @info(
            string(
                "Processing DXCCS column ",
                j,
                " of ",
                length(dx_column_names),
                ".",
                )
            )
        jth_dx_col_name = dx_column_names[j]
        jth_dx_ccs_col_name = dx_ccs_column_names[j]
        for i = 1:size(combined_df, 1)
            dx_value = combined_df[i, jth_dx_col_name]
            if DataFrames.ismissing(dx_value)
            else
                dx_value = strip(string(dx_value))
                if length(dx_value) == 0
                elseif dx_value[1] == 'V' || dx_value[1] == "V"
                    ccs_value = combined_df[i, jth_dx_ccs_col_name]
                    if DataFrames.ismissing(ccs_value)
                        error(
                            error(
                                "dx value was not missing but",
                                "ccs value was missing"
                                )
                            )
                    else
                        ccs_value = strip(string(ccs_value))
                        row_i_has_vcode_dx_in_kth_ccs[
                            i,
                            ccs_to_index[ccs_value]
                            ] = true
                    end
                end
            end
        end
    end

    for k = 1:length(index_to_ccs)
        kth_ccs = index_to_ccs[k]
        kth_ccs_onehot_column_name = Symbol(
            string(
                ccs_onehot_prefix,
                kth_ccs,
                )
            )
        temporary_column_ints = Int.(row_i_has_vcode_dx_in_kth_ccs[:, k])
        if sum(temporary_column_ints) > 0
            temporary_column_strings = Vector{String}(size(combined_df, 1))
            for i = 1:size(combined_df, 1)
                if temporary_column_ints[i] > 0
                    temporary_column_strings[i] = "Yes"
                else
                    temporary_column_strings[i] = "No"
                end
            end
            combined_df[kth_ccs_onehot_column_name] =
                temporary_column_strings
        else
        end
    end

    convert_value_to_missing!(
        combined_df,
        "A",
        DataFrames.names(combined_df),
        )
    convert_value_to_missing!(
        combined_df,
        "C",
        DataFrames.names(combined_df),
        )
    convert_value_to_missing!(
        combined_df,
        -99,
        DataFrames.names(combined_df),
        )

    try
        mkpath(dirname(output_file_name))
    catch
    end

    @info(string("Attempting to write output file..."))

    CSV.write(
        output_file_name,
        combined_df,
        )

    @info(
        string(
            "Wrote ",
            size(combined_df, 1),
            " rows to output file: \"",
            output_file_name,
            "\"",
            )
        )

    return output_file_name
end

##### End of file
