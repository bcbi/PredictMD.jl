##### Beginning of file

import Pkg # stdlib

function _version_codename_string(x::_TomlFile)::String
    toml_file_parsed::Dict{String, Any} = _parse_toml_file(x)
    version_codename_string::String = toml_file_parsed["version_codename"]
    return version_codename_string
end

function _version_codename_string()::String
    predictmd_toml_file::_TomlFile = _TomlFile(
        package_directory("Project.toml")
        )
    result_version_codename_string::String = _version_codename_string(
        predictmd_toml_file
        )
    return result_version_codename_string
end

function _version_codename_string(m::Method)::String
    m_package_directory::String = package_directory(m)
    m_toml_file::_TomlFile = _TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    result_version_codename_string::String = _version_codename_string(
        m_toml_file
        )
    return result_version_codename_string
end

function _version_codename_string(f::Function)::String
    m_package_directory::String = package_directory(f)
    m_toml_file::_TomlFile = _TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    result_version_codename_string::String = _version_codename_string(
        m_toml_file
        )
    return result_version_codename_string
end

function _version_codename_string(f::Function, types::Tuple)::String
    m_package_directory::String = package_directory(f, types)
    m_toml_file::_TomlFile = _TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    result_version_codename_string::String = _version_codename_string(
        m_toml_file
        )
    return result_version_codename_string
end

function _version_codename_string(m::Module)::String
    m_package_directory::String = package_directory(m)
    m_toml_file::_TomlFile = _TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    result_version_codename_string::String = _version_codename_string(
        m_toml_file
        )
    return result_version_codename_string
end

"""
    version_codename()::String

Return the version code name of PredictMD.
"""
function version_codename()::String
    result_version_codename_string::String = _version_codename_string()
    return result_version_codename_string
end

"""
    version_codename(m::Method)::String

If method `m`
is part of a Julia package, returns the version code name of that package.

If method `m`
is not part of a Julia package, throws an error.
"""
function version_codename(m::Method)::String
    result_version_codename_string::String = _version_codename_string(m)
    return result_version_codename_string
end

"""
    version_codename(f::Function)::String

If function `f`
is part of a Julia package, returns the version code name of
that package.

If function `f`
is not part of a Julia package, throws an error.
"""
function version_codename(f::Function)::String
    result_version_codename_string::String = _version_codename_string(f)
    return result_version_codename_string
end

"""
    version_codename(f::Function, types::Tuple)::String

If function `f` with type signature `types`
is part of a Julia package, returns the version code name of
that package.

If function `f` with type signature `types`
is not part of a Julia package, throws an error.
"""
function version_codename(f::Function, types::Tuple)::String
    result_version_codename_string::String = _version_codename_string(
        f,
        types,
        )
    return result_version_codename_string
end

"""
    version_codename(m::Module)::String

If module `m` is part of a Julia package, returns the version code name of
that package.

If module `m` is not part of a Julia package, throws an error.
"""
function version_codename(m::Module)::String
    result_version_codename_string::String = _version_codename_string(m)
    return result_version_codename_string
end

##### End of file
