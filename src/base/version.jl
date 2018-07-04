##### Beginning of file

const VERSION_NUMBER = try
    convert(VersionNumber, "v0.19.0-DEV")
catch e
    warn("While creating PredictMD.VERSION_NUMBER, ignoring error $(e)")
    VersionNumber(0)
end

"""
    VERSION_NUMBER
"""
VERSION_NUMBER

##### End of file
