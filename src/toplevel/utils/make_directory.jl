##### Beginning of file

function directory(parts...)
    if is_ci_or_runtests_or_docs_or_examples() && !is_travis_ci()
        true_path = get_temp_directory()
    else
        true_path = joinpath(parts...)
    end
    Base.Filesystem.mkpath(true_path)
    return true_path
end

function get_temp_directory(
        env::Associative = ENV,
        environment_variable::AbstractString = "__PREDICTMDTEMPDIRECTORY__",
    )
    if haskey(env, environment_variable)
        result = env[environment_variable]
    else
        result = create_new_temp_directory()
    end
    Base.mkpath(result)
    if !haskey(env, environment_variable)
        env[environment_variable] = result
    end
    return result
end

function create_new_temp_directory()
    result = Base.joinpath(Base.mktempdir(), "PREDICTMDTEMPDIRECTORY")
    Base.mkpath(result)
    info(string("DEBUG: Created new PredictMD temp directory: \"", result))
    return result
end

##### End of file
