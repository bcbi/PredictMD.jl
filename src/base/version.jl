const VERSION = try
    convert(VersionNumber, "v0.12.0-DEV")
catch e
    warn("while creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
