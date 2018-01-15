function istravisci(a::Associative)
    result = (get(a, "CI", "") == "true") &&
        (get(a, "TRAVIS", "") == "true") &&
            (get(a, "CONTINUOUS_INTEGRATION", "") == "true")
    return result
end
