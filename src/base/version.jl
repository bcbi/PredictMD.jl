const VERSION = try
    convert(VersionNumber, "v0.11.0")
catch e
    warn("while creating PredictMD.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
