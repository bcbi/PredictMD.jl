"""
"""
function is_one_to_one(x::AbstractDict)::Bool
    if (length(keys(x)) == length(unique(keys(x)))) &&
            (length(values(x)) == length(unique(values(x))))
        return true
    else
        return false
    end
end

"""
"""
function inverse(x::AbstractDict)::Dict
    if !is_one_to_one(x)
        error(
            string(
                "Input directory is not one-to-one."
                )
            )
    end

    keys_array = fix_type(collect(keys(x)))
    values_array = fix_type(collect(values(x)))


    key_type=eltype(keys_array)
    value_type=eltype(values_array)

    result = Dict{value_type, key_type}()

    for i = 1:length(keys_array)
        k = keys_array[i]
        v = values_array[i[]]
        result[v] = k
    end

    result_typefixed = fix_type(result)

    return result_typefixed
end

