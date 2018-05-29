"""
"""
function is_travis_ci(a::Associative = ENV)
    result = (lowercase(strip(get(a, "CI", ""))) == "true") &&
        (lowercase(strip(get(a, "TRAVIS", ""))) == "true") &&
        (lowercase(strip(get(a, "CONTINUOUS_INTEGRATION", ""))) == "true")
    return result
end
