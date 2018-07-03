struct JuliaVersionRequirement
end

struct PredictMDVersionRequirement
end

struct PackageVersionRequirement
end

function require_version(package::Symbol, varargs...)
    if lowercase(strip(string(package))) == "julia"
        result = require_version(
            JuliaVersionRequirement,
            varargs...
            )
    elseif lowercase(strip(string(package))) == "predictmd"
        result = require_version(
            PredictMDVersionRequirement,
            varargs...
            )
    else
        result = require_version(
            PackageVersionRequirement,
            package,
            varargs...
            )
    end
    return result
end

function require_version(
        ::Type{JuliaVersionRequirement},
        varargs...
        )
    current_version = Base.VERSION
    answer = does_current_version_meet_requirements(
        current_version,
        varargs...
        )
    if !answer
        error(
            string(
                "Current Julia version (",
                current_version,
                ") does not match the user-specified version requirements.",
                )
            )
    end
    return nothing
end

function require_version(
        ::Type{PredictMDVersionRequirement},
        varargs...
        )
    current_version = version()
    answer = does_current_version_meet_requirements(
        current_version,
        varargs...
        )
    if !answer
        error(
            string(
                "Current PredictMD version (",
                current_version,
                ") does not match the user-specified version requirements.",
                )
            )
    end
    return nothing
end

function require_version(
        ::Type{PackageVersionRequirement},
        package::Symbol,
        varargs...
        )
    package_name_string = strip(string(package))
    current_version = Pkg.installed(package_name_string)
    # if is_nothing(current_version)
    #     error(
    #         string(
    #             "Package \"",
    #             package,
    #             "\" is not installed.",
    #             )
    #         )
    # end
    answer = does_current_version_meet_requirements(
        current_version,
        varargs...
        )
    if !answer
        error(
            string(
                "Current \"",
                package,
                "\" version (",
                current_version,
                ") does not match the user-specified version requirements.",
                )
            )
    end
    return nothing
end

function does_current_version_meet_requirements(
        current_version::VersionNumber,
        min_version,
        )
    min_version = VersionNumber(min_version)
    result = min_version <= current_version
    return result
end

function does_current_version_meet_requirements(
        current_version::VersionNumber,
        min_version,
        max_version,
        )
    min_version = VersionNumber(min_version)
    max_version = VersionNumber(max_version)
    result = min_version <= current_version <= max_version
    return result
end
