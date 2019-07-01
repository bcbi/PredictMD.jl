import DataFrames
import StatsBase

function get_countmap(itr; skip_missings::Bool = true)
    if skip_missings
        result = get_countmap_skip_missings(itr)
    else
        result = get_countmap_include_missings(itr)
    end
    return result
end

function get_countmap_skip_missings(itr)
    result = StatsBase.countmap(collect(skipmissing(itr)))
    return result
end

function get_countmap_include_missings(itr)
    result = StatsBase.countmap(collect(itr))
    return result
end

function get_unique_values(itr; skip_missings::Bool = true)
    if skip_missings
        result = get_unique_values_skip_missings(itr)
    else
        result = get_unique_values_include_missings(itr)
    end
    return result
end

function get_unique_values_skip_missings(itr)
    result = keys(get_countmap_skip_missings(itr))
    return result
end

function get_unique_values_include_missings(itr)
    result = keys(get_countmap_include_missings(itr))
    return result
end

function get_number_of_unique_values(itr; skip_missings::Bool = true)::Int
    if skip_missings
        result = get_number_of_unique_values_skip_missings(itr)
    else
        result = get_number_of_unique_values_include_missings(itr)
    end
    return result
end

function get_number_of_unique_values_skip_missings(itr)::Int
    result::Int = length(get_unique_values_skip_missings(itr))
    return result
end

function get_number_of_unique_values_include_missings(itr)::Int
    result::Int = length(get_unique_values_include_missings(itr))
    return result
end

function find_constant_rows(m::AbstractMatrix)::Vector{Int}
    list_of_constant_row_indices = Int[]
    for i = 1:size(m, 1)
        if get_number_of_unique_values(m[i, :]) < 2
            push!(list_of_constant_row_indices, i)
        end
    end
    return list_of_constant_row_indices
end

function find_constant_columns(m::AbstractMatrix)::Vector{Int}
    list_of_constant_column_indices = Int[]
    for j = 1:size(m, 2)
        if get_number_of_unique_values(m[:, j]) < 2
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
        if get_number_of_unique_values(df[x]) < 2
            push!(list_of_constant_column_names)
        end
    end
    return list_of_constant_column_names
end

function check_no_constant_columns(
        df::DataFrames.AbstractDataFrame,
        )::Bool
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
        return true
    end
end
