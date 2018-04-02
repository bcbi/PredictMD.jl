const VERSION = try
    convert(VersionNumber, "v0.9.0")
catch e
    warn("while creating AluthgeSinhaBase.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
