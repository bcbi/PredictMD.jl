const VERSIONSTRING = "0.3.1+dev"

const VERSIONNUMBER = try
    convert(VersionNumber, strip(VERSIONSTRING))
catch e
    warn("while creating AluthgeSinhaBase.VERSION, ignoring error $(e)")
    VersionNumber(0)
end
