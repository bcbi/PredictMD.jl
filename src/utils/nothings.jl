function delete_nothings!(x::AbstractVector)
    filter!(e->e≠nothing, x)
    return x
end
