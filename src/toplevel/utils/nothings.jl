##### Beginning of file

"""
"""
function delete_nothings!(x::AbstractVector)::Nothing
    filter!(e->e≠nothing, x)
    return nothing
end

is_nothing(x::Nothing)::Bool = true
is_nothing(x::Any)::Bool = false

"""
"""
is_nothing

##### End of file
