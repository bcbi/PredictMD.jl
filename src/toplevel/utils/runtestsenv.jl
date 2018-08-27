##### Beginning of file

"""
"""
function is_runtests(a::Associative = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_RUNTESTS", ""))) ==
        "true"
    return result
end


"""
"""
function is_make_examples(a::Associative = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_MAKE_EXAMPLES", ""))) ==
        "true"
    return result
end


"""
"""
function is_make_docs(a::Associative = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_MAKE_DOCS", ""))) ==
        "true"
    return result
end

"""
"""
function is_deploy_docs(a::Associative = ENV)
    result = lowercase(strip(get(a, "PREDICTMD_IS_DEPLOY_DOCS", ""))) ==
        "true"
    return result
end

"""
"""
is_docs_or_examples(a::Associative = ENV) =
    is_make_examples(a) || is_make_docs(a) || is_deploy_docs(a)

##### End of file
