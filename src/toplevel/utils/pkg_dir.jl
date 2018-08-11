##### Beginning of file

"""
"""
function pkg_dir end

function pkg_dir()::String
    pkg_dir_filename = @__FILE__ # PredictMD/src/toplevel/utils/pkg_dir.jl
    utils_dir = dirname(pkg_dir_filename) # PredictMD/src/toplevel/utils
    toplevel_dir = dirname(utils_dir) # PredictMD/src/toplevel
    src_dir = dirname(toplevel_dir) # PredictMD/src
    predictmd_root_directory = dirname(src_dir) # PredictMD
    return predictmd_root_directory
end

function pkg_dir(parts...)::String
    predictmd_root_directory = pkg_dir()
    result = joinpath(predictmd_root_directory, parts...)
    return result
end

##### End of file
