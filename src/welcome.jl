##### Beginning of file

function _print_welcome_message()::Nothing
    predictmd_version::VersionNumber = version()
    predictmd_pkgdir::String = package_directory()
    @info(string("This is PredictMD, version ",predictmd_version,),)
    @info(string("For help, please visit https://predictmd.net",),)
    @debug(string("PredictMD package directory: ",predictmd_pkgdir,),)
    return nothing
end

##### End of file
