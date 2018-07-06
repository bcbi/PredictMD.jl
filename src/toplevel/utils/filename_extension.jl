##### Beginning of file

"""
"""
function filename_extension(filename::AbstractString)
    result = lowercase(strip(splitext(strip(filename))[2]))
    return result
end

##### End of file
