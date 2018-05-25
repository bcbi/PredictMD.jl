function filename_extension(filename::AbstractString)
    result = lowercase(strip(splitext(filename)[2]))
    return result
end

function something_exists_at_path(path::AbstractString)
    if ispath(path)
        return true
    elseif isfile(path)
        return true
    elseif isblockdev(path)
        return true
    elseif ischardev(path)
        return true
    elseif isdir(path)
        return true
    elseif isfifo(path)
        return true
    elseif islink(path)
        return true
    elseif ismount(path)
        return true
    elseif issocket(path)
        return true
    else
        return false
    end
end
