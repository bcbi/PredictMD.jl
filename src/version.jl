import Pkg # stdlib

struct TomlFile
    filename::String
    function TomlFile(path::String)::TomlFile
        path::String = abspath(strip(path))
        if isfile(path)
            result::TomlFile = new(path)
            return result
        else
            error("File does not exist")
        end
    end
end

function parse_toml_file(x::TomlFile)::Dict{String, Any}
    toml_file_filename::String = x.filename
    toml_file_text::String = read(toml_file_filename, String)
    toml_file_parsed::Dict{String, Any} = Pkg.TOML.parse(toml_file_text)
    return toml_file_parsed
end

function version_string(x::TomlFile)::String
    toml_file_parsed::Dict{String, Any} = parse_toml_file(x)
    version_string::String = toml_file_parsed["version"]
    return version_string
end

function version_string()::String
    predictmd_toml_file::TomlFile = TomlFile(
        package_directory("Project.toml")
        )
    resultversion_string::String = version_string(predictmd_toml_file)
    return resultversion_string
end

function version_string(m::Method)::String
    m_package_directory::String = package_directory(m)
    m_toml_file::TomlFile = TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    resultversion_string::String = version_string(m_toml_file)
    return resultversion_string
end

function version_string(f::Function)::String
    m_package_directory::String = package_directory(f)
    m_toml_file::TomlFile = TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    resultversion_string::String = version_string(m_toml_file)
    return resultversion_string
end

function version_string(f::Function, types::Tuple)::String
    m_package_directory::String = package_directory(f, types)
    m_toml_file::TomlFile = TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    resultversion_string::String = version_string(m_toml_file)
    return resultversion_string
end

function version_string(m::Module)::String
    m_package_directory::String = package_directory(m)
    m_toml_file::TomlFile = TomlFile(
        joinpath(m_package_directory, "Project.toml")
        )
    resultversion_string::String = version_string(m_toml_file)
    return resultversion_string
end

"""
    version()::VersionNumber

Return the version number of PredictMD.
"""
function version()::VersionNumber
    resultversion_string::String = version_string()
    result_versionnumber::VersionNumber = VersionNumber(resultversion_string)
    return result_versionnumber
end

"""
    version(m::Method)::VersionNumber

If method `m`
is part of a Julia package, returns the version number of that package.

If method `m`
is not part of a Julia package, throws an error.
"""
function version(m::Method)::VersionNumber
    resultversion_string::String = version_string(m)
    result_versionnumber::VersionNumber = VersionNumber(resultversion_string)
    return result_versionnumber
end

"""
    version(f::Function)::VersionNumber

If function `f`
is part of a Julia package, returns the version number of
that package.

If function `f`
is not part of a Julia package, throws an error.
"""
function version(f::Function)::VersionNumber
    resultversion_string::String = version_string(f)
    result_versionnumber::VersionNumber = VersionNumber(resultversion_string)
    return result_versionnumber
end

"""
    version(f::Function, types::Tuple)::VersionNumber

If function `f` with type signature `types`
is part of a Julia package, returns the version number of
that package.

If function `f` with type signature `types`
is not part of a Julia package, throws an error.
"""
function version(f::Function, types::Tuple)::VersionNumber
    resultversion_string::String = version_string(f, types)
    result_versionnumber::VersionNumber = VersionNumber(resultversion_string)
    return result_versionnumber
end

"""
    version(m::Module)::VersionNumber

If module `m` is part of a Julia package, returns the version number of
that package.

If module `m` is not part of a Julia package, throws an error.
"""
function version(m::Module)::VersionNumber
    resultversion_string::String = version_string(m)
    result_versionnumber::VersionNumber = VersionNumber(resultversion_string)
    return result_versionnumber
end
