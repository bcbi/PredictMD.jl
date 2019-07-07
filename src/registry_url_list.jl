function registry_url_list()::Vector{String}
    registry_url_list_raw::Vector{String} = String[
        "https://github.com/JuliaRegistries/General.git",
        "https://github.com/bcbi/BCBIRegistry.git",
        ]
    registry_url_list::Vector{String} = strip.(registry_url_list_raw)
    return registry_url_list
end
