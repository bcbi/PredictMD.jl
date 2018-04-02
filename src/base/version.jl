const VERSIONSTRING = "v0.9.0"

const VERSIONNUMBER = try
    convert(VersionNumber, strip(VERSIONSTRING))
catch e
    warn("while creating AluthgeSinhaBase.VERSION, ignoring error $(e)")
    VersionNumber(0)
end

const VERSION = VERSIONNUMBER
