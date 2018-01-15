const VERSIONSTRING = "0.7-DEV"

const VERSIONNUMBER = try
    convert(VersionNumber, strip(VERSIONSTRING))
catch e
    warn("while creating AluthgeSinhaBase.VERSION, ignoring error $(e)")
    VersionNumber(0)
end

const VERSION = VERSIONNUMBER
