import DataFrames

function get_unique_values(itr; skip_missings::Bool = true)
    if skip_missings
        result = get_unique_values_skip_missings(itr)
    else
        result = get_unique_values_include_missings(itr)
    end
    return result
end

function get_unique_values_skip_missings(itr)
    return unique(skipmissing(collect(itr)))
end

function get_unique_values_include_missings(itr) 
    return unique(collect(itr))
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

function find_constant_columns(
        df::DataFrames.AbstractDataFrame,
        )::Vector{Symbol}
    list_of_constant_column_names = Symbol[]
    for x in DataFrames.names(df)
        if get_number_of_unique_values(df[x]) < 2
            push!(list_of_constant_column_names, x)
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
