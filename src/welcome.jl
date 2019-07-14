import Pkg

function print_welcome_message(a::AbstractDict = ENV)::Nothing
    predictmd_version::VersionNumber = version()
    predictmd_version_codename::String = version_codename()
    predictmd_pkgdir::String = package_directory()
    predictmdapi_version::VersionNumber = api_version()
    predictmdapi_pkgdir::String = api_package_directory()
    if !_suppress_welcome_message(a)
        @info(
            string(
                "This is PredictMD, version $(predictmd_version), ",
                "code name \"$(predictmd_version_codename)\"",
                )
            )
        @info("For help, please visit https://predictmd.net")
        @debug("PredictMD package directory: $(predictmd_pkgdir)")
        @debug("PredictMDAPI version: $(predictmdapi_version)")
        @debug("PredictMDAPI package directory: $(predictmdapi_pkgdir)")
    end
    return nothing
end

function _suppress_welcome_message(a::AbstractDict = ENV)::Bool
    return get(a, "SUPPRESS_PREDICTMD_WELCOME_MESSAGE", "false") == "true"
end
