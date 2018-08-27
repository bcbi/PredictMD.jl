##### Beginning of file

"""
"""
function is_travis_ci(a::Associative = ENV)
    result = ( lowercase(strip(get(a, "CI", ""))) == "true" ) &&
        ( lowercase(strip(get(a, "TRAVIS", ""))) == "true" ) &&
        ( lowercase(strip(get(a, "CONTINUOUS_INTEGRATION", "")) ) == "true")
    return result
end

"""
"""
function is_travis_ci_on_linux(a::Associative = ENV)
    result = is_travis_ci(a) && is_linux()
    return result
end

"""
"""
function is_travis_ci_on_apple(a::Associative = ENV)
    result = is_travis_ci(a) && is_apple()
    return result
end

"""
"""
function is_appveyor_ci(a::Associative = ENV)
    result = ( lowercase(strip(get(a, "CI", ""))) == "true" ) &&
        ( lowercase(strip(get(a, "APPVEYOR", ""))) == "true" )
    return result
end

"""
"""
is_ci(a::Associative = ENV) = is_travis_ci(a) || is_appveyor_ci(a)

"""
"""
is_ci_or_runtests(a::Associative = ENV) = is_ci(a) || is_runtests(a)

"""
"""
is_ci_or_runtests_or_docs_or_examples(a::Associative = ENV) =
    is_ci_or_runtests(a) || is_docs_or_examples(a)

##### End of file
