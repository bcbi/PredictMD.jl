"""
"""
function fix_type
end

fix_type(x::Any, T) = convert(T, fix_type(x))

fix_type(x::Any) = x

function fix_type(x::AbstractArray)::Array
    result = reshape(
        [[fix_type(element) for element in x]...],
        size(x),
        )
    return result
end

function fix_type(
        x::AbstractDict;
        default_key_type::Type=Any,
        default_value_type::Type=Any,
        )::Dict
    if length(x) == 0
        result = Dict{default_key_type, default_value_type}()
    else
        keys_eltype=eltype( fix_type( collect( keys(x) ) ) )
        values_eltype=eltype( fix_type( collect( values(x) ) ) )
        result = Dict{keys_eltype, values_eltype}()
        for k in keys(x)
            result[k] = x[k]
        end
    end
    return result
end


