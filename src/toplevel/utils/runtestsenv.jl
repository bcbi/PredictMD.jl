"""
"""
function is_runtests(a::Associative)
    result = lowercase(get(a, "PREDICTMD_IS_RUNTESTS", "")) == lowercase("true")
    return result
end

"""
"""
function is_make_examples(a::Associative)
    result = lowercase(get(a, "PREDICTMD_IS_MAKE_EXAMPLES", "")) == lowercase("true")
    return result
end

"""
"""
function is_make_docs(a::Associative)
    result = lowercase(get(a, "PREDICTMD_IS_MAKE_DOCS", "")) == lowercase("true")
    return result
end

"""
"""
function is_deploy_docs(a::Associative)
    result = lowercase(get(a, "PREDICTMD_IS_DEPLOY_DOCS", "")) == lowercase("true")
    return result
end
