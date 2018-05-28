function is_debug(a::Associative = ENV)
    result = lowercase(strip(get(a, "DEBUG", ""))) == "true" ||
        lowercase(strip(get(a, "PREDICTMD_DEBUG", ""))) == "true" ||
        lowercase(strip(get(a, "PREDICTMDDEBUG", ""))) == "true" ||
        lowercase(strip(get(a, "DEBUG_PREDICTMD", ""))) == "true" ||
        lowercase(strip(get(a, "DEBUGPREDICTMD", ""))) == "true"
    return result
end
