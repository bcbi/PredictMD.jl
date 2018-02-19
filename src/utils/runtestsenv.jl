function isruntests(a::Associative)
    result =
        lowercase(get(a, "ALUTHGESINHABASE_RUNTESTS", "")) == lowercase("true")
    return result
end
