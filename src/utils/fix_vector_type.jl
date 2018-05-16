function fix_vector_type(x::AbstractVector)
    new_vector = [x...]
    return new_vector
end

fix_vector_type(x::Void) = x
