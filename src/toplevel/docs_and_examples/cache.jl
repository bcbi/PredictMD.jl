function cp_files_and_directories(
        src::AbstractString,
        dst::AbstractString;
        overwrite::Bool,
        )::Nothing
    if isdir(src)
        # @debug("src is dir", src, isdir(src))
        mkpath(dst)
        for item in readdir(src)
            # @debug("item: ", item)
            item_src_path = joinpath(src, item)
            item_dst_path = joinpath(dst, item)
            cp_files_and_directories(
                item_src_path,
                item_dst_path;
                overwrite = overwrite,
                )
        end
    elseif isfile(src)
        # @debug("src is file", src, isfile(src))
        # @debug("dst: ", dst, isfile(dst), ispath(dst))
        if overwrite || !ispath(dst)
            rm(dst; force = true, recursive = true,)
            cp(src, dst)
            # @debug("copied file", src, dst)
        end
    else
        # @error("weird src", src)
    end
    return nothing
end

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
    cp_files_and_directories(
        cache_path_src,
        path_dst;
        overwrite = false,
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
    cp_files_and_directories(
        path_src,
        cache_path_dst;
        overwrite = true,
        )
    return nothing
end
