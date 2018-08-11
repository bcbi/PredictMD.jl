##### Beginning of file

function project_directory(parts...)
    if is_ci_or_runtests_or_docs_or_examples() && !is_travis_ci_on_apple()
        true_path = get_temp_directory()
    else
        true_path = joinpath(parts...)
    end
    mkpath(true_path)
    return true_path
end

function get_temp_directory(
        a::Associative = ENV,
        environment_variable::AbstractString = "__PREDICTMDTEMPDIRECTORY__",
    )
    if haskey(a, environment_variable)
        result = a[environment_variable]
    else
        result = create_new_temp_directory()
        a[environment_variable] = result
    end
    mkpath(result)
    return result
end

function create_new_temp_directory()
    result = joinpath(mktempdir(), "PREDICTMDTEMPDIRECTORY")
    mkpath(result)
    info(string("DEBUG: Created new PredictMD temp directory: \"", result))
    return result
end

##### End of file
