##### Beginning of file

function print_welcome_message()::Void
    predictmd_version::VersionNumber = version()
    predictmd_pkgdir::String = pkg_dir()
    info(string("This is PredictMD, version ", predictmd_version, ))
    info(string("For help, please visit https://www.predictmd.net", ))
    # @debug(string("PredictMD package directory: ", predictmd_pkgdir, ))
    return nothing
end

##### End of file
