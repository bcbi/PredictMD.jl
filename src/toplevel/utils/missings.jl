##### Beginning of file

import DataFrames

"""
"""
function convert_value_to_missing! end

function convert_value_to_missing!(
        df::DataFrames.AbstractDataFrame,
        value,
        column_names::AbstractArray{Symbol},
        )::Nothing
    function f(old_vector::AbstractVector)::Vector{Any}
        new_vector = Vector{Any}(length(old_vector))
        for i = 1:length(old_vector)
            old_vector_ith_element = old_vector[i]
            if DataFrames.ismissing(old_vector_ith_element)
                new_vector[i] = DataFrames.missing
            elseif old_vector_ith_element == value
                new_vector[i] = DataFrames.missing
            else
                new_vector[i] = old_vector_ith_element
            end
        end
        return new_vector
    end
    transform_columns!(df, f, column_names)
    return nothing
end

function convert_value_to_missing!(
        df::DataFrames.AbstractDataFrame,
        value,
        column_name::Symbol,
        )::Nothing
    convert_value_to_missing!(df, value, Symbol[column_name])
    return nothing
end

##### End of file
