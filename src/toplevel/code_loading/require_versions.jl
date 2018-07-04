##### Beginning of file

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
        version_requirements::AbstractVector,
        )
    num_version_requirements = length(version_requirements)
    if num_version_requirements == 0
        answer = true
    else
        if iseven(num_version_requirements)
            num_intervals = Int((num_version_requirements)/(2))
            answer_for_each_interval = Vector{Bool}(num_intervals)
            for interval = (1):(num_intervals)
                answer_for_each_interval[interval] =
                    does_current_version_meet_requirements(
                        current_version,
                        version_requirements[2*interval - 1],
                        version_requirements[2*interval],
                        )
            end
        else
            num_intervals = Int((num_version_requirements+1)/(2))
            answer_for_each_interval = Vector{Bool}(num_intervals)
            for interval = (1):(num_intervals - 1)
                answer_for_each_interval[interval] =
                    does_current_version_meet_requirements(
                        current_version,
                        version_requirements[2*interval - 1],
                        version_requirements[2*interval],
                        )
            end
            answer_for_each_interval[num_intervals] =
                does_current_version_meet_requirements(
                    current_version,
                    version_requirements[2*interval - 1],
                    )
        end
        answer = any(answer_for_each_interval)
    end
    return answer
end

function does_current_version_meet_requirements(
        current_version::VersionNumber,
        min_version,
        )
    min_version = VersionNumber(min_version)
    answer = min_version <= current_version
    return answer
end

function does_current_version_meet_requirements(
        current_version::VersionNumber,
        min_version,
        max_version,
        )
    min_version = VersionNumber(min_version)
    max_version = VersionNumber(max_version)
    answer = min_version <= current_version < max_version
    return answer
end

##### End of file
