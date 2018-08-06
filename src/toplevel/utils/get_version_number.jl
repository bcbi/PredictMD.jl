##### Beginning of file

"""
"""
function version end

function version()::VersionNumber
    if Base.VERSION < VersionNumber("0.7.0")
        result = version_julia6()
    else
        result = version_julia7()
    end
    return result
end

# version()::VersionNumber = version_julia6()

function version_julia6()::VersionNumber
    result = PREDICTMD_VERSION
    return result
end

function version_julia7()::VersionNumber
    version_number = try
        predictmd_project_toml_file_name = predictmd_package_directory(
            "Project.toml",
            )
        predictmd_project_toml_file_contents = read(
            predictmd_project_toml_file_name,
            String,
            )
        predictmd_project_toml_file_parsed = Pkg.TOML.parse(
            predictmd_project_toml_file_contents,
            )
        version_string = predictmd_project_toml_file_parsed["version"]
        convert(VersionNumber, version_string)
    catch e
        warn(
            string(
                "While attempting to parse Project.toml ",
                "(in order to obtain PredictMD version number), ",
                "encountered error: \"",
                e,
                "\".",
                )
            )
        VersionNumber(0)
    end
    return version_number
end

"""
"""
function next_major_version(
        current_version::VersionNumber;
        add_trailing_minus::Bool = false,
        )::VersionNumber
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

"""
"""
function next_minor_version(
        current_version::VersionNumber;
        add_trailing_minus::Bool = false,
        )::VersionNumber
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
        )::VersionNumber
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
