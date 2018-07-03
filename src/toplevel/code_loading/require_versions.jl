abstract type AbstractVersionRequirement end

struct JuliaVersionRequirement <: AbstractVersionRequirement
end

struct PredictMDVersionRequirement <: AbstractVersionRequirement
end

struct PackageVersionRequirement <: AbstractVersionRequirement
end

function require_version(package::Symbol, varargs...)
    package_name_string_lowercase = lowercase(strip(string(package)))
    if package_name_string_lowercase == "julia"
        result = require_version(
            JuliaVersionRequirement,
            varargs...
            )
    elseif package_name_string_lowercase == "predictmd"
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
    version_meets_requirements = does_current_version_meet_requirements(
        current_version,
        varargs...
        )
    if !version_meets_requirements
        error(
            string(
                "Current Julia version (",
                current_version,
                ") does not match the ",
                "user-specified version requirements.",
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
    version_meets_requirements = does_current_version_meet_requirements(
        current_version,
        varargs...
        )
    if !version_meets_requirements
        error(
            string(
                "Current PredictMD version (",
                current_version,
                ") does not match the ",
                "user-specified version requirements.",
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
    version_meets_requirements = does_current_version_meet_requirements(
        current_version,
        varargs...
        )
    if !version_meets_requirements
        error(
            string(
                "Current \"",
                package,
                "\" version (",
                current_version,
                ") does not match the ",
                "user-specified version requirements.",
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
