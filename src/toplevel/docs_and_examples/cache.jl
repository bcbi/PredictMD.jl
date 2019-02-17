##### Beginning of file

function cache_to_homedir!(
        parts...;
        cache = joinpath(homedir(), "predictmd_cache_travis"),
        )::Nothing
    cache_path_src::String = joinpath(cache, parts...)
    homedir_path_dst::String = joinpath(homedir(), parts...)
    mkpath(dirname(homedir_path_dst))
    cp(
        cache_path_src,
        homedir_path_dst;
        force = true,
        )
    return nothing
end

function homedir_to_cache!(
        parts...;
        cache = joinpath(homedir(), "predictmd_cache_travis"),
        )::Nothing
    homedir_path_src::String = joinpath(homedir(), parts...)
    cache_path_dst::String = joinpath(cache, parts...)
    mkpath(dirname(cache_path_dst))
    cp(
        homedir_path_src,
        cache_path_dst;
        force = true,
        )
    return nothing
end

##### End of file
