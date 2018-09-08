import DataFrames

function find_constant_rows(m::AbstractMatrix)::Vector{Int}
    list_of_constant_row_indices = Int[]
    for i = 1:size(m, 1)
        if length(unique(collect(DataFrames.skipmissing(m[i, :])))) < 2
            push!(list_of_constant_row_indices, i)
        end
    end
    return list_of_constant_row_indices
end

function find_constant_columns(m::AbstractMatrix)::Vector{Int}
    list_of_constant_column_indices = Int[]
    for j = 1:size(m, 2)
        if length(unique(collect(DataFrames.skipmissing(m[:, j])))) < 2
            push!(list_of_constant_column_indices, j)
        end
    end
    return list_of_constant_column_indices
end

function find_constant_columns(
        df::DataFrames.AbstractDataFrame,
        )::Vector{Symbol}
    list_of_constant_column_names = Symbol[]
    for x in DataFrames.names(df)
        if length(unique(collect(DataFrames.skipmissing(df[x])))) < 2
            push!(list_of_constant_column_names)
        end
    end
    return list_of_constant_column_names
end

function check_no_constant_columns(
        df::DataFrames.AbstractDataFrame,
        )::Nothing
    list_of_constant_column_names = find_constant_columns(df)
    if length(list_of_constant_column_names) > 0
        error(
            string(
                "Data frame contains the following constant columns: ",
                list_of_constant_column_names,
                "\"",
                )
            )
    else
        return nothing
    end
end
