##### Beginning of file

"""
"""
function pkg_dir end

function pkg_dir()::String
    pkg_dir_filename = @__FILE__ # PredictMD/src/base/pkg_dir.jl
    base_dir = dirname(pkg_dir_filename) # PredictMD/src/base
    src_dir = dirname(base_dir) # PredictMD/src
    predictmd_root_directory = dirname(src_dir) # PredictMD
    return predictmd_root_directory
end

function pkg_dir(parts...)::String
    predictmd_root_directory = pkg_dir()
    result = joinpath(predictmd_root_directory, parts...)
    return result
end

##### End of file
