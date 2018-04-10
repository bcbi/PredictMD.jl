const VERSION = try
    convert(VersionNumber, "v0.11.0-DEV")
catch e
    warn("while creating AluthgeSinhaBase.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
