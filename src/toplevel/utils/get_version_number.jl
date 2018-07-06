##### Beginning of file

"""
"""
version_julia6() = PredictMD.VERSION_NUMBER

"""
"""
version() = version_julia6()

"""
"""
function version_julia7()
    version_number = try
        get_version_number_jl_file_name = @__FILE__
        utils_directory = dirname(get_version_number_jl_file_name)
        toplevel_directory = dirname(utils_directory)
        src_directory = dirname(toplevel_directory)
        PredictMD_directory = dirname(src_directory)
        project_toml_file_name = joinpath(
            PredictMD_directory,
            "Project.toml",
            )
        project_toml_file_contents = read(project_toml_file_name, String)
        project_toml_file_parsed = Pkg.TOML.parse(project_toml_file_contents)
        version_string = project_toml_file_parsed["version"]
        convert(VersionNumber, version_string)
    catch e
        warn(string("Ignoring error: ", e,))
        VersionNumber(0)
    end

    return version_number
end

function next_major_version(
        current_version::VersionNumber;
        add_trailing_minus::Bool = false,
        )
    if add_trailing_minus
        trailing_minus = "-"
    else
        trailing_minus = ""
    end
    result = VersionNumber(
        string(
            current_version.major + 1,
            ".",
            0,
            ".",
            0,
            trailing_minus,
            )
        )
    return result
end

function next_minor_version(
        current_version::VersionNumber;
        add_trailing_minus::Bool = false,
        )
    if add_trailing_minus
        trailing_minus = "-"
    else
        trailing_minus = ""
    end
    result = VersionNumber(
        string(
            current_version.major,
            ".",
            current_version.minor + 1,
            ".",
            0,
            trailing_minus,
            )
        )
    return result
end

function next_patch_version(
        current_version::VersionNumber;
        add_trailing_minus::Bool = false,
        )
    if add_trailing_minus
        trailing_minus = "-"
    else
        trailing_minus = ""
    end
    result = VersionNumber(
        string(
            current_version.major,
            ".",
            current_version.minor,
            ".",
            current_version.patch + 1,
            trailing_minus,
            )
        )
    return result
end

##### End of file
