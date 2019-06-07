##### Beginning of file

function print_welcome_message()::Nothing
    predictmd_version::VersionNumber = version()
    predictmd_version_codename::String = version_codename()
    predictmd_pkgdir::String = package_directory()
    @info(
        string(
            "This is PredictMD, version $(predictmd_version), ",
            "code name \"$(predictmd_version_codename)\"",
            )
        )
    @info("For help, please visit https://predictmd.net")
    @debug("PredictMD package directory: $(predictmd_pkgdir)")
    return nothing
end

##### End of file
