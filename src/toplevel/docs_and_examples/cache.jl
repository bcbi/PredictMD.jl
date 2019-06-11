function cache_to_path!(
        ;
        from::AbstractVector{<:AbstractString},
        to::AbstractVector{<:AbstractString},
        cache = joinpath(homedir(), "predictmd_cache_travis"),
        )::Nothing
    cache_path_src::String = joinpath(cache, from...)
    path_dst::String = joinpath(to...)
    mkpath(cache_path_src)
    mkpath(path_dst)
    @debug("cache_path_src: ", cache_path_src,)
    @debug("path_dst: ", path_dst,)
    cp(
        cache_path_src,
        path_dst;
        force = true,
        )
    return nothing
end

function path_to_cache!(
        ;
        from::AbstractVector{<:AbstractString},
        to::AbstractVector{<:AbstractString},
        cache = joinpath(homedir(), "predictmd_cache_travis"),
        )::Nothing
    path_src::String = joinpath(from...)
    cache_path_dst::String = joinpath(cache, to...)
    mkpath(path_src)
    mkpath(cache_path_dst)
    @debug("path_src: ", path_src,)
    @debug("cache_path_dst: ", cache_path_dst,)
    cp(
        path_src,
        cache_path_dst;
        force = true,
        )
    return nothing
end
