##### Beginning of file

"""
"""
function is_travis_ci(a::AbstractDict = ENV)
    result = ( lowercase(strip(get(a, "CI", ""))) == "true" ) &&
        ( lowercase(strip(get(a, "TRAVIS", ""))) == "true" ) &&
        ( lowercase(strip(get(a, "CONTINUOUS_INTEGRATION", "")) ) == "true")
    return result
end

"""
"""
function is_travis_ci_on_linux(a::AbstractDict = ENV)
    result = is_travis_ci(a) && Sys.islinux()
    return result
end

"""
"""
function is_travis_ci_on_apple(a::AbstractDict = ENV)
    result = is_travis_ci(a) && Sys.isapple()
    return result
end

"""
"""
function is_appveyor_ci(a::AbstractDict = ENV)
    result = ( lowercase(strip(get(a, "CI", ""))) == "true" ) &&
        ( lowercase(strip(get(a, "APPVEYOR", ""))) == "true" )
    return result
end

"""
"""
is_ci(a::AbstractDict = ENV) = is_travis_ci(a) || is_appveyor_ci(a)

"""
"""
is_ci_or_runtests(a::AbstractDict = ENV) = is_ci(a) || is_runtests(a)

"""
"""
is_ci_or_runtests_or_docs_or_examples(a::AbstractDict = ENV) =
    is_ci_or_runtests(a) || is_docs_or_examples(a)

##### End of file
