##### Beginning of file

function project_directory(parts...)
    if is_ci_or_runtests_or_docs_or_examples() && !is_travis_ci()
        true_path = get_temp_directory()
    else
        true_path = joinpath(parts...)
    end
    try
        mkpath(true_path)
    catch
    end
    return true_path
end

function get_temp_directory(
        a::AbstractDict = ENV,
        environment_variable::AbstractString = "__PREDICTMDTEMPDIRECTORY__",
    )
    if haskey(a, environment_variable)
        result = a[environment_variable]
    else
        result = create_new_temp_directory()
        a[environment_variable] = result
    end
    try
        mkpath(result)
    catch
    end
    return result
end

function create_new_temp_directory()
    result = joinpath(mktempdir(), "PREDICTMDTEMPDIRECTORY")
    try
        mkpath(result)
    catch
    end
    @debug(string("Created new PredictMD temp directory: \"", result))
    return result
end

##### End of file
