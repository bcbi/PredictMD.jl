##### Beginning of file

"""
"""
function fix_vector_type(x::AbstractVector)
    new_vector = [x...]
    return new_vector
end

fix_vector_type(x::Void) = x

"""
"""
function fix_array_type(x::AbstractArray)
    new_array = reshape([x...], size(x))
    return new_array
end

fix_array_type(x::Void) = x

##### End of file
