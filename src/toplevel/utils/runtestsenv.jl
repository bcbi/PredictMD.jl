"""
"""
function is_runtests(a::AbstractDict = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_RUNTESTS", ""))) ==
        "true"
    return result
end


"""
"""
function is_make_examples(a::AbstractDict = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_MAKE_EXAMPLES", ""))) ==
        "true"
    return result
end


"""
"""
function is_make_docs(a::AbstractDict = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_MAKE_DOCS", ""))) ==
        "true"
    return result
end

"""
"""
function is_deploy_docs(a::AbstractDict = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_DEPLOY_DOCS", ""))) ==
        "true"
    return result
end

"""
"""
is_docs_or_examples(a::AbstractDict = ENV) =
    is_make_examples(a) || is_make_docs(a) || is_deploy_docs(a)

