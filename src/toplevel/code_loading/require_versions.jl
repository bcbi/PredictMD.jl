##### Beginning of file

function require_julia_version(
        varargs...
        )::VersionNumber
    current_julia_version = Base.VERSION
    version_meets_requirements = does_current_version_meet_requirements(
        current_julia_version,
        collect(varargs),
        )
    if !version_meets_requirements
        error(
            string(
                "Current Julia version (",
                current_julia_version,
                ") does not match the ",
                "user-specified version requirements.",
                )
            )
    end
    return current_julia_version
end

function require_predictmd_version(
        ::Type{PredictMDVersionRequirement},
        varargs...
        )::VersionNumber
    current_predictmd_version = version()
    version_meets_requirements = does_current_version_meet_requirements(
        current_predictmd_version,
        collect(varargs),
        )
    if !version_meets_requirements
        error(
            string(
                "Current PredictMD version (",
                current_predictmd_version,
                ") does not match the ",
                "user-specified version requirements.",
                )
            )
    end
    return current_predictmd_version
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
                    version_requirements[2*num_intervals - 1],
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
