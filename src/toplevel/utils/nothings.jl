"""
"""
function delete_nothings!(x::AbstractVector)
    filter!(e->e≠nothing, x)
    return x
end

is_nothing(x::Void) = true
is_nothing(x::Any) = false

"""
"""
is_nothing
