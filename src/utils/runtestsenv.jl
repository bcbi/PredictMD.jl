function is_runtests(a::Associative)
    result = lowercase(get(a, "PREDICTMD_RUNTESTS", "")) == lowercase("true")
    return result
end
