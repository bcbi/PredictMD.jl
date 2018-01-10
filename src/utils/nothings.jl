function deletenothings!(x::AbstractVector)
    filter!(e->e≠nothing, x)
    return x
end
