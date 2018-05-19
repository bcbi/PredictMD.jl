const VERSION = try
    convert(VersionNumber, "v0.13.0-DEV")
catch e
    warn("WARN While creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
