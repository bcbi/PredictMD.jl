"""
"""
function fix_dict_type(
        x::Associative;
        default_key_type::Type = Symbol,
        default_value_type::Type = Any,
        )
    if length(x) == 0
        new_dict = Dict{default_key_type, default_value_type}()
    else
        keys_eltype = eltype( fix_vector_type( collect( keys(x) ) ) )
        values_eltype = eltype( fix_vector_type( collect( values(x) ) ) )
        new_dict = Dict{keys_eltype, values_eltype}()
        for k in keys(x)
            new_dict[k] = x[k]
        end
    end
    return new_dict
end

fix_dict_type(x::Void) = x
