##### Beginning of file

"""
"""
function dir(parts...)
    predictmd_root_dir = dirname( # PredictMD/
        dirname( # PredictMD/src/
            dirname( # PredictMD/src/./
                dirname( # PredictMD/src/./toplevel/
                    dirname( # PredictMD/src/./toplevel/utils/
                        @__FILE__ # PredictMD/src/./toplevel/utils/pkg_dir.jl
                        )
                    )
                )
            )
        )
    result = joinpath(predictmd_root_dir, parts...)
    return result
end

##### End of file
