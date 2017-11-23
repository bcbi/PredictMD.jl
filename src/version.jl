const VERSION_STRING = "0.2+dev"

const VERSION = try
    convert(VersionNumber, strip(VERSION_STRING))
catch e
    warn("while creating AluthgeSinhaBase.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
