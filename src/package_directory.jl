##### Beginning of file

function _is_filesystem_root(path::AbstractString)::Bool
    path::String = abspath(strip(path))
    if path == dirname(path)
        return true
    else
        return false
    end
end

function _is_package_directory(path::AbstractString)::Bool
    path::String = abspath(strip(path))
    if isfile(joinpath(path, "Project.toml"))
        return true
    else
        return false
    end
end

function _find_package_directory(path::AbstractString)::String
    path::String = abspath(strip(path))
    if _is_package_directory(path)
        return path
    elseif _is_filesystem_root(path)
        error(string("Could not find the Project.toml file"))
    else
        result = _find_package_directory(dirname(path))
        return result
    end
end

"""
    package_directory()::String

Return the PredictMD package directory.
"""
function package_directory()::String
    result::String = _find_package_directory(abspath(strip(@__FILE__)))
    return result
end

function _location(m::Method)::String
    result::String = abspath(first(functionloc(m)))
    return result
end

function _location(f::Function)::String
    result::String = abspath(first(functionloc(f)))
    return result
end

function _location(f::Function, types::Tuple)::String
    result::String = abspath(first(functionloc(f, types)))
    return result
end

function _location(m::Module)::String
    result::String = abspath(_location(getfield(m, :eval)))
    return result
end

"""
    package_directory(parts...)::String

Equivalent to `abspath(joinpath(abspath(package_directory()), parts...))`.
"""
function package_directory(parts...)::String
    result::String = abspath(joinpath(abspath(package_directory()), parts...))
    return result
end

"""
    package_directory(m::Method)::String

If method `m`
is part of a Julia package, returns the package root directory.

If method `m`
is not part of a Julia package, throws an error.
"""
function package_directory(m::Method)::String
    m_module_directory::String = abspath(_location(m))
    m_package_directory::String = abspath(
        _find_package_directory(m_module_directory)
        )
    return m_package_directory
end

# """
#     package_directory(m::Method, parts...)::String
#
# Equivalent to
# `result = abspath(joinpath(abspath(package_directory(m)), parts...))`.
# """
# function package_directory(m::Method, parts...)::String
#     result::String = abspath(joinpath(abspath(package_directory(m)), parts...))
#     return result
# end

"""
    package_directory(f::Function)::String

If function `f`
is part of a Julia package, returns the package root directory.

If function `f`
is not part of a Julia package, throws an error.
"""
function package_directory(f::Function)::String
    m_module_directory::String = abspath(_location(f))
    m_package_directory::String = abspath(
        _find_package_directory(m_module_directory)
        )
    return m_package_directory
end

# """
#     package_directory(f::Function, parts...)::String
#
# Equivalent to
# `result = abspath(joinpath(abspath(package_directory(f)), parts...))`.
# """
# function package_directory(f::Function, parts...)::String
#     result::String = abspath(joinpath(abspath(package_directory(f)), parts...))
#     return result
# end

"""
    package_directory(f::Function, types::Tuple)::String

If function `f` with type signature `types`
is part of a Julia package, returns the package root directory.

If function `f` with type signature `types`
is not part of a Julia package, throws an error.
"""
function package_directory(f::Function, types::Tuple)::String
    m_module_directory::String = abspath(_location(f, types))
    m_package_directory::String = abspath(
        _find_package_directory(m_module_directory)
        )
    return m_package_directory
end

# """
#     package_directory(f::Function, types::Tuple, parts...)::String
#
# Equivalent to
# `result = abspath(joinpath(abspath(package_directory(f, types)), parts...))`.
# """
# function package_directory(f::Function, types::Tuple, parts...)::String
#     result::String = abspath(joinpath(abspath(package_directory(f, types)), parts...))
#     return result
# end

"""
    package_directory(m::Module)::String

If module `m`
is part of a Julia package, returns the package root directory.

If module `m`
is not part of a Julia package, throws an error.
"""
function package_directory(m::Module)::String
    m_module_directory::String = abspath(_location(m))
    m_package_directory::String = abspath(
        _find_package_directory(m_module_directory)
        )
    return m_package_directory
end

"""
    package_directory(m::Module, parts...)::String

Equivalent to
`result = abspath(joinpath(abspath(package_directory(m)), parts...))`.
"""
function package_directory(m::Module, parts...)::String
    result::String = abspath(joinpath(abspath(package_directory(m)), parts...))
    return result
end

##### End of file
