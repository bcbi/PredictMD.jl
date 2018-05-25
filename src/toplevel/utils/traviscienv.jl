"""
"""
function is_travis_ci(a::Associative)
    result = (lowercase(get(a, "CI", "")) == lowercase("true")) &&
        (lowercase(get(a, "TRAVIS", "")) == lowercase("true")) &&
        (lowercase(get(a, "CONTINUOUS_INTEGRATION", "")) == lowercase("true"))
    return result
end
