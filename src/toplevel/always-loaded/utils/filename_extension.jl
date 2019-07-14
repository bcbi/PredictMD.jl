"""
"""
function filename_extension(filename::AbstractString)
    result = lowercase(strip(splitext(strip(filename))[2]))
    return result
end

