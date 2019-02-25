##### Beginning of file

function _registry_url_list()::Vector{String}
    registry_url_list_raw::Vector{String} = String[
        "https://github.com/JuliaRegistries/General",
        "https://github.com/bcbi/PredictMDRegistry",
        ]
    registry_url_list::Vector{String} = strip.(registry_url_list_raw)
    return registry_url_list
end

##### End of file
